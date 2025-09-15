//
//  FavoritesViewController.swift
//  FindMeAFlick
//
//  Created by P10 on 15/09/25.
//


import UIKit

class FavoritesViewController: UIViewController {
    private let tableView = UITableView()
    private var favorites: [Movie] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Favorites"
        view.backgroundColor = .systemBackground
        setupTable()
        loadFavorites()

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(favoritesChanged),
                                               name: .favoritesChanged,
                                               object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadFavorites()
    }

    private func setupTable() {
        tableView.register(MovieCell.self, forCellReuseIdentifier: MovieCell.reuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 120
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }

    private func loadFavorites() {
        favorites = FavoritesManager.shared.allFavorites()
        tableView.reloadData()
    }

    @objc private func favoritesChanged() {
        loadFavorites()
    }
}

extension FavoritesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if favorites.isEmpty {
            // empty state message
            let label = UILabel()
            label.text = "No favorites yet."
            label.textAlignment = .center
            label.textColor = .secondaryLabel
            label.font = .systemFont(ofSize: 18, weight: .medium)
            tableView.backgroundView = label
        } else {
            tableView.backgroundView = nil
        }
        return favorites.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieCell.reuseIdentifier, for: indexPath) as? MovieCell else {
            return UITableViewCell()
        }
        let movie = favorites[indexPath.row]
        cell.configure(with: movie)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movie = favorites[indexPath.row]
        let detail = MovieDetailViewController(movie: movie)
        navigationController?.pushViewController(detail, animated: true)
    }

    // Swipe-to-delete
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
    -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive,
                                              title: "Delete") { [weak self] _, _, completion in
            guard let self = self else { return }
            let movie = self.favorites[indexPath.row]
            FavoritesManager.shared.removeFavorite(movieId: movie.id)
            self.favorites.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            completion(true)
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
