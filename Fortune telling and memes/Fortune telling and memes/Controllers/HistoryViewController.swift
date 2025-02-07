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
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadData()
        
    }
    // MARK: - Setup Methods
    
    func setupUI() {
        view.backgroundColor = .goodGreen
        title = "История"
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
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
}

extension HistoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        predictions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let prediction = predictions[indexPath.row]
        
        let dateFormater = DateFormatter()
        
        dateFormater.dateFormat = "dd.MM.yyyy HH:mm"
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = """
                Вопрос: \(prediction.quiestion)
                Дата: \(dateFormater.string(from: prediction.date))
                """
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            StorageManager.shared.delete(at: indexPath.row)
            loadData()
        }
    }
    
}
