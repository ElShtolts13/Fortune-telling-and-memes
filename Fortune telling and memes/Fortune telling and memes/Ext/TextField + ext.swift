//
//  TextField + ext.swift
//  Fortune telling and memes
//
//  Created by Надежда Капацина on 03.02.2025.
//

import UIKit

extension UITextField {
    func setPlaceholder(color: UIColor, text: String, font: UIFont? = nil) {
        var attributes: [NSAttributedString.Key: Any] = [.foregroundColor: color]
        if let font = font {
            attributes[.font] = font
        }
        attributedPlaceholder = NSAttributedString(string: text, attributes: attributes)
    }
}


