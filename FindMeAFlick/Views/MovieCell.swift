//
//  MovieCell.swift
//  FindMeAFlick

import UIKit

class MovieCell: UICollectionViewCell {
    static let reuseIdentifier = "MovieCell"
    private let posterImageView = UIImageView()
    private let gradientLayer = CAGradientLayer()
    private let titleLabel = UILabel()
    private let ratingLabel = UILabel()
    private let genreLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        posterImageView.contentMode = .scaleAspectFill
        posterImageView.clipsToBounds = true
        posterImageView.layer.cornerRadius = 6
        posterImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(posterImageView)
        
        gradientLayer.colors = [
                UIColor.clear.cgColor,
                UIColor.black.withAlphaComponent(0.7).cgColor]
        gradientLayer.locations = [0.0, 1.0]
        posterImageView.layer.addSublayer(gradientLayer)

        titleLabel.font = .systemFont(ofSize: 18, weight: .bold)
        titleLabel.textColor = .systemBackground
        titleLabel.numberOfLines = 3
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        posterImageView.addSubview(titleLabel)

        ratingLabel.font = .systemFont(ofSize: 14, weight: .bold)
        ratingLabel.textColor = .systemYellow
        ratingLabel.translatesAutoresizingMaskIntoConstraints = false
        posterImageView.addSubview(ratingLabel)

        genreLabel.font = .systemFont(ofSize: 12, weight: .bold)
        genreLabel.textColor = .systemPink
        genreLabel.numberOfLines = 3
        genreLabel.translatesAutoresizingMaskIntoConstraints = false
        posterImageView.addSubview(genreLabel)

        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            posterImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            posterImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            titleLabel.leadingAnchor.constraint(equalTo: posterImageView.leadingAnchor, constant: 6),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: posterImageView.trailingAnchor, constant: -6),
            titleLabel.bottomAnchor.constraint(equalTo: genreLabel.topAnchor, constant: -2),

            genreLabel.leadingAnchor.constraint(equalTo: posterImageView.leadingAnchor, constant: 6),
            genreLabel.trailingAnchor.constraint(lessThanOrEqualTo: posterImageView.trailingAnchor, constant: -6),
            genreLabel.bottomAnchor.constraint(equalTo: ratingLabel.topAnchor, constant: -10),
            
            ratingLabel.leadingAnchor.constraint(equalTo: posterImageView.leadingAnchor, constant: 6),
            ratingLabel.bottomAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: -6),
            ratingLabel.topAnchor.constraint(equalTo: genreLabel.bottomAnchor, constant: -10),
            
        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = posterImageView.bounds
    }

    func configure(with movie: Movie) {
        titleLabel.text = movie.title
        if let rating = movie.voteAverage {
            ratingLabel.text = "⭐️ \(String(format: "%.1f", rating))"
        } else {
            ratingLabel.text = "—"
        }
        genreLabel.text = movie.genreNames
        posterImageView.image = nil
        ImageLoader.shared.loadImage(from: movie.posterURL) { [weak self] img in
            self?.posterImageView.image = img
        }
    }
}
