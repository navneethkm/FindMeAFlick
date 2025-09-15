//
//  MovieDetailViewController.swift
//  FindMeAFlick
//
//  Created by P10 on 15/09/25.
//


import UIKit

class MovieDetailViewController: UIViewController {
    private let movie: Movie
    private let scrollView = UIScrollView()
    private let posterImageView = UIImageView()
    private let titleLabel = UILabel()
    private let overviewLabel = UILabel()
    private let favButton = UIButton(type: .system)

    init(movie: Movie) {
        self.movie = movie
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) { fatalError() }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupViews()
        configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateFavButton()
    }

    private func setupViews() {
        // Layout code: add subviews, constraints (kept concise)
        posterImageView.translatesAutoresizingMaskIntoConstraints = false
        posterImageView.contentMode = .scaleAspectFill
        posterImageView.clipsToBounds = true
        view.addSubview(posterImageView)

        titleLabel.font = .systemFont(ofSize: 22, weight: .bold)
        titleLabel.numberOfLines = 0
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)

        favButton.translatesAutoresizingMaskIntoConstraints = false
        favButton.addTarget(self, action: #selector(toggleFavorite), for: .touchUpInside)
        view.addSubview(favButton)

        overviewLabel.font = .systemFont(ofSize: 16)
        overviewLabel.numberOfLines = 0
        overviewLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(overviewLabel)

        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            posterImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            posterImageView.widthAnchor.constraint(equalToConstant: 140),
            posterImageView.heightAnchor.constraint(equalToConstant: 210),

            titleLabel.topAnchor.constraint(equalTo: posterImageView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),

            favButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            favButton.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 12),

            overviewLabel.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: 12),
            overviewLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            overviewLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            overviewLabel.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -12)
        ])
    }

    private func configure() {
        titleLabel.text = movie.title
        overviewLabel.text = movie.overview ?? "No description"
        ImageLoader.shared.loadImage(from: movie.posterURL) { [weak self] img in
            self?.posterImageView.image = img
        }
        updateFavButton()
    }

    @objc private func toggleFavorite() {
        if FavoritesManager.shared.isFavorite(movieId: movie.id) {
            FavoritesManager.shared.removeFavorite(movieId: movie.id)
        } else {
            FavoritesManager.shared.addFavorite(movie: movie)
        }
        updateFavButton()
        // post notification to refresh favorites list if needed
        NotificationCenter.default.post(name: .favoritesChanged, object: nil)
    }

    private func updateFavButton() {
        let title = FavoritesManager.shared.isFavorite(movieId: movie.id) ? "Remove Favorite" : "Add to Favorites"
        favButton.setTitle(title, for: .normal)
        favButton.setTitleColor(.systemPink, for: UIControl.State.normal)
    }
}

extension Notification.Name {
    static let favoritesChanged = Notification.Name("favoritesChanged")
}
