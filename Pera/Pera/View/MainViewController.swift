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
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchData()
    }
    
    private func setupUI() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func fetchData() {
        let organizations = ["algorand", "perawallet", "algorandfoundation"]
        
        viewModel.fetchRepositories(for: organizations) { [weak self] in
            self?.tableView.reloadData()
        }
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRepositories()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let repository = viewModel.repository(at: indexPath.row)
        cell.textLabel?.text = repository.name
        return cell
    }
    
    // MARK: - TableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let repository = viewModel.repository(at: indexPath.row)
        showRepositoryDetailScreen(for: repository)
    }
    
    func showRepositoryDetailScreen(for repository: MainModel) {
        
    }
}
