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

    // MARK: - Properties
    private let apiManager = APIManager.shared
    private var memes: [Meme] = []
    private var currentMeme: Meme?
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        loadMemes()
    }

    // MARK: - Setup Methods
    private func setupUI() {
        
        backgroundImage.image = UIImage(named: "background1")
        backgroundImage.contentMode = .scaleAspectFit
        glass.tintColor = .skyBlue
        glass.translatesAutoresizingMaskIntoConstraints = false
        
        questionTextField.setPlaceholder(
            color: .white,
            text: "🧸 Задай свой вопрос....",
            font: .systemFont(ofSize: 18)
        )
        questionTextField.borderStyle = .roundedRect
        questionTextField.backgroundColor = .sunny

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
        
        memeImageView.contentMode = .scaleAspectFill
        memeImageView.translatesAutoresizingMaskIntoConstraints = false
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
        
        [("❤️", #selector(savePrediction), UIColor.goodGreen), ("💔", #selector(loadNewMeme), UIColor.badRed)].forEach {
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
        backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        
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
            memeImageView.leadingAnchor.constraint(equalTo: predictButton.leadingAnchor),
            memeImageView.trailingAnchor.constraint(equalTo: predictButton.trailingAnchor),
            memeImageView.heightAnchor.constraint(equalToConstant: 300),
            
            buttonsStackView.topAnchor.constraint(equalTo: memeImageView.bottomAnchor, constant: 10),
            buttonsStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonsStackView.widthAnchor.constraint(equalToConstant: 200),
            buttonsStackView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    // MARK: - Network
    private func loadMemes() {
        apiManager.fetchMemes { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let memes):
                    self?.memes = memes
                case .failure(let error):
                   self?.showError(error)
                }
            }
        }
    }
    // MARK: - Actions
    @objc func predictButtonPressed() {
        guard !(questionTextField.text?.isReallyEmpty ?? true) else { return }
        
        showRandomMeme()
        buttonsStackView.isHidden = false
        backgroundImage.image = UIImage(named: "backgroundFin")
    }
    
    @objc func savePrediction() {
        guard let question = questionTextField.text,
        let meme = currentMeme else { return }

        let prediction = Prediction(
            quiestion: question,
            memeURL: meme.url,
            date: Date()
        )
        StorageManager.shared.save(prediction: prediction)
        
        let alert = UIAlertController(
            title: "Сохранено!",
            message: "Ваше предсказание сохранено",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    @objc func loadNewMeme() {
        showRandomMeme()
    }
    // MARK: - Helpers
    
    private func showRandomMeme() {
        guard let meme = memes.randomElement() else { return }
        currentMeme = meme
        
        // Показываем индикатор загрузки
        memeImageView.image = nil
        memeImageView.isHidden = false
        
        let activityIndicator = UIActivityIndicatorView(style: .large)
        memeImageView.addSubview(activityIndicator)
        
        activityIndicator.center = CGPoint(x: memeImageView.bounds.midX, y: memeImageView.bounds.midY)
        activityIndicator.startAnimating()
        
        apiManager.loadImage(from: meme.url) { [weak self] image in
            DispatchQueue.main.async {
                
                activityIndicator.stopAnimating()
                activityIndicator.removeFromSuperview()
                
                
                if let image = image {
                self?.memeImageView.image = image
                self?.animatedImageAppearance()
            }
                else {
                    self?.showImageLoadError()
                }
        }
    }
    }
    private func showError(_ error: Error) {
        let alert = UIAlertController(
            title: "Error",
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
        
    }
    private func animatedImageAppearance(){
        memeImageView.alpha = 0
        UIView.animate(withDuration: 0.5) {
            self.memeImageView.alpha = 1
        }
    }
    private func showImageLoadError() {
        let alert = UIAlertController(
            title: "Ошибка",
            message: "Не удалось загрузить мем",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
        
    }
}
