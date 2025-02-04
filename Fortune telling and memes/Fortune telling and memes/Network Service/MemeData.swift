//
//  MemeData.swift
//  Fortune telling and memes
//
//  Created by Надежда Капацина on 03.02.2025.
//
struct MemeResponse: Codable {
    let success: Bool
    let data: MemeData
}

struct MemeData: Codable {
    let memes: [Meme]
}

struct Meme: Codable {
    let id: String
    let name: String
    let url: String
    let width: Int
    let height: Int
    let boxCount: Int
    
    private enum CodingKeys: String, CodingKey {
        case id, name, url, width, height
        case boxCount = "box_count"
    }
}

