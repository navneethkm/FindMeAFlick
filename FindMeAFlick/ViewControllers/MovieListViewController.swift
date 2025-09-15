//
//  MovieListViewController.swift
//  FindMeAFlick
//
//  Created by P10 on 15/09/25.
//


import UIKit

class MovieListViewController: UIViewController {
    private let tableView = UITableView()
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
        setupTable()
        setupSearch()
        fetchMovies()
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
                self?.tableView.reloadData()
            case .failure(let error):
                print("fetch error:", error)
                // show a simple alert
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

// MARK: Table
extension MovieListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearching ? filteredMovies.count : movies.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieCell.reuseIdentifier, for: indexPath) as? MovieCell else {
            return UITableViewCell()
        }
        let movie = isSearching ? filteredMovies[indexPath.row] : movies[indexPath.row]
        cell.configure(with: movie)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movie = isSearching ? filteredMovies[indexPath.row] : movies[indexPath.row]
        let detail = MovieDetailViewController(movie: movie)
        navigationController?.pushViewController(detail, animated: true)
    }
}

// MARK: Search updating
extension MovieListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text, !text.isEmpty else {
            filteredMovies = []
            tableView.reloadData()
            return
        }
        // For simple local filter on current page:
        filteredMovies = movies.filter { $0.title.lowercased().contains(text.lowercased()) }
        tableView.reloadData()
        // Optionally: call APIClient.shared.searchMovies(query: text, completion: ...) for global search
    }
}
