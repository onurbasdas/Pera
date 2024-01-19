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

    func fetchRepositories(for organizations: [String], completion: @escaping () -> Void) {
        var allRepos: [MainModel] = []

        let group = DispatchGroup()

        for organization in organizations {
            group.enter()

            GitHubAPI.shared.getRepositories(organization: organization) { [weak self] repos in
                defer {
                    group.leave()
                }

                if let repos = repos {
                    allRepos.append(contentsOf: repos)
                }
            }
        }

        group.notify(queue: .main) { [weak self] in
            // Tüm organizasyonlardan alınan repolar repositories dizisine eklenir.
            self?.repositories = allRepos
            completion()
        }
    }


    func numberOfRepositories() -> Int {
        return repositories.count
    }

    func repository(at index: Int) -> MainModel {
        return repositories[index]
    }

    func toggleFavoriteStatus(for repository: MainModel) {
        if favoriteRepositories.contains(where: { $0.name == repository.name }) {
            favoriteRepositories.removeAll { $0.name == repository.name }
        } else {
            favoriteRepositories.append(repository)
        }
    }

    func isRepositoryFavorite(_ repository: MainModel) -> Bool {
        return favoriteRepositories.contains(where: { $0.name == repository.name })
    }
}

