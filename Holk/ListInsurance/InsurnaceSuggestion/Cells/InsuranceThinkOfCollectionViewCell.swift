//
//  InsuranceThinkOfCollectionViewCell.swift
//  Holk
//
//  Created by 张梦皓 on 2020-06-28.
//  Copyright © 2020 Holk. All rights reserved.
//

import UIKit

final class InsuranceThinkOfCollectionViewCell: UICollectionViewCell {
    // MARK: - Private variables
    private let iconView = UIImageView()
    private let thinkOfTypeIconView = HolkIconView()
    private let subInsuranceTypeLabel = UILabel()
    private let titleLabel = UILabel()
    private let chevronView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(_ gap: ThinkOfSuggestion) {
//        titleLabel.text = gap.title
//        subInsuranceTypeLabel.text = gap.tag
    }

    private func setup() {
        contentView.backgroundColor = Color.mainForegroundColor
        contentView.layer.cornerRadius = 16
        contentView.layer.cornerCurve = .continuous

        iconView.image = UIImage(systemName: "bell")
        iconView.translatesAutoresizingMaskIntoConstraints = false

        thinkOfTypeIconView.imageView.image = UIImage(named: "thinkOf")
        thinkOfTypeIconView.translatesAutoresizingMaskIntoConstraints = false

        subInsuranceTypeLabel.setStyleGuide(.titleHeader1)
        subInsuranceTypeLabel.numberOfLines = 0
        subInsuranceTypeLabel.textColor = Color.secondaryBackgroundColor
        subInsuranceTypeLabel.textAlignment = .center
        subInsuranceTypeLabel.translatesAutoresizingMaskIntoConstraints = false

        titleLabel.setStyleGuide(.cardHeader2)
        titleLabel.numberOfLines = 0
        titleLabel.textColor = Color.secondaryHighlightColor
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        chevronView.image = UIImage(systemName: "chevron.right")
        chevronView.translatesAutoresizingMaskIntoConstraints = false

        setupLayout()
    }

    private func setupLayout() {
        contentView.addSubview(iconView)
        contentView.addSubview(thinkOfTypeIconView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subInsuranceTypeLabel)
        contentView.addSubview(chevronView)

        NSLayoutConstraint.activate([
            iconView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 14),
            iconView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -14),
            iconView.widthAnchor.constraint(equalToConstant: 32),
            iconView.heightAnchor.constraint(equalToConstant: 32),

            thinkOfTypeIconView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            thinkOfTypeIconView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            thinkOfTypeIconView.widthAnchor.constraint(equalToConstant: 48),
            thinkOfTypeIconView.heightAnchor.constraint(equalToConstant: 48),

            subInsuranceTypeLabel.topAnchor.constraint(equalTo: thinkOfTypeIconView.bottomAnchor, constant: 14),
            subInsuranceTypeLabel.leadingAnchor.constraint(equalTo: thinkOfTypeIconView.leadingAnchor),
            subInsuranceTypeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -14),

            titleLabel.topAnchor.constraint(equalTo: subInsuranceTypeLabel.lastBaselineAnchor, constant: 14),
            titleLabel.leadingAnchor.constraint(equalTo: subInsuranceTypeLabel.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -14),

            chevronView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            chevronView.widthAnchor.constraint(equalToConstant: 16),
            chevronView.heightAnchor.constraint(equalToConstant: 24),
            chevronView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            chevronView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
}
