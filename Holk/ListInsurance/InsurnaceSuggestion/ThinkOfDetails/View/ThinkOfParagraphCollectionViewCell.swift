//
//  ThinkOfParagraphCollectionViewCell.swift
//  Holk
//
//  Created by 张梦皓 on 2020-07-11.
//  Copyright © 2020 Holk. All rights reserved.
//

import UIKit

final class ThinkOfParagraphCollectionViewCell: UICollectionViewCell {
    private let iconView = HolkIconView()
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

        descriptionLabel.numberOfLines = 0
        descriptionLabel.textColor = Color.mainForeground
        descriptionLabel.setStyleGuide(.body2)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false

        setupLayout()
    }

    private func setupLayout() {
        contentView.addSubview(iconView)
        contentView.addSubview(descriptionLabel)

        NSLayoutConstraint.activate([
            iconView.widthAnchor.constraint(equalToConstant: 45),
            iconView.heightAnchor.constraint(equalToConstant: 45),
            iconView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 26),
            iconView.topAnchor.constraint(equalTo: contentView.topAnchor),
            iconView.trailingAnchor.constraint(equalTo: descriptionLabel.leadingAnchor, constant: -20),

            descriptionLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -26),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
}

extension ThinkOfParagraphCollectionViewCell {
    func configure(_ viewModel: ThinkOfParagraphViewModel) {
        UIImage.makeImage(with: viewModel.icon) { [weak self] image in
            self?.iconView.imageView.image = image
        }
        descriptionLabel.set(text: viewModel.text, with: .body2)
    }
}
