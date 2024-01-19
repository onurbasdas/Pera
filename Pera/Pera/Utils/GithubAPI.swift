//
//  GithubAPI.swift
//  Pera
//
//  Created by Onur on 20.01.2024.
//

import Foundation

class GitHubAPI {
    static let shared = GitHubAPI()

    private init() {}

    func getRepositories(organization: String, completion: @escaping ([MainModel]?) -> Void) {
        let apiUrl = "https://api.github.com/orgs/\(organization)/repos"

        guard let url = URL(string: apiUrl) else {
            completion(nil)
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }

            do {
                let repositories = try JSONDecoder().decode([MainModel].self, from: data)
                completion(repositories)
            } catch {
                print("JSON decoding error: \(error.localizedDescription)")
                completion(nil)
            }
        }.resume()
    }
}
