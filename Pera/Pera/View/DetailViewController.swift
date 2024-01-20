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
        label.textAlignment = .center
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        return label
    }()
    
    private let forkLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .black)
        return label
    }()
    
    private let watchLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .black)
        return label
    }() 
    
    private let languageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .black)
        label.textColor = .blue
        return label
    }()

    private let visibilityLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .black)
        label.textColor = .red
        return label
    }()
    
    private let favoriteButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.systemBlue, for: .normal)
        return button
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
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
        
        view.addSubview(closeButton)
        closeButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(10)
            make.width.height.equalTo(30)
        }
        
        view.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(closeButton.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        let forkWatchStackView: UIStackView = {
            let stackView = UIStackView(arrangedSubviews: [forkLabel, watchLabel])
            stackView.axis = .horizontal
            stackView.spacing = 8
            return stackView
        }()
        
        view.addSubview(forkWatchStackView)
        forkWatchStackView.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(40)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        view.addSubview(visibilityLabel)
        visibilityLabel.snp.makeConstraints { make in
            make.top.equalTo(forkWatchStackView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        view.addSubview(languageLabel)
        languageLabel.snp.makeConstraints { make in
            make.top.equalTo(visibilityLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        view.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(languageLabel.snp.bottom).offset(20)
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
        descriptionLabel.text = "Description: \(viewModel.getRepository().description ?? "")"
        forkLabel.text = "Fork Count: \(viewModel.getRepository().forks ?? 0)"
        watchLabel.text = "Watcher Count: \(viewModel.getRepository().watchers ?? 0)"
        visibilityLabel.text = "Visibility: \(viewModel.getRepository().visibility ?? "")"
        languageLabel.text = "Language: \(viewModel.getRepository().language ?? "")"
    }
    
    @objc private func toggleFavorite() {
        viewModel.toggleFavoriteStatus()
        updateFavoriteButton()
        delegate?.didToggleFavoriteStatus(for: viewModel.getRepository())
    }
    
    private func updateFavoriteButton() {
        if viewModel.isRepositoryFavorite() {
            favoriteButton.setTitle("Remove from Favorites", for: .normal)
        } else {
            favoriteButton.setTitle("Add to Favorites", for: .normal)
        }
    }
    
    private func loadFavoriteStatus() {
        let isFavorite = UserDefaults.standard.bool(forKey: viewModel.favoriteKey)
        viewModel.setFavoriteStatus(isFavorite)
        updateFavoriteButton()
    }
    
    @objc private func closeButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }
}
