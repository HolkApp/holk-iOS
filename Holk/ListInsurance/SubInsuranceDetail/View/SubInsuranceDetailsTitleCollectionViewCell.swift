//
//  SubInsuranceDetailsTitleCollectionViewCell.swift
//  Holk
//
//  Created by 张梦皓 on 2020-10-18.
//  Copyright © 2020 Holk. All rights reserved.
//

import UIKit

final class SubInsuranceDetailsTitleCollectionViewCell: UICollectionViewCell {
    private let titleLabel = HolkLabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        layoutMargins = .init(top: 24, left: 30, bottom: 24, right: 30)

        titleLabel.styleGuide = .cardHeader2
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        addSubview(titleLabel)

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            titleLabel.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            titleLabel.lastBaselineAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor)
        ])
    }

    func configure(_ title: String) {
        titleLabel.text = title
    }
}
