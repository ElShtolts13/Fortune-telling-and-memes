//
//  MemeApiManager.swift
//  Fortune telling and memes
//
//  Created by Надежда Капацина on 04.02.2025.
//

import Foundation
import UIKit

final class APIManager {
    
    static let shared = APIManager()
    private let casheImage = NSCache<NSString, UIImage>()
    private init() {}
    
    func fetchMemes(completion: @escaping (Result<[Meme], Error>) -> Void) {
        let urlString = "https://api.imgflip.com/get_memes"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(MemeResponse.self, from: data)
                completion(.success(response.data.memes))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func loadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        
        if let cachedImage = casheImage.object(forKey: urlString as NSString) {
            completion(cachedImage)
            print("✅ Используем кешированное изображение: \(urlString)")
            return
        }
        
        guard let url = URL(string: urlString) else {
            print("⚠️ Некорректный URL: \(urlString)")
            completion(nil)
            return
        }
        
        // Настройка запроса
        let request = URLRequest(
            url: url,
            cachePolicy: .returnCacheDataElseLoad,
            timeoutInterval: 15
        )
        
        print("🌐 Начинаем загрузку: \(urlString)")
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            // Обработка ошибок
            if let error = error {
                print("❗️ Ошибка загрузки: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            // Проверка статус кода
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                print("❗️ Некорректный статус код: \((response as? HTTPURLResponse)?.statusCode ?? -1)")
                completion(nil)
                return
            }
            
            // Преобразование данных
            guard let data = data, !data.isEmpty else {
                print("❗️ Получены пустые данные")
                completion(nil)
                return
            }
            
            // Декодирование изображения
            guard let image = UIImage(data: data) else {
                print("❗️ Не удалось создать изображение из данных")
                completion(nil)
                return
            }
            
            // Кеширование
            self?.casheImage.setObject(image, forKey: urlString as NSString)
            print("✅ Успешно загружено: \(urlString)")
            
            completion(image)
            
        }.resume()
    }

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
}

}
