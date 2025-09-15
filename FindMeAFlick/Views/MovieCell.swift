//
//  MovieCell.swift
//  FindMeAFlick
//
//  Created by P10 on 15/09/25.
//


import UIKit

class MovieCell: UITableViewCell {
    static let reuseIdentifier = "MovieCell"
    private let posterImageView = UIImageView()
    private let titleLabel = UILabel()
    private let ratingLabel = UILabel()
    private let genreLabel = UILabel()
    private let Label = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    required init?(coder: NSCoder) { fatalError("init(coder:)") }

    private func setup() {
        posterImageView.contentMode = .scaleAspectFill
        posterImageView.clipsToBounds = true
        posterImageView.layer.cornerRadius = 6
        posterImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(posterImageView)

        titleLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        titleLabel.numberOfLines = 2
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)

        ratingLabel.font = .systemFont(ofSize: 14)
        ratingLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(ratingLabel)
        genreLabel.font = UIFont.italicSystemFont(ofSize: 14)
        genreLabel.textColor = .systemPink
        genreLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(genreLabel)

        NSLayoutConstraint.activate([
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            posterImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            posterImageView.widthAnchor.constraint(equalToConstant: 80),
            posterImageView.heightAnchor.constraint(equalToConstant: 100),

            titleLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 12),
            titleLabel.topAnchor.constraint(equalTo: posterImageView.topAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),

            ratingLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            ratingLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            
            genreLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            genreLabel.bottomAnchor.constraint(equalTo: posterImageView.bottomAnchor),
            genreLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 8),
        ])
    }

    func configure(with movie: Movie) {

        titleLabel.text = movie.title
        if let rating = movie.voteAverage {
            ratingLabel.text = "⭐️ \(String(format: "%.1f", rating))/10"
        } else {
            ratingLabel.text = "—"
        }
        genreLabel.text = "Genre: \(movie.genreNames)"
        posterImageView.image = nil
        ImageLoader.shared.loadImage(from: movie.posterURL) { [weak self] img in
            self?.posterImageView.image = img
        }
    }
}
