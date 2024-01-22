//
//  MainViewModel.swift
//  Pera
//
//  Created by Onur on 19.01.2024.
//

import Foundation

class MainViewModel {
    var repositories: [MainModel] = []
    var favoriteRepositories: [MainModel] = []
    var alorant: [MainModel] = []
    var perawallet: [MainModel] = []
    var algorandfoundation: [MainModel] = []
    
    func fetchRepositories(for organizations: [String], completion: @escaping () -> Void) {
        var allRepos: [MainModel] = []
        var alorantFetched: [MainModel] = []
        var perawalletFetched: [MainModel] = []
        var algorandfoundationFetched: [MainModel] = []
        
        
        let group = DispatchGroup()
        
        for organization in organizations {
            group.enter()
            
            GitHubAPI.shared.getRepositories(organization: organization) { [weak self] repos in
                defer {
                    group.leave()
                }
                
                if let repos = repos {
                    allRepos.append(contentsOf: repos)
                    alorantFetched.append(contentsOf: repos.filter { $0.url?.contains(URLEnpointTypes.algorand.rawValue) == true })
                    perawalletFetched.append(contentsOf: repos.filter { $0.url?.contains(URLEnpointTypes.perawallet.rawValue) == true })
                    algorandfoundationFetched.append(contentsOf: repos.filter { $0.url?.contains(URLEnpointTypes.algorandfoundation.rawValue) == true})
                }
            }
        }
        
        group.notify(queue: .main) { [weak self] in
            self?.repositories = allRepos
            self?.alorant = alorantFetched
            self?.perawallet = perawalletFetched
            self?.algorandfoundation = algorandfoundationFetched
            completion()
        }
    }
    
    func toggleFavoriteStatus(for repository: MainModel) {
        if favoriteRepositories.contains(where: { $0.name == repository.name }) {
            favoriteRepositories.removeAll { $0.name == repository.name }
        } else {
            favoriteRepositories.append(repository)
        }
    }
    
    func isRepositoryFavorite(_ repository: MainModel) -> Bool {
        return UserDefaults.standard.bool(forKey: repository.isFavoriteKey)
    }
}
