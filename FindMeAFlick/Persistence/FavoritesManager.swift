//
//  FavoritesManager.swift
//  FindMeAFlick
//
//  Created by P10 on 15/09/25.
//


import Foundation

final class FavoritesManager {
    static let shared = FavoritesManager()
    private let key = "favorite_movies_v1"
    private var favorites: [Movie] = []

    private init() {
        load()
    }

    func addFavorite(movie: Movie) {
        if !favorites.contains(where: { $0.id == movie.id }) {
            favorites.append(movie)
            save()
        }
    }
    func removeFavorite(movieId: Int) {
        favorites.removeAll { $0.id == movieId }
        save()
    }
    func isFavorite(movieId: Int) -> Bool {
        favorites.contains { $0.id == movieId }
    }
    func allFavorites() -> [Movie] {
        return favorites
    }

    private func save() {
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(favorites) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }
    private func load() {
        let decoder = JSONDecoder()
        if let data = UserDefaults.standard.data(forKey: key),
           let arr = try? decoder.decode([Movie].self, from: data) {
            favorites = arr
        }
    }
}
