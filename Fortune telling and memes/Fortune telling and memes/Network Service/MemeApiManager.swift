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
            return
        }
        
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            guard let data = data, let image = UIImage(data: data) else {
                completion(nil)
                return
            }
            
            self?.casheImage.setObject(image, forKey: urlString as NSString)
            completion(image)
        }.resume()
    }

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
}

}
