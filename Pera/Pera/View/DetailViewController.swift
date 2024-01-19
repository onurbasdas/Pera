//
//  DetailViewController.swift
//  Pera
//
//  Created by Onur on 20.01.2024.
//

import UIKit
import SnapKit

protocol RepositoryDetailDelegate: AnyObject {
    func didToggleFavoriteStatus(for repository: MainModel)
}

class DetailViewController: UIViewController {
    weak var delegate: RepositoryDetailDelegate?
    private let viewModel: DetailViewModel
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.numberOfLines = 0
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        return label
    }()
    
    private let favoriteButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.systemBlue, for: .normal)
        return button
    }()
    
    init(viewModel: DetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        updateUI()
        loadFavoriteStatus()
        self.view.backgroundColor = .white
    }
    
    private func setupUI() {
        view.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        view.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        favoriteButton.addTarget(self, action: #selector(toggleFavorite), for: .touchUpInside)
        updateFavoriteButton()
        
        view.addSubview(favoriteButton)
        favoriteButton.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
    }
    
    private func updateUI() {
        nameLabel.text = viewModel.getRepository().name
        descriptionLabel.text = viewModel.getRepository().description
    }
    
    private func updateFavoriteButton() {
        if viewModel.isRepositoryFavorite() {
            favoriteButton.setTitle("Remove from Favorites", for: .normal)
        } else {
            favoriteButton.setTitle("Add to Favorites", for: .normal)
        }
    }
    
    @objc private func toggleFavorite() {
        viewModel.toggleFavoriteStatus()
        updateFavoriteButton()
        updateUserDefaults()
        delegate?.didToggleFavoriteStatus(for: viewModel.getRepository())
    }
    
    private func updateUserDefaults() {
        let isFavorite = viewModel.isRepositoryFavorite()
        UserDefaults.standard.set(isFavorite, forKey: String(viewModel.getRepository().id))
    }
    
    private func loadFavoriteStatus() {
        let isFavorite = UserDefaults.standard.bool(forKey: String(viewModel.getRepository().id))
        viewModel.setFavoriteStatus(isFavorite)
        updateFavoriteButton()
    }
}
