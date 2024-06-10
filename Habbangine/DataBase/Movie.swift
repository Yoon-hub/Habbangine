//
//  Movie.swift
//  Habbangine
//
//  Created by 윤제 on 6/10/24.
//

import Foundation

import SwiftData

@Model
class Movie {
    @Attribute(.externalStorage) var images: [Data]
    @Attribute(.unique) var title: String
    var content: String
    var date: Date
    
    init(images: [Data], title: String, content: String, date: Date) {
        self.images = images
        self.title = title
        self.content = content
        self.date = date
    }
}

