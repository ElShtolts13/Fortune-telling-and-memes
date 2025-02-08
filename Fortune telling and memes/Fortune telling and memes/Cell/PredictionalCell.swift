//
//  PredictionalCell.swift
//  Fortune telling and memes
//
//  Created by Надежда Капацина on 08.02.2025.
//

import UIKit

class PredictionCell: UITableViewCell {
    
    // MARK: - UI Elements
    
    private let memeImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        //iv.layer.cornerRadius = 15
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let questionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let borderView: UIView = {
            let view = UIView()
            view.backgroundColor = .lightGray
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupUI() {
        contentView.addSubview(memeImageView)
        contentView.addSubview(questionLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(borderView)
        NSLayoutConstraint.activate([
            memeImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            memeImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            memeImageView.widthAnchor.constraint(equalToConstant: 80), // Фиксированная ширина
            memeImageView.heightAnchor.constraint(equalTo: memeImageView.widthAnchor, multiplier: 1.0), // Квадратное изображение
            
            // Соотношение сторон для изображения
            memeImageView.heightAnchor.constraint(lessThanOrEqualToConstant: 100), // Максимальная высота
            memeImageView.widthAnchor.constraint(lessThanOrEqualToConstant: 100), // Максимальная ширина
            
            questionLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            questionLabel.leadingAnchor.constraint(equalTo: memeImageView.trailingAnchor, constant: 16),
            questionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
                        
            dateLabel.topAnchor.constraint(equalTo: questionLabel.bottomAnchor, constant: 12),
            dateLabel.leadingAnchor.constraint(equalTo: memeImageView.trailingAnchor, constant: 16),
            dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            dateLabel.bottomAnchor.constraint(equalTo: borderView.topAnchor, constant: -8), // Привязка к верхней части границы
                        
            borderView.topAnchor.constraint(equalTo: memeImageView.bottomAnchor, constant: 5), // Отступ 5 поинтов ниже изображения
            borderView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            borderView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            borderView.heightAnchor.constraint(equalToConstant: 1), // Высота границы
            borderView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor) // Привязка к нижней части ячейки
        ])
    }
    // MARK: - Configure
    func configure(with prediction: Prediction) {
        questionLabel.text = """
        Ваш вопрос:
        \(prediction.question)
        """
          
          let dateFormatter = DateFormatter()
          dateFormatter.dateFormat = "dd.MM.yyyy HH:mm"
          dateLabel.text = dateFormatter.string(from: prediction.date)
          
          // Загрузка изображения
          if let url = URL(string: prediction.memeURL) {
              memeImageView.loadImage(from: url)
          }
      }
}

