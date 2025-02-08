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
    private let questionLabel = UILabel()
    
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
        setupNavigation()
    }
    
    // MARK: - Setup Methods
    private func setupUI() {
        title = "Мемное гадание🔮"
        view.backgroundColor = .white
        backgroundImage.image = UIImage(named: "background1")
        backgroundImage.contentMode = .scaleAspectFill
        
        glass.tintColor = .skyBlue
        glass.translatesAutoresizingMaskIntoConstraints = false
        
        questionTextField.setPlaceholder(
            color: .white,
            text: "Задай свой вопрос....",
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
        
        questionLabel.textAlignment = .center
        questionLabel.isHidden = true
        questionLabel.textColor = .badRed
        questionLabel.numberOfLines = 0
        questionLabel.translatesAutoresizingMaskIntoConstraints = false
        questionLabel.text = ""
        questionLabel.font = .systemFont(ofSize: 20, weight: .medium)
        questionLabel.adjustsFontSizeToFitWidth = true
        questionLabel.minimumScaleFactor = 0.5
        questionLabel.lineBreakMode = .byWordWrapping
        
        questionTextField.autocapitalizationType = .sentences
        questionTextField.autocorrectionType = .yes
        questionTextField.returnKeyType = .done
        questionTextField.delegate = self
        
        
        memeImageView.contentMode = .scaleAspectFit
        memeImageView.translatesAutoresizingMaskIntoConstraints = false
        memeImageView.isHidden = true
        memeImageView.layer.masksToBounds = true
        
        memeImageView.layer.cornerRadius = 30
        memeImageView.layer.masksToBounds = true
        memeImageView.clipsToBounds = true
        
        configureReactionButtons()
        
        view.addSubview(backgroundImage)
        view.addSubview(questionTextField)
        view.addSubview(predictButton)
        view.addSubview(memeImageView)
        view.addSubview(buttonsStackView)
        view.addSubview(questionLabel)
        iconContainer.addSubview(glass)
    }
    
    func configureReactionButtons() {
        buttonsStackView.axis = .horizontal
        buttonsStackView.spacing = 10
        buttonsStackView.distribution = .fillEqually
        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
        buttonsStackView.isHidden = true
        
        [("❤️", #selector(savePrediction), UIColor.goodGreen),
         ("💔", #selector(loadNewMeme), UIColor.badRed),
         ("🔄", #selector(resetToInitialState), UIColor.systemBlue)].forEach {
            let button = UIButton()
            button.setTitle($0.0, for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 30)
            //button.layer.cornerRadius = 10
            //button.backgroundColor = $0.2
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
            
            questionTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            questionTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            questionTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            questionTextField.heightAnchor.constraint(equalToConstant: 50),
            
            predictButton.topAnchor.constraint(equalTo: questionTextField.bottomAnchor, constant: 20),
            predictButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            predictButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            predictButton.heightAnchor.constraint(equalToConstant: 44),
            
            questionLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            questionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            questionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            memeImageView.topAnchor.constraint(equalTo: questionLabel.bottomAnchor, constant: 5),
            memeImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            memeImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            memeImageView.bottomAnchor.constraint(lessThanOrEqualTo: buttonsStackView.topAnchor, constant: -10),
            
            buttonsStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -120),
            buttonsStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonsStackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            buttonsStackView.heightAnchor.constraint(equalToConstant: 40)
            
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
        guard let question = questionTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              !question.isEmpty else {
            // Анимация и подсветка пустого поля
            animateEmptyTextField()
            return
        }
        
        questionTextField.isHidden = true
        questionLabel.text = "Ваш вопрос: \(question)"
        questionLabel.isHidden = false
        showRandomMeme()
        buttonsStackView.isHidden = false
        backgroundImage.image = UIImage(named: "backgroundFin")
    }
    
    @objc func savePrediction() {
        
        guard let question = questionTextField.text,
              let meme = currentMeme else { return }
        
        let prediction = Prediction(
            question: question,
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
    @objc func showHistory() {
        let historyVC = HistoryViewController()
        navigationController?.pushViewController(historyVC, animated: true)
        
    }
    @objc private func resetToInitialState() {
        UIView.animate(withDuration: 0.3) {
            // Сбрасываем все элементы в исходное состояние
            self.questionTextField.isHidden = false
            self.questionLabel.isHidden = true
            self.predictButton.isHidden = false
            self.memeImageView.isHidden = true
            self.buttonsStackView.isHidden = true
            self.backgroundImage.image = UIImage(named: "background1")
            
            // Очищаем поля
            self.questionTextField.text = ""
            self.memeImageView.image = nil
            self.questionLabel.text = ""
            
            // Возвращаем оригинальный плейсхолдер
            self.questionTextField.setPlaceholder(
                color: .white,
                text: "🧸 Задай свой вопрос....",
                font: .systemFont(ofSize: 18)
            )
        }
    }
        
        // MARK: - Helpers
        
        private func animateEmptyTextField() {
            // Анимация дрожания
            let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
            animation.timingFunction = CAMediaTimingFunction(name: .linear)
            animation.duration = 0.6
            animation.values = [-10, 10, -7, 7, -5, 5, 0]
            questionTextField.layer.add(animation, forKey: "shake")
            
            // Изменение плейсхолдера
            let attributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: UIColor.badRed,
                .font: UIFont.systemFont(ofSize: 18)
            ]
            questionTextField.attributedPlaceholder = NSAttributedString(
                string: "Вы не задали вопрос!",
                attributes: attributes
            )
            
            // Мигание границы
            UIView.animate(withDuration: 0.3) {
                self.questionTextField.layer.borderColor = UIColor.badRed.cgColor
                self.questionTextField.layer.borderWidth = 1
                self.questionTextField.layer.cornerRadius = 10
            } completion: { _ in
                UIView.animate(withDuration: 0.3) {
                    self.questionTextField.layer.borderWidth = 0
                }
            }
        }
        private func showRandomMeme() {
            guard let meme = memes.randomElement() else { return }
            currentMeme = meme
            predictButton.isHidden = true
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
        
        // MARK: - Navigation
        
        private func setupNavigation() {
            let historyButton = UIBarButtonItem(
                image: UIImage(systemName: "bookmark"),
                style: .plain,
                target: self,
                action: #selector(showHistory)
            )
            
            historyButton.tintColor = .badRed
            
            navigationItem.rightBarButtonItem = historyButton
        }
    }
extension MemsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
