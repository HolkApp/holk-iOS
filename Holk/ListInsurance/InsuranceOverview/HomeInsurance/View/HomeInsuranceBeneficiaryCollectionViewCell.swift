//
//  HomeInsuranceBeneficiaryCollectionViewCell.swift
//  Holk
//
//  Created by 张梦皓 on 2020-06-06.
//  Copyright © 2020 Holk. All rights reserved.
//

import UIKit

final class HomeInsuranceBeneficiaryCollectionViewCell: UICollectionViewCell {
    // MARK: - Public variables
    var insurance: Insurance?

    // MARK: - Private variables
    private let titleLabel = HolkLabel()
    private let usernameLabel = HolkLabel()
    private let chevronView = UIImageView()
    private let topSeparatorLine = UIView()
    private let bottomSeparatorLine = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        contentView.backgroundColor = .clear
        contentView.layoutMargins = .init(top: 0, left: 6, bottom: 0, right: 6)

        titleLabel.styleGuide = .header6
        titleLabel.text = "Gäller för"
        titleLabel.textColor = Color.mainForeground
        titleLabel.numberOfLines = 0
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        usernameLabel.styleGuide = .body2
        usernameLabel.textColor = Color.mainForeground
        usernameLabel.numberOfLines = 0
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false

        chevronView.image = UIImage(systemName: "chevron.right")
        chevronView.tintColor = Color.mainForeground
        chevronView.translatesAutoresizingMaskIntoConstraints = false

        topSeparatorLine.backgroundColor = Color.separator
        topSeparatorLine.translatesAutoresizingMaskIntoConstraints = false

        bottomSeparatorLine.backgroundColor = Color.separator
        bottomSeparatorLine.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(titleLabel)
        contentView.addSubview(usernameLabel)
        contentView.addSubview(chevronView)
        contentView.addSubview(topSeparatorLine)
        contentView.addSubview(bottomSeparatorLine)

        NSLayoutConstraint.activate([
            topSeparatorLine.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            topSeparatorLine.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            topSeparatorLine.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            topSeparatorLine.heightAnchor.constraint(equalToConstant: 1),

            titleLabel.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalTo: topSeparatorLine.bottomAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor, constant: -16),

            usernameLabel.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor, constant: 16),
            usernameLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            usernameLabel.trailingAnchor.constraint(lessThanOrEqualTo: chevronView.leadingAnchor, constant: 16),
            usernameLabel.bottomAnchor.constraint(equalTo: bottomSeparatorLine.topAnchor, constant: -16),

            chevronView.widthAnchor.constraint(equalToConstant: 16),
            chevronView.heightAnchor.constraint(equalToConstant: 24),
            chevronView.bottomAnchor.constraint(equalTo: usernameLabel.lastBaselineAnchor),
            chevronView.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor, constant: -8),

            bottomSeparatorLine.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            bottomSeparatorLine.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            bottomSeparatorLine.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor),
            bottomSeparatorLine.heightAnchor.constraint(equalToConstant: 1)
        ])
    }

    func configure(_ insurance: Insurance) {
        self.insurance = insurance
        usernameLabel.text = insurance.userName
    }
}
