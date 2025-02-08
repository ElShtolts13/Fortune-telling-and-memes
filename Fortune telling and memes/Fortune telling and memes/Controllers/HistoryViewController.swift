//
//  HistoryViewController.swift
//  Fortune telling and memes
//
//  Created by Надежда Капацина on 06.02.2025.
//

import UIKit

class HistoryViewController: UIViewController {
    
    // MARK: - Properties
    
    private let tableView = UITableView()
    private var predictions: [Prediction] = []
    private let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
    

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadData()
        setupNavigation()
        
    }
    // MARK: - Setup Methods
    
    func setupUI() {
        
        title = "История"
        backgroundImage.image = UIImage(named: "sunny")
        backgroundImage.contentMode = .scaleAspectFill
        
        tableView.register(PredictionCell.self, forCellReuseIdentifier: "PredictionCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 104, bottom: 0, right: 0) // Отступ для изображения
        view.addSubview(backgroundImage)
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            backgroundImage.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func loadData() {
        predictions = StorageManager.shared.loadAll()
        tableView.reloadData()
    }
    // MARK: - Navigation
    
    private func setupNavigation() {
        let backButton = UIBarButtonItem(
            image: UIImage(systemName: "arrowshape.backward"),
            style: .plain,
            target: self,
            action: #selector(back)
        )
        
        backButton.tintColor = .badRed
        
        navigationItem.leftBarButtonItem = backButton
    }
    
    @objc func back() {
        
        navigationController?.popViewController(animated: true)
        
    }
}


extension HistoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        predictions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PredictionCell", for: indexPath) as? PredictionCell else {
            return UITableViewCell()
        }
        
        let prediction = predictions[indexPath.row]
        cell.configure(with: prediction)
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            StorageManager.shared.delete(at: indexPath.row)
            loadData()
        }
    }
    
}
