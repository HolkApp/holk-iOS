//
//  GapCollectionViewCell.swift
//  Holk
//
//  Created by 张梦皓 on 2020-06-13.
//  Copyright © 2020 Holk. All rights reserved.
//

import UIKit

final class GapCollectionViewCell: UICollectionViewCell {
    // MARK: - Private variables
    private let iconView = UIImageView()
    private let titleLabel = HolkLabel()
    private let tagLabel = HolkLabel()
    private let chevronView = ChevronView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(_ gap: GapSuggestion) {
        titleLabel.text = gap.title
        tagLabel.text = gap.type
    }

    private func setup() {
        contentView.backgroundColor = Color.mainForeground
        contentView.layer.cornerRadius = 16
        contentView.layer.cornerCurve = .continuous

        iconView.image = UIImage.gap
        iconView.tintColor = Color.lightLabel
        iconView.translatesAutoresizingMaskIntoConstraints = false

        titleLabel.styleGuide = .cardHeader2
        titleLabel.numberOfLines = 0
        titleLabel.textColor = Color.gapLabel
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        tagLabel.styleGuide = .header7
        tagLabel.numberOfLines = 0
        tagLabel.textColor = Color.lightLabel
        tagLabel.textAlignment = .center
        tagLabel.translatesAutoresizingMaskIntoConstraints = false

        chevronView.tintColor = Color.lightLabel
        chevronView.translatesAutoresizingMaskIntoConstraints = false

        setupLayout()
    }

    private func setupLayout() {
        contentView.addSubview(iconView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(tagLabel)
        contentView.addSubview(chevronView)

        contentView.layer.shadowRadius = 16
        contentView.layer.shadowOffset = CGSize(width: 0, height: 4)
        contentView.layer.shadowColor = UIColor.black.withAlphaComponent(0.15).cgColor
        contentView.layer.shadowOpacity = 1

        NSLayoutConstraint.activate([
            iconView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            iconView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 32),
            iconView.widthAnchor.constraint(equalTo: iconView.heightAnchor),
            iconView.heightAnchor.constraint(equalToConstant: 42),

            titleLabel.topAnchor.constraint(equalTo: iconView.bottomAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),

            tagLabel.topAnchor.constraint(equalTo: titleLabel.lastBaselineAnchor, constant: 8),
            tagLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            tagLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),

            chevronView.topAnchor.constraint(equalTo: tagLabel.bottomAnchor, constant: 28),
            chevronView.widthAnchor.constraint(equalToConstant: 16),
            chevronView.heightAnchor.constraint(equalToConstant: 24),
            chevronView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            chevronView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }

}
