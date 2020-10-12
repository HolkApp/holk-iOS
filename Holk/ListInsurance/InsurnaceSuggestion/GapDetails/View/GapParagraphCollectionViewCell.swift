//
//  GapParagraphCollectionViewCell.swift
//  Holk
//
//  Created by 张梦皓 on 2020-09-10.
//  Copyright © 2020 Holk. All rights reserved.
//

import UIKit

final class GapParagraphCollectionViewCell: UICollectionViewCell {
    private let iconView = UIImageView()
    private let titleLabel = HolkLabel()
    private let descriptionLabel = HolkLabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        iconView.contentMode = .scaleAspectFit
        iconView.tintColor = Color.mainForeground
        iconView.translatesAutoresizingMaskIntoConstraints = false

        titleLabel.styleGuide = .titleHeader1
        titleLabel.numberOfLines = 0
        titleLabel.textColor = Color.mainForeground
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        descriptionLabel.styleGuide = .body2
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textColor = Color.mainForeground
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false

        setupLayout()
    }

    private func setupLayout() {
        contentView.addSubview(iconView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)

        NSLayoutConstraint.activate([
            iconView.widthAnchor.constraint(equalToConstant: 45),
            iconView.heightAnchor.constraint(equalToConstant: 45),
            iconView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 26),
            iconView.topAnchor.constraint(equalTo: contentView.topAnchor),
            iconView.trailingAnchor.constraint(equalTo: titleLabel.leadingAnchor, constant: -20),

            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -26),
            titleLabel.bottomAnchor.constraint(equalTo: descriptionLabel.topAnchor, constant: -8),

            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
}

extension GapParagraphCollectionViewCell {
    func configure(_ viewModel: GapParagraphViewModel) {
        iconView.kf.setImage(with: viewModel.icon)
        titleLabel.text = viewModel.title
        descriptionLabel.text = viewModel.text
    }
}
