//
//  ThinkOfCollectionViewCell.swift
//  Holk
//
//  Created by 张梦皓 on 2020-06-28.
//  Copyright © 2020 Holk. All rights reserved.
//

import UIKit

final class ThinkOfCollectionViewCell: UICollectionViewCell {
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

    func configure(_ thinkOf: ThinkOfSuggestion) {
        titleLabel.set(text: thinkOf.title, with: .cardHeader2)
        subInsuranceTypeLabel.set(text: thinkOf.type, with: .titleHeader1)
    }

    private func setup() {
        contentView.backgroundColor = Color.thinkOfBackground
        contentView.layer.cornerRadius = 16
        contentView.layer.cornerCurve = .continuous

        iconView.image = UIImage(named: "light")
        iconView.tintColor = Color.mainForeground
        iconView.translatesAutoresizingMaskIntoConstraints = false

        // TODO: Find the correct image and color
        thinkOfTypeIconView.imageView.image = UIImage(named: "travel")
        thinkOfTypeIconView.backgroundColor = Color.iconBackgroundColor(.init(body: "", header: "", iconUrl: URL(string: "test://")!, kind: .travel))
        thinkOfTypeIconView.translatesAutoresizingMaskIntoConstraints = false

        subInsuranceTypeLabel.setStyleGuide(.titleHeader1)
        subInsuranceTypeLabel.numberOfLines = 0
        subInsuranceTypeLabel.textColor = Color.mainForeground
        subInsuranceTypeLabel.translatesAutoresizingMaskIntoConstraints = false

        titleLabel.setStyleGuide(.cardHeader2)
        titleLabel.numberOfLines = 0
        titleLabel.textColor = Color.secondaryLabel
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        chevronView.image = UIImage(systemName: "chevron.right")
        chevronView.tintColor = Color.mainForeground.withAlphaComponent(0.5)
        chevronView.translatesAutoresizingMaskIntoConstraints = false

        setupLayout()
    }

    private func setupLayout() {
        contentView.addSubview(iconView)
        contentView.addSubview(thinkOfTypeIconView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subInsuranceTypeLabel)
        contentView.addSubview(chevronView)

        contentView.layer.shadowRadius = 16
        contentView.layer.shadowOffset = CGSize(width: 0, height: 4)
        contentView.layer.shadowColor = UIColor.black.withAlphaComponent(0.15).cgColor
        contentView.layer.shadowOpacity = 1

        NSLayoutConstraint.activate([
            iconView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 14),
            iconView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -14),
            iconView.widthAnchor.constraint(equalToConstant: 32),
            iconView.heightAnchor.constraint(equalToConstant: 32),

            thinkOfTypeIconView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            thinkOfTypeIconView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            thinkOfTypeIconView.widthAnchor.constraint(equalToConstant: 56),
            thinkOfTypeIconView.heightAnchor.constraint(equalToConstant: 56),

            subInsuranceTypeLabel.topAnchor.constraint(equalTo: thinkOfTypeIconView.bottomAnchor, constant: 14),
            subInsuranceTypeLabel.leadingAnchor.constraint(equalTo: thinkOfTypeIconView.leadingAnchor),
            subInsuranceTypeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -14),

            titleLabel.topAnchor.constraint(equalTo: subInsuranceTypeLabel.bottomAnchor, constant: 4),
            titleLabel.leadingAnchor.constraint(equalTo: subInsuranceTypeLabel.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -14),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40),

            chevronView.widthAnchor.constraint(equalToConstant: 16),
            chevronView.heightAnchor.constraint(equalToConstant: 24),
            chevronView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            chevronView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
}
