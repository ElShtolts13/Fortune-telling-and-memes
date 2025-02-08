//
//  StorageManager.swift
//  Fortune telling and memes
//
//  Created by Надежда Капацина on 05.02.2025.
//

import UIKit

class StorageManager {
    static let shared = StorageManager()
    private let key = "savedPredictions"
    
    func save(prediction: Prediction) {
        var predictions = loadAll()
        predictions.append(prediction)
        
        do {
            let data = try JSONEncoder().encode(predictions)
            UserDefaults.standard.set(data, forKey: key)
            print("✅ Успешно сохранено: \(prediction)")
        } catch {
            print("❗️ Ошибка сохранения: \(error)")
        }
    }
    
    func loadAll() -> [Prediction] {
        guard let data = UserDefaults.standard.data(forKey: key) else {
            print("ℹ️ Нет сохраненных данных")
            return []
        }
        
        do {
            return try JSONDecoder().decode([Prediction].self, from: data)
        } catch {
            print("❗️ Ошибка загрузки: \(error)")
            return []
        }
    }
    func delete(at index: Int) {
        var predictions = loadAll()
        predictions.remove(at: index)
        if let data = try? JSONEncoder().encode(predictions) {
                  UserDefaults.standard.set(data, forKey: key)
              }
           
        
    }
}
