//
//  StorageManager.swift
//  Fortune telling and memes
//
//  Created by Надежда Капацина on 05.02.2025.
//

import UIKit

class StorageManager {
    
    static let shared = StorageManager()
    private let key = "SavedPredictions"
    
    func save(prediction: Prediction) {
        var predictions = loadAll()
        predictions.append(prediction)
        
    }
    
    func loadAll() -> [Prediction] {
         guard let data = UserDefaults.standard.data(forKey: key),
               let predictions = try? JSONDecoder().decode([Prediction].self, from: data)
         else { return [] }
         
         return predictions
     }

    func delete(at index: Int) {
        var predictions = loadAll()
        predictions.remove(at: index)
        if let data = try? JSONEncoder().encode(predictions) {
                  UserDefaults.standard.set(data, forKey: key)
              }
           
        
    }
}
