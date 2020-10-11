//
//  ThinkOfBannerCollectionHeaderView.swift
//  Holk
//
//  Created by 张梦皓 on 2020-07-19.
//  Copyright © 2020 Holk. All rights reserved.
//

import UIKit

final class ThinkOfBannerCollectionHeaderView: UICollectionReusableView {
    private let headerBackgroundView = UIView()
    private let iconView = HolkIconView()
    private let tagLabel = HolkLabel()
    private let titleLabel = HolkLabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    private func setup() {
        clipsToBounds = true
        backgroundColor = Color.mainBackground

        layoutMargins = .init(top: 0, left: 26, bottom: 26, right: 26)

        headerBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        iconView.tintColor = Color.mainForeground
        iconView.translatesAutoresizingMaskIntoConstraints = false

        tagLabel.styleGuide = .titleHeader1
        tagLabel.numberOfLines = 0
        tagLabel.textColor = Color.mainForeground
        tagLabel.translatesAutoresizingMaskIntoConstraints = false

        titleLabel.styleGuide = .cardHeader3
        titleLabel.numberOfLines = 0
        titleLabel.textColor = Color.secondaryLabel
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        setupLayout()
    }

    private func setupLayout() {
        addSubview(headerBackgroundView)
        headerBackgroundView.addSubview(iconView)
        headerBackgroundView.addSubview(tagLabel)
        headerBackgroundView.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            headerBackgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
            headerBackgroundView.topAnchor.constraint(equalTo: topAnchor),
            headerBackgroundView.trailingAnchor.constraint(equalTo: trailingAnchor),
            headerBackgroundView.bottomAnchor.constraint(equalTo: bottomAnchor),

            iconView.widthAnchor.constraint(equalToConstant: 52),
            iconView.heightAnchor.constraint(equalToConstant: 52),
            iconView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            iconView.topAnchor.constraint(equalTo: topAnchor, constant: 60),

            tagLabel.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            tagLabel.topAnchor.constraint(equalTo: iconView.bottomAnchor, constant: 12),
            tagLabel.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),

            titleLabel.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            titleLabel.topAnchor.constraint(equalTo: tagLabel.lastBaselineAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: headerBackgroundView.bottomAnchor, constant: -40)
        ])
    }
}

extension ThinkOfBannerCollectionHeaderView {
    func configure(_ viewModel: ThinkOfDetailsViewModel) {
           iconView.image = viewModel.iconImage
           iconView.backgroundColor = viewModel.iconImageBackgroundColor
           tagLabel.text = viewModel.subInsuranceText
           titleLabel.text = viewModel.title
           headerBackgroundView.backgroundColor = viewModel.headerBackgroundViewColor
       }
}
