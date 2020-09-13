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
    private let titleLabel = UILabel()
    private let tagLabel = UILabel()
    private let chevronView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(_ gap: GapSuggestion) {
        titleLabel.set(text: gap.title, with: .cardHeader2)
        tagLabel.set(text: gap.type, with: .header7)
    }

    private func setup() {
        contentView.backgroundColor = Color.mainForeground
        contentView.layer.cornerRadius = 16
        contentView.layer.cornerCurve = .continuous

        iconView.image = UIImage(systemName: "bell")?.withSymbolWeightConfiguration(.light)
        iconView.tintColor = Color.secondaryLabel
        iconView.translatesAutoresizingMaskIntoConstraints = false

        titleLabel.setStyleGuide(.cardHeader2)
        titleLabel.numberOfLines = 0
        titleLabel.textColor = Color.gapLabel
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        tagLabel.setStyleGuide(.header7)
        tagLabel.numberOfLines = 0
        tagLabel.textColor = Color.secondaryLabel
        tagLabel.textAlignment = .center
        tagLabel.translatesAutoresizingMaskIntoConstraints = false

        chevronView.image = UIImage(systemName: "chevron.right")
        chevronView.tintColor = Color.secondaryLabel
        chevronView.translatesAutoresizingMaskIntoConstraints = false

        setupLayout()
    }

    private func setupLayout() {
        contentView.addSubview(iconView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(tagLabel)
        contentView.addSubview(chevronView)

        NSLayoutConstraint.activate([
            iconView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            iconView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            iconView.widthAnchor.constraint(equalTo: iconView.heightAnchor),
            iconView.heightAnchor.constraint(equalToConstant: 42),

            titleLabel.topAnchor.constraint(equalTo: iconView.bottomAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),

            tagLabel.topAnchor.constraint(equalTo: titleLabel.lastBaselineAnchor, constant: 8),
            tagLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            tagLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),

            chevronView.topAnchor.constraint(equalTo: tagLabel.bottomAnchor, constant: 36),
            chevronView.widthAnchor.constraint(equalToConstant: 16),
            chevronView.heightAnchor.constraint(equalToConstant: 24),
            chevronView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            chevronView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }

}
