//
//  Untitled.swift
//  screenScene
//
//  Created by RAMPU on 17.11.2024..
//

import Foundation
import SwiftData

@Model
class Movie : Identifiable {
    var id: String
    var name: String
    var releaseDate: Date
    var genre: String
    init(name: String, releaseDate: Date, genre: String) {
        self.name = name
        self.releaseDate = releaseDate
        self.genre = genre
        self.id = UUID().uuidString
    }
}
