//
//  MovieListViewController.swift
//  FindMeAFlick

import UIKit

class MovieListViewController: UIViewController {
    private var collectionView: UICollectionView!
    private var movies: [Movie] = []
    private var filteredMovies: [Movie] = []
    private let searchController = UISearchController(searchResultsController: nil)
    private var isSearching: Bool {
        return searchController.isActive && !(searchController.searchBar.text?.isEmpty ?? true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Find Me A Flick!"
        view.backgroundColor = .systemBackground
        setupCollectionView()
        setupSearch()
        fetchMovies()
    }

    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 12
        let itemWidth = (view.frame.width - (spacing * 3)) / 2
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth * 1.5)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(MovieCell.self, forCellWithReuseIdentifier: MovieCell.reuseIdentifier)
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        collectionView.dataSource = self

        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }

    private func setupSearch() {
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search movies"
    }

    private func fetchMovies() {
        APIClient.shared.fetchPopular { [weak self] result in
            switch result {
            case .success(let movies):
                self?.movies = movies
                self?.collectionView.reloadData()
            case .failure(let error):
                self?.showError(error)
            }
        }
    }

    private func showError(_ error: Error) {
        let a = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        a.addAction(UIAlertAction(title: "OK", style: .default))
        present(a, animated: true)
    }
}

// MARK: Collection View
extension MovieListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isSearching ? filteredMovies.count : movies.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCell.reuseIdentifier, for: indexPath) as? MovieCell else {
            return UICollectionViewCell()
        }
        let movie = isSearching ? filteredMovies[indexPath.item] : movies[indexPath.item]
        cell.configure(with: movie)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie = isSearching ? filteredMovies[indexPath.item] : movies[indexPath.item]
        let detail = MovieDetailViewController(movie: movie)
        detail.modalPresentationStyle = .overFullScreen
        present(detail, animated: true)
    }
}

// MARK: Search updating
extension MovieListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text, !text.isEmpty else {
            filteredMovies = []
            collectionView.reloadData()
            return
        }
        filteredMovies = movies.filter { $0.title.lowercased().contains(text.lowercased()) }
        collectionView.reloadData()
    }
}
