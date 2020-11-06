//
//  HomeInsuranceHeaderView.swift
//  Holk
//
//  Created by 张梦皓 on 2020-06-15.
//  Copyright © 2020 Holk. All rights reserved.
//

import UIKit

final class HomeInsuranceHeaderView: UICollectionReusableView {
    let titleLabel = HolkLabel()
    let descriptionLabel = HolkLabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        clipsToBounds = true
        backgroundColor = .clear

        titleLabel.styleGuide = .header4
        titleLabel.textColor = Color.mainForeground
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        descriptionLabel.styleGuide = .subHeader1
        descriptionLabel.textColor = Color.mainForeground
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false

        addSubview(titleLabel)
        addSubview(descriptionLabel)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.lastBaselineAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            descriptionLabel.lastBaselineAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    func configure(_ insurance: Insurance) {
        titleLabel.text = insurance.kind.description
        descriptionLabel.text = insurance.address
    }
}

