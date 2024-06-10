//
//  MovieDataService.swift
//  Habbangine
//
//  Created by 윤제 on 6/10/24.
//

import Foundation

import SwiftData

protocol MovieDataServiceProtocol {
    func insertMovie(movie: Movie) async
    func fetchMovie() async -> [Movie]
}

final class MovieDataService: MovieDataServiceProtocol {
    
    static let shared = MovieDataService()
    
    private init() {}
    
    var container: ModelContainer {
        let modelConfiguration = ModelConfiguration()
        
        do {
            let modelContainer = try ModelContainer(for: Movie.self, configurations: modelConfiguration)
            return modelContainer
        } catch {
            fatalError()
        }
    }
    
    func insertMovie(movie: Movie) async {
        let context = await container.mainContext
        context.insert(movie)
    
        do {
            try context.save()
        } catch {
            fatalError()
        }
    }
    
    func fetchMovie() async -> [Movie] {
        let context = await container.mainContext
        
        let descriptor = FetchDescriptor<Movie>()
        
        do {
            let movies = try context.fetch(descriptor)
            return movies
        } catch {
            fatalError()
        }
    }
}
