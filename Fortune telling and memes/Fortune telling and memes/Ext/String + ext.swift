//
//  String + ext.swift
//  Fortune telling and memes
//
//  Created by Надежда Капацина on 04.02.2025.
//

extension String {
    var isReallyEmpty: Bool {
        return trimmingCharacters(in: .whitespaces).isEmpty
    }
}
