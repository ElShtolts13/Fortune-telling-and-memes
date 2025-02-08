//
//  StorageNodel.swift
//  Fortune telling and memes
//
//  Created by Надежда Капацина on 05.02.2025.
//

import Foundation

struct Prediction: Codable {
    let question: String
    let memeURL: String
    let date: Date
}

