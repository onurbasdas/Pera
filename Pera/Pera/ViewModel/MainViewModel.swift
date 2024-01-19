//
//  MainViewModel.swift
//  Pera
//
//  Created by Onur on 19.01.2024.
//

import Foundation

class MainViewModel {
    private var repositories: [MainModel] = []
    
    func fetchRepositories(for organizations: [String], completion: @escaping () -> Void) {
        let dispatchGroup = DispatchGroup()
        
        for organization in organizations {
            dispatchGroup.enter()
            GitHubAPI.shared.getRepositories(organization: organization) { [weak self] repos in
                if let repos = repos {
                    self?.repositories.append(contentsOf: repos)
                }
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            completion()
        }
    }
    
    func numberOfRepositories() -> Int {
        return repositories.count
    }
    
    func repository(at index: Int) -> MainModel {
        return repositories[index]
    }
}
