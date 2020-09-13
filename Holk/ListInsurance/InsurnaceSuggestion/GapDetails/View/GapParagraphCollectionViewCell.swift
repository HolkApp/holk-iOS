//
//  GapParagraphCollectionViewCell.swift
//  Holk
//
//  Created by 张梦皓 on 2020-09-10.
//  Copyright © 2020 Holk. All rights reserved.
//

import UIKit

final class GapParagraphCollectionViewCell: UICollectionViewCell {
    private let iconView = HolkIconView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        iconView.contentMode = .scaleAspectFit
        iconView.backgroundColor = Color.paragraphIconBackground
        iconView.imageView.tintColor = Color.mainForeground
        iconView.translatesAutoresizingMaskIntoConstraints = false

        titleLabel.numberOfLines = 0
        titleLabel.textColor = Color.mainForeground
        titleLabel.setStyleGuide(.titleHeader1)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        descriptionLabel.numberOfLines = 0
        descriptionLabel.textColor = Color.mainForeground
        descriptionLabel.setStyleGuide(.body2)
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
            iconView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
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
        // TODO: Configure the icon
//        viewModel.icon
        titleLabel.setText(viewModel.title, with: .header5)
        descriptionLabel.setText(viewModel.text, with: .body2)
    }
}
