//
//  UIImage + ext.swift
//  Fortune telling and memes
//
//  Created by Надежда Капацина on 08.02.2025.
//

import UIKit

extension UIImageView {
    func loadImage(from url: URL) {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        activityIndicator.startAnimating()
        
        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.image = image
                    activityIndicator.stopAnimating()
                    activityIndicator.removeFromSuperview()
                }
            } else {
                DispatchQueue.main.async {
                    activityIndicator.stopAnimating()
                    activityIndicator.removeFromSuperview()
                    self.image = UIImage(named: "placeholder") // Заглушка
                }
            }
        }.resume()
    }
}
