//
//  InsuranceGapsSuggestionCollectionViewCell.swift
//  Holk
//
//  Created by 张梦皓 on 2020-06-13.
//  Copyright © 2020 Holk. All rights reserved.
//

import UIKit

final class InsuranceGapsSuggestionCollectionViewCell: UICollectionViewCell {
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
        titleLabel.text = gap.title
        tagLabel.text = gap.tag
    }

    private func setup() {
        contentView.backgroundColor = Color.mainForegroundColor
        contentView.layer.cornerRadius = 16
        contentView.layer.cornerCurve = .continuous

        iconView.image = UIImage(systemName: "bell")
        iconView.translatesAutoresizingMaskIntoConstraints = false

        titleLabel.numberOfLines = 0
        titleLabel.textColor = Color.secondaryHighlightColor
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        tagLabel.numberOfLines = 0
        tagLabel.textColor = Color.secondaryBackgroundColor
        tagLabel.textAlignment = .center
        tagLabel.translatesAutoresizingMaskIntoConstraints = false

        chevronView.image = UIImage(systemName: "chevron.right")
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
            iconView.heightAnchor.constraint(equalToConstant: 32),

            titleLabel.topAnchor.constraint(equalTo: iconView.bottomAnchor, constant: 32),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),

            tagLabel.topAnchor.constraint(equalTo: titleLabel.lastBaselineAnchor, constant: 8),
            tagLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            tagLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),

            chevronView.widthAnchor.constraint(equalToConstant: 16),
            chevronView.heightAnchor.constraint(equalToConstant: 24),
            chevronView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            chevronView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }

}
