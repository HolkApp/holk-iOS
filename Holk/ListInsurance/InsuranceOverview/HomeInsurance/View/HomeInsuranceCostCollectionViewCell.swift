//
//  HomeInsuranceCostCollectionViewCell.swift
//  Holk
//
//  Created by 张梦皓 on 2020-06-08.
//  Copyright © 2020 Holk. All rights reserved.
//

import UIKit

final class HomeInsuranceCostCollectionViewCell: UICollectionViewCell {
    // MARK: - Public variables
    var insurance: Insurance?
    
    // MARK: - Private variables
    private let titleLabel = HolkLabel()
    private let costLabel = HolkLabel()
    private let chevronView = UIImageView()
    private let bottomSeparatorLine = UIView()
    private let amountFormatter = DynamicAmountFormatter()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        amountFormatter.alwaysHidesCurrencySymbol = true

        contentView.backgroundColor = .clear
        contentView.layoutMargins = .init(top: 0, left: 6, bottom: 0, right: 6)

        titleLabel.styleGuide = .header6
        titleLabel.text = "Kostnad"
        titleLabel.textColor = Color.mainForeground
        titleLabel.numberOfLines = 0
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        costLabel.textColor = Color.mainForeground
        costLabel.styleGuide = .subHeader4
        costLabel.numberOfLines = 0
        costLabel.translatesAutoresizingMaskIntoConstraints = false

        chevronView.image = UIImage(systemName: "chevron.right")
        chevronView.tintColor = Color.mainForeground
        chevronView.translatesAutoresizingMaskIntoConstraints = false

        bottomSeparatorLine.backgroundColor = Color.separator
        bottomSeparatorLine.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(titleLabel)
        contentView.addSubview(costLabel)
        contentView.addSubview(chevronView)
        contentView.addSubview(bottomSeparatorLine)

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor, constant: -16),

            costLabel.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor, constant: 16),
            costLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            costLabel.trailingAnchor.constraint(lessThanOrEqualTo: chevronView.leadingAnchor, constant: 16),
            costLabel.lastBaselineAnchor.constraint(equalTo: bottomSeparatorLine.topAnchor, constant: -16),

            chevronView.widthAnchor.constraint(equalToConstant: 16),
            chevronView.heightAnchor.constraint(equalToConstant: 24),
            chevronView.bottomAnchor.constraint(equalTo: costLabel.lastBaselineAnchor),
            chevronView.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor, constant: -8),

            bottomSeparatorLine.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            bottomSeparatorLine.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            bottomSeparatorLine.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor),
            bottomSeparatorLine.heightAnchor.constraint(equalToConstant: 1)
        ])
    }

    func configure(_ insurance: Insurance) {
        self.insurance = insurance
        let cost = amountFormatter.string(from: insurance.cost.monthlyPrice)
        costLabel.text = "\(cost) kr/mån"
    }
}
