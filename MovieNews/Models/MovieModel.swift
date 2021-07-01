//
//  MovieModel.swift
//  MovieNews
//
//  Created by Kevin Huang on 01/07/21.
//

import Foundation

struct MovieModel: Codable {
    let title: String
    let description: String
    let release_date: String
    let director: String
}

extension MovieModel {
    init?(data: Data) {
        guard let createNew = try? JSONDecoder().decode(MovieModel.self, from: data) else {
            return nil
        }
        self = createNew
    }
}
