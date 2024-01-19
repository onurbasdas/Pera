//
//  DetailViewModel.swift
//  Pera
//
//  Created by Onur on 20.01.2024.
//

import Foundation

class DetailViewModel {
    private let repository: MainModel
    private var isFavorite: Bool
    
    init(repository: MainModel, isFavorite: Bool) {
        self.repository = repository
        self.isFavorite = UserDefaults.standard.bool(forKey: repository.isFavoriteKey)
    }
    
    func toggleFavoriteStatus() {
        isFavorite.toggle()
        UserDefaults.standard.set(isFavorite, forKey: repository.isFavoriteKey)
    }
    
    func isRepositoryFavorite() -> Bool {
        return isFavorite
    }
    
    func getRepository() -> MainModel {
        return repository
    }
    
    func setFavoriteStatus(_ isFavorite: Bool) {
        self.isFavorite = isFavorite
    }
    
    var favoriteKey: String {
        return "FavoriteStatus_\(repository.id)"
    }
}
