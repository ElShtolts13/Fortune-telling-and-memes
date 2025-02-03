//
//  ViewController.swift
//  Fortune telling and memes
//
//  Created by Надежда Капацина on 02.02.2025.
//

import UIKit

class MemsViewController: UIViewController {
    
    // MARK: - UI elements
    private let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
    private let questionTextField = UITextField()
    private let predictButton = UIButton()
    private let memeImageView = UIImageView()
    private let buttonsStackView = UIStackView()
    private let acceptButton = UIButton()
    private let rejectButton = UIButton()
    
    let iconContainer = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 30))
    let glass = UIImageView(image: UIImage(systemName: "magnifyingglass"))

    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
    }

    // MARK: - Setup Methods
    private func setupUI() {
        
        backgroundImage.image = UIImage(named: "background1")
        backgroundImage.contentMode = .scaleAspectFit
        glass.tintColor = .skyBlue
        glass.translatesAutoresizingMaskIntoConstraints = false
        
        questionTextField.placeholder = "🌝 Задай свой вопрос..."
        questionTextField.borderStyle = .roundedRect
        questionTextField.backgroundColor = .graySky

        questionTextField.translatesAutoresizingMaskIntoConstraints = false
        
        questionTextField.leftView = iconContainer
        questionTextField.leftViewMode = .always
        questionTextField.layer.cornerRadius = 10
        questionTextField.clipsToBounds = true
        
        predictButton.setTitle("✨Получить предсказание✨", for: .normal)
        predictButton.backgroundColor = .skyBlue
        predictButton.layer.cornerRadius = 10
        predictButton.translatesAutoresizingMaskIntoConstraints = false
        predictButton.addTarget(self, action: #selector(predictButtonPressed), for: .touchUpInside)
        
        memeImageView.contentMode = .scaleAspectFit
        memeImageView.translatesAutoresizingMaskIntoConstraints = false
        memeImageView.image = UIImage(named: "demo_meme")
        memeImageView.isHidden = true
        memeImageView.layer.masksToBounds = true
        
        memeImageView.layer.cornerRadius = 40
        memeImageView.layer.masksToBounds = true
        memeImageView.clipsToBounds = true
        
        configureReactionButtons()
        
        view.addSubview(backgroundImage)
        view.addSubview(questionTextField)
        view.addSubview(predictButton)
        view.addSubview(memeImageView)
        view.addSubview(buttonsStackView)
        iconContainer.addSubview(glass)

       
        
    }
    
    func configureReactionButtons() {
        buttonsStackView.axis = .horizontal
        buttonsStackView.spacing = 20
        buttonsStackView.distribution = .fillEqually
        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
        buttonsStackView.isHidden = true
        
        [("👍", #selector(savePrediction), UIColor.green), ("👎", #selector(loadNewMeme), UIColor.red)].forEach {
            let button = UIButton()
            button.backgroundColor = $0.2
            button.setTitle($0.0, for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 40)
            button.layer.cornerRadius = 10
            button.translatesAutoresizingMaskIntoConstraints = false
            button.addTarget(self, action: $0.1, for: .touchUpInside)
            buttonsStackView.addArrangedSubview(button)
        }
        
    }
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            
            backgroundImage.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            glass.leadingAnchor.constraint(equalTo: iconContainer.leadingAnchor, constant: 8),
            glass.trailingAnchor.constraint(equalTo: iconContainer.trailingAnchor, constant: -8),
            glass.centerYAnchor.constraint(equalTo: iconContainer.centerYAnchor),
            
            questionTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            questionTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            questionTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            questionTextField.heightAnchor.constraint(equalToConstant: 50),
            
            
            predictButton.topAnchor.constraint(equalTo: questionTextField.bottomAnchor, constant: 20),
            predictButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            predictButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            predictButton.heightAnchor.constraint(equalToConstant: 44),
            
            
            memeImageView.topAnchor.constraint(equalTo: predictButton.bottomAnchor, constant: 10),
            memeImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            memeImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            memeImageView.heightAnchor.constraint(equalToConstant: 300),
            
           
            buttonsStackView.topAnchor.constraint(equalTo: memeImageView.bottomAnchor, constant: 10),
            buttonsStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonsStackView.widthAnchor.constraint(equalToConstant: 200),
            buttonsStackView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    // MARK: - Actions
    @objc func predictButtonPressed() {
        guard !(questionTextField.text?.isReallyEmpty ?? true) else { return }
        memeImageView.image = UIImage(named: "demo_meme")
        memeImageView.isHidden = false
        buttonsStackView.isHidden = false
    }
    @objc func savePrediction() {
        
    }
    @objc func loadNewMeme() {
        
    }
}

extension String {
    var isReallyEmpty: Bool {
        return trimmingCharacters(in: .whitespaces).isEmpty
    }
}
