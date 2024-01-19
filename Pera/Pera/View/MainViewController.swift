//
//  ViewController.swift
//  Pera
//
//  Created by Onur on 19.01.2024.
//

import UIKit
import SnapKit

class MainViewController: UIViewController {
    
    private let viewModel = MainViewModel()
    private var filteredRepositories: [MainModel] = []
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search Repositories"
        return searchBar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchData()
    }
    
    private func setupUI() {
        // Navigasyon çubuğunu gizle
        navigationController?.isNavigationBarHidden = true
        
        view.backgroundColor = .white
        
        view.addSubview(searchBar)
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
        }
        searchBar.delegate = self
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func fetchData() {
        let organizations = ["algorand", "perawallet", "algorandfoundation"]
        
        viewModel.fetchRepositories(for: organizations) { [weak self] in
            self?.filteredRepositories = self?.viewModel.repositories ?? []
            self?.tableView.reloadData()
        }
    }
    
    func showRepositoryDetailScreen(for repository: MainModel) {
        let detailViewModel = DetailViewModel(repository: repository, isFavorite: viewModel.isRepositoryFavorite(repository))
        let detailViewController = DetailViewController(viewModel: detailViewModel)
        detailViewController.delegate = self
        detailViewController.modalPresentationStyle = .fullScreen
        self.present(detailViewController, animated: true)
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredRepositories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let repository = filteredRepositories[indexPath.row]
        cell.textLabel?.text = repository.name
        cell.accessoryType = viewModel.isRepositoryFavorite(repository) ? .checkmark : .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let repository = filteredRepositories[indexPath.row]
        showRepositoryDetailScreen(for: repository)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension MainViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredRepositories = viewModel.repositories
        } else {
            filteredRepositories = viewModel.repositories.filter {
                if let name = $0.name {
                    return name.lowercased().contains(searchText.lowercased())
                }
                return false
            }
        }
        tableView.reloadData()
    }
}

extension MainViewController: RepositoryDetailDelegate {
    func didToggleFavoriteStatus(for repository: MainModel) {
        viewModel.toggleFavoriteStatus(for: repository)
        
        if viewModel.isRepositoryFavorite(repository) {
            tableView.reloadData()
        } else {
            if let index = filteredRepositories.firstIndex(where: { $0.name == repository.name }) {
                tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
            }
        }
    }
}
