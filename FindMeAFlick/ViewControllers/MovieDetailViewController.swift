//
//  MovieDetailViewController.swift
//  FindMeAFlick


import UIKit

class MovieDetailViewController: UIViewController {
    private let movie: Movie
    private let scrollView = UIScrollView()
    private let posterImageView = UIImageView()
    private let titleLabel = UILabel()
    private let overviewLabel = UILabel()
    private let favButton = UIButton(type: .system)
    private let watchTrailerButton = UIButton(type: .system)
    private let ratingLabel = UILabel()
    private let genreLabel = UILabel()
    private let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("X", for: .normal)
        button.setTitleColor(.systemPink, for: .normal)
        button.backgroundColor = .white
        
        let size: CGFloat = 40
        button.frame = CGRect(x: 0, y: 0, width: size, height: size)
        button.layer.cornerRadius = size / 2
        button.clipsToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        
        return button
    }()

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
        view.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        posterImageView.translatesAutoresizingMaskIntoConstraints = false
        posterImageView.contentMode = .scaleAspectFill
        posterImageView.layer.cornerRadius = 4
        posterImageView.clipsToBounds = true
        view.addSubview(posterImageView)

        titleLabel.font = .systemFont(ofSize: 22, weight: .bold)
        titleLabel.textColor = .white
        titleLabel.numberOfLines = 0
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)

        favButton.translatesAutoresizingMaskIntoConstraints = false
        favButton.addTarget(self, action: #selector(toggleFavorite), for: .touchUpInside)
        view.addSubview(favButton)
        
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.addTarget(self, action: #selector(dismissViewController), for: .touchUpInside)
        view.addSubview(closeButton)
        
        
        let isFav = FavoritesManager.shared.isFavorite(movieId: movie.id)
        var config = UIButton.Configuration.filled()
        config.title = isFav ? "Remove Favorite" : "Add to Favorites"
        config.image = UIImage(systemName: "heart.fill")
        config.imagePadding = 6
        config.baseBackgroundColor = isFav ? .gray : .systemPink
        config.baseForegroundColor = isFav ? .systemPink : .gray
        favButton.configuration = config
        favButton.translatesAutoresizingMaskIntoConstraints = false
        favButton.addTarget(self, action: #selector(toggleFavorite), for: .touchUpInside)
        view.addSubview(favButton)
        
        
        ratingLabel.font = .systemFont(ofSize: 14, weight: .bold)
        ratingLabel.textColor = .systemYellow
        ratingLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(ratingLabel)

        
        genreLabel.font = .systemFont(ofSize: 12, weight: .bold)
        genreLabel.textColor = .systemPink
        genreLabel.numberOfLines = 3
        genreLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(genreLabel)
        
        
        overviewLabel.font = .systemFont(ofSize: 16)
        overviewLabel.numberOfLines = 0
        overviewLabel.textColor = .white
        overviewLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(overviewLabel)
        
        
        var configTrailerButton = UIButton.Configuration.filled()
        configTrailerButton.title = "Watch trailer"
        configTrailerButton.image = UIImage(systemName: "play.fill")
        configTrailerButton.imagePadding = 6
        configTrailerButton.baseBackgroundColor = .systemPink
        configTrailerButton.baseForegroundColor = .white
        
        
        watchTrailerButton.configuration = configTrailerButton
        watchTrailerButton.translatesAutoresizingMaskIntoConstraints = false
        watchTrailerButton.addTarget(self, action: #selector(openTrailer), for: .touchUpInside)

        view.addSubview(watchTrailerButton)

        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            posterImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            posterImageView.widthAnchor.constraint(equalToConstant: 180),
            posterImageView.heightAnchor.constraint(equalToConstant: 270),
            
            
            titleLabel.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            
            genreLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            genreLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            ratingLabel.topAnchor.constraint(equalTo: genreLabel.bottomAnchor, constant: 4),
            ratingLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            
            overviewLabel.topAnchor.constraint(equalTo: ratingLabel.bottomAnchor, constant: 12),
            overviewLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            overviewLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            
            favButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            favButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            favButton.bottomAnchor.constraint(equalTo: watchTrailerButton.topAnchor, constant: -12),
            favButton.heightAnchor.constraint(equalToConstant: 50),
            
            
            watchTrailerButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            watchTrailerButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            watchTrailerButton.bottomAnchor.constraint(equalTo: closeButton.topAnchor, constant: -16),
            watchTrailerButton.heightAnchor.constraint(equalToConstant: 50),
            
            
            closeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            closeButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            closeButton.widthAnchor.constraint(equalToConstant: 40),
            closeButton.heightAnchor.constraint(equalToConstant: 40),
        ])
    }

    private func configure() {
        titleLabel.text = movie.title
        overviewLabel.text = movie.overview ?? "No description"
        ImageLoader.shared.loadImage(from: movie.posterURL) { [weak self] img in
            self?.posterImageView.image = img
        }
        if let rating = movie.voteAverage {
            ratingLabel.text = "⭐️ \(String(format: "%.1f", rating))"
        } else {
            ratingLabel.text = "—"
        }
        genreLabel.text = movie.genreNames
        updateFavButton()
    }

    @objc private func toggleFavorite() {
        if FavoritesManager.shared.isFavorite(movieId: movie.id) {
            FavoritesManager.shared.removeFavorite(movieId: movie.id)
        } else {
            FavoritesManager.shared.addFavorite(movie: movie)
        }
        updateFavButton()
        NotificationCenter.default.post(name: .favoritesChanged, object: nil)
    }
    
    @objc private func dismissViewController() {
        self.dismiss(animated: true)
    }

    private func updateFavButton() {
        let isFav = FavoritesManager.shared.isFavorite(movieId: movie.id)
            
            var config = UIButton.Configuration.filled()
            config.title = isFav ? "Remove Favorite" : "Add to Favorites"
            config.image = UIImage(systemName: isFav ? "heart.fill" : "heart")
            config.imagePadding = 6
            config.baseBackgroundColor = isFav ? .white : .systemPink   // button color
            config.baseForegroundColor = isFav ? .systemPink: .white
            
            favButton.configuration = config
    }
    
    @objc private func openTrailer() {
        fetchMovieTrailer(movieId: movie.id) { url in
            guard let url = url else { return }
            DispatchQueue.main.async {
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url)
                }
            }
        }

    }

    
    func fetchMovieTrailer(movieId: Int, completion: @escaping (URL?) -> Void) {
        let apiKey = Secrets.tmdbKey
        let urlString = "https://api.themoviedb.org/3/movie/\(movieId)/videos?api_key=\(apiKey)&language=en-US"
        guard let url = URL(string: urlString) else { completion(nil); return }

        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data,
                  let response = try? JSONDecoder().decode(VideoResponse.self, from: data),
                  let trailer = response.results.first(where: { $0.type == "Trailer" && $0.site == "YouTube" }) else {
                completion(nil)
                return
            }
            let youtubeURL = URL(string: "https://www.youtube.com/watch?v=\(trailer.key)")
            completion(youtubeURL)
        }.resume()
    }

    struct VideoResponse: Codable {
        let results: [Video]
    }

    struct Video: Codable {
        let key: String
        let site: String
        let type: String
    }
}

extension Notification.Name {
    static let favoritesChanged = Notification.Name("favoritesChanged")
}


