//
//  ViewController.swift
//  Pera
//
//  Created by Onur on 19.01.2024.
//

import UIKit
import SnapKit

enum URLEnpointTypes : String {
    case all
    case algorand = "algorand"
    case perawallet = "perawallet"
    case algorandfoundation = "algorandfoundation"
}

class MainViewController: UIViewController {
    
    private let viewModel = MainViewModel()
    private var filteredRepositories: [MainModel] = []
    
    private var selectedURLType : URLEnpointTypes?
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search Repositories"
        searchBar.searchBarStyle = .default
        return searchBar
    }()
    
    private let segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["All", "algorand", "perawallet", "algorandfoundation"])
        segmentedControl.selectedSegmentIndex = 0
        return segmentedControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchData()
    }

    private func setupUI() {
        view.backgroundColor = .white

        // Add segmented control
        view.addSubview(segmentedControl)
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged), for: .valueChanged)

        // Add searchBar
        view.addSubview(searchBar)
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(segmentedControl.snp.bottom)
            make.leading.trailing.equalToSuperview()
        }
        searchBar.delegate = self

        // Add tableView
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        // Update segmented control constraints
        segmentedControl.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(40)  // Adjust the height as needed
        }

        // Set up dataSource and delegate
        tableView.dataSource = self
        tableView.delegate = self
    }


    @objc private func segmentedControlValueChanged() {
        // Handle segmented control value changes here
        searchBar.text = nil
        view.endEditing(true)
        let selectedTabIndex = segmentedControl.selectedSegmentIndex
        switch selectedTabIndex {
        case 0:
            selectedURLType = .all
            filteredRepositories = self.viewModel.repositories
        case 1:
            selectedURLType = .algorand
            filteredRepositories = self.viewModel.alorant
        case 2:
            selectedURLType = .perawallet
            filteredRepositories = self.viewModel.perawallet
        case 3:
            selectedURLType = .algorandfoundation
            filteredRepositories = self.viewModel.algorandfoundation
        default:
            return
        }
        self.tableView.reloadData()
        
    }
    
    private func fetchData() {
        let organizations = [URLEnpointTypes.algorand.rawValue,
                             URLEnpointTypes.perawallet.rawValue,
                             URLEnpointTypes.algorandfoundation.rawValue]
        
        
        viewModel.fetchRepositories(for: organizations) { [weak self] in
            self?.filteredRepositories = self?.viewModel.repositories ?? []
            
            self?.tableView.reloadData()
        }
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
    
    func showRepositoryDetailScreen(for repository: MainModel) {
        let detailViewModel = DetailViewModel(repository: repository, isFavorite: viewModel.isRepositoryFavorite(repository))
        let detailViewController = DetailViewController(viewModel: detailViewModel)
        detailViewController.delegate = self
        detailViewController.modalPresentationStyle = .fullScreen
        self.present(detailViewController, animated: true)
    }
}

extension MainViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        var modelToSearchIn : [MainModel] = []
        switch selectedURLType {
        case .all:
            modelToSearchIn = viewModel.repositories
        case .algorand:
            modelToSearchIn = viewModel.alorant
        case .perawallet:
            modelToSearchIn = viewModel.perawallet
        case .algorandfoundation:
            modelToSearchIn = viewModel.algorandfoundation
        default:
            return
        }
        
        if searchText.isEmpty {
            filteredRepositories = modelToSearchIn
        } else {
            filteredRepositories = modelToSearchIn.filter {
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
