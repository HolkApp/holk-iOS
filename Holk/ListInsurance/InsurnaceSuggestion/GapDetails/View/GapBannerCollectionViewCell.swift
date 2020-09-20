//
//  GapBannerCollectionViewCell.swift
//  Holk
//
//  Created by 张梦皓 on 2020-09-11.
//  Copyright © 2020 Holk. All rights reserved.
//

import UIKit

final class GapBannerCollectionViewCell: UICollectionViewCell {
    private let iconView = UIImageView()
    private let titleLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        backgroundColor = Color.mainForeground

        iconView.contentMode = .scaleAspectFit
        iconView.backgroundColor = .clear
        iconView.tintColor = Color.secondaryBackground
        iconView.translatesAutoresizingMaskIntoConstraints = false

        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.textColor = Color.gapLabel
        titleLabel.setStyleGuide(.titleHeader1)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        setupLayout()
    }

    private func setupLayout() {
        contentView.addSubview(iconView)
        contentView.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            iconView.widthAnchor.constraint(equalToConstant: 56),
            iconView.heightAnchor.constraint(equalToConstant: 56),
            iconView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            iconView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 80),
            iconView.bottomAnchor.constraint(equalTo: titleLabel.topAnchor, constant: -28),

            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -80)
        ])
    }
}

extension GapBannerCollectionViewCell {
    func configure(_ viewModel: GapBannerViewModel) {
        iconView.image = viewModel.icon
        titleLabel.set(text: viewModel.title, with: .cardHeader3)
    }
}
