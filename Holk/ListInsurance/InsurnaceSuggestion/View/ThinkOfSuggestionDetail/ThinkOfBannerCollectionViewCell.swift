//
//  ThinkOfBannerCollectionViewCell.swift
//  Holk
//
//  Created by 张梦皓 on 2020-07-19.
//  Copyright © 2020 Holk. All rights reserved.
//

import UIKit

final class ThinkOfBannerCollectionViewCell: UICollectionViewCell {
    private let imageView = UIImageView()
    private let headerLabel = UILabel()
    private let descriptionLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: .zero)

        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    func configure(_ viewModel: ThinkOfSuggestionBannerViewModel) {
        if let imageURL = viewModel.imageURL {
            UIImage.makeImageWithURL(imageURL) { [weak self] image in
                self?.imageView.image = image
            }
        } else {
            imageView.image = UIImage(named: "thinkOfPlaceholder")
        }

        headerLabel.text = viewModel.detailHeader
        descriptionLabel.text = viewModel.detailDescription
    }

    private func setup() {
        backgroundColor = Color.secondaryBackground

        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false

        headerLabel.setStyleGuide(.header5)
        headerLabel.numberOfLines = 0
        headerLabel.textColor = Color.mainForeground
        headerLabel.translatesAutoresizingMaskIntoConstraints = false

        descriptionLabel.setStyleGuide(.subHeader5)
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textColor = Color.mainForeground
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false

        setupLayout()
    }

    private func setupLayout() {
        addSubview(imageView)
        addSubview(headerLabel)
        addSubview(descriptionLabel)

        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),

            headerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            headerLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 28),
            headerLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),

            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            descriptionLabel.topAnchor.constraint(equalTo: headerLabel.lastBaselineAnchor, constant: 8),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),
            descriptionLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
