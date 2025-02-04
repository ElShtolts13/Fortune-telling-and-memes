//
//  MemeApiManager.swift
//  Fortune telling and memes
//
//  Created by Надежда Капацина on 04.02.2025.
//

import Foundation

final class MemeAPIManager {
    

    

  
    func fetchData(oneComplection: @escaping([Meme]) -> ()) {

        let urlString = "https://api.imgflip.com/get_memes"

        guard let url = URL(string: urlString) else {
            print("Неправильный URL")
            return
        }

      let task = URLSession.shared.dataTask(with: url) {(data, resp, error) in
            
          if let error = error {
              print("Error: \(error.localizedDescription)")
              return
          }
            guard  let data = data else {
                print("data was nil")
                return
            }
            
            guard let  MemeData = try? JSONDecoder().decode(MemeData.self, from: data) else {
                print("couldn't decode json")
                return
            }
          //oneComplection(MemeData.memes)
        }
        task.resume()
    }
}
