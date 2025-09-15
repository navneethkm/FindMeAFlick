//
//  FavoritesViewController.swift
//  FindMeAFlick
import UIKit

class FavoritesViewController: UIViewController {
    private var collectionView: UICollectionView!
    private var favorites: [Movie] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Favorites"
        view.backgroundColor = .systemBackground
        setupCollection()
        loadFavorites()

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(favoritesChanged),
            name: .favoritesChanged,
            object: nil
        )
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadFavorites()
    }

    private func setupCollection() {
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 12
        let totalSpacing = spacing * 3 
        let width = (view.frame.width - totalSpacing) / 2
        layout.itemSize = CGSize(width: width, height: width * 1.5)
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing

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

    private func loadFavorites() {
        favorites = FavoritesManager.shared.allFavorites()
        collectionView.reloadData()
        updateEmptyState()
    }

    private func updateEmptyState() {
        if favorites.isEmpty {
            let label = UILabel()
            label.text = "No favorites yet."
            label.textAlignment = .center
            label.textColor = .secondaryLabel
            label.font = .systemFont(ofSize: 18, weight: .medium)
            collectionView.backgroundView = label
        } else {
            collectionView.backgroundView = nil
        }
    }

    @objc private func favoritesChanged() {
        loadFavorites()
    }
}

// MARK: - Collection DataSource & Delegate
extension FavoritesViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favorites.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: MovieCell.reuseIdentifier,
            for: indexPath
        ) as? MovieCell else {
            return UICollectionViewCell()
        }
        let movie = favorites[indexPath.item]
        cell.configure(with: movie)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie = favorites[indexPath.item]
        let detail = MovieDetailViewController(movie: movie)
        detail.modalPresentationStyle = .overFullScreen
        present(detail, animated: true)
    }
}
