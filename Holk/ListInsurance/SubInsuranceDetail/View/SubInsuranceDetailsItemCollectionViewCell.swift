//
//  SubInsuranceDetailsItemCollectionViewCell.swift
//  Holk
//
//  Created by 张梦皓 on 2020-10-19.
//  Copyright © 2020 Holk. All rights reserved.
//

import UIKit

final class SubInsuranceDetailsItemCollectionViewCell: UICollectionViewCell {
    private let imageView = UIImageView()
    private let titleLabel = HolkLabel()
    private let containerView = UIView()
    private let itemView = SubInsuranceDetailsItemView()
    private let separatorLine = UIView()
    private let coverImageView = UIImageView()
    private let helperLabel = HolkLabel()
    private let chevronView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(_ item: Insurance.SubInsurance.Item) {
        itemView.configure(item: item)
        titleLabel.text = item.name
        helperLabel.text = item.result
    }

    private func setup() {
        contentView.layoutMargins = .init(top: 0, left: 20, bottom: 0, right: 20)

        // TODO: Update the image
        imageView.image = UIImage(named: "house")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false

        titleLabel.numberOfLines = 0
        titleLabel.styleGuide = .titleHeader1
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        containerView.backgroundColor = Color.secondaryBackground
        containerView.layoutMargins = .init(top: 12, left: 12, bottom: 12, right: 12)
        containerView.layer.cornerRadius = 5
        containerView.translatesAutoresizingMaskIntoConstraints = false

        itemView.translatesAutoresizingMaskIntoConstraints = false

        separatorLine.backgroundColor = Color.separator
        separatorLine.translatesAutoresizingMaskIntoConstraints = false

        // TODO: Update the color
        coverImageView.tintColor = Color.label
        coverImageView.contentMode = .scaleAspectFit
        coverImageView.image = UIImage(systemName: "exclamationmark.triangle")?.withSymbolWeightConfiguration(.light)
        coverImageView.translatesAutoresizingMaskIntoConstraints = false

        helperLabel.numberOfLines = 0
        helperLabel.translatesAutoresizingMaskIntoConstraints = false

        chevronView.tintColor = Color.label
        chevronView.contentMode = .scaleAspectFit
        chevronView.image = UIImage(systemName: "chevron.right")
        chevronView.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(containerView)
        containerView.addSubview(itemView)
        containerView.addSubview(separatorLine)
        containerView.addSubview(coverImageView)
        containerView.addSubview(helperLabel)
        containerView.addSubview(chevronView)

        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor, constant: 44),
            imageView.heightAnchor.constraint(equalToConstant: 48),
            imageView.widthAnchor.constraint(equalToConstant: 48),

            titleLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 14),
            titleLabel.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),

            containerView.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            containerView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 24),
            containerView.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            itemView.leadingAnchor.constraint(equalTo: containerView.layoutMarginsGuide.leadingAnchor),
            itemView.topAnchor.constraint(equalTo: containerView.layoutMarginsGuide.topAnchor),
            itemView.trailingAnchor.constraint(equalTo: containerView.layoutMarginsGuide.trailingAnchor),

            separatorLine.leadingAnchor.constraint(equalTo: containerView.layoutMarginsGuide.leadingAnchor),
            separatorLine.topAnchor.constraint(equalTo: itemView.bottomAnchor, constant: 12),
            separatorLine.trailingAnchor.constraint(equalTo: containerView.layoutMarginsGuide.trailingAnchor),
            separatorLine.heightAnchor.constraint(equalToConstant: 1),

            coverImageView.leadingAnchor.constraint(equalTo: containerView.layoutMarginsGuide.leadingAnchor),
            coverImageView.widthAnchor.constraint(equalToConstant: 32),
            coverImageView.heightAnchor.constraint(equalToConstant: 32),

            helperLabel.leadingAnchor.constraint(equalTo: coverImageView.trailingAnchor, constant: 16),
            helperLabel.topAnchor.constraint(equalTo: separatorLine.bottomAnchor, constant: 14),
            helperLabel.centerYAnchor.constraint(equalTo: coverImageView.centerYAnchor),
            helperLabel.bottomAnchor.constraint(equalTo: containerView.layoutMarginsGuide.bottomAnchor),

            chevronView.leadingAnchor.constraint(equalTo: helperLabel.trailingAnchor, constant: 28),
            chevronView.trailingAnchor.constraint(equalTo: containerView.layoutMarginsGuide.trailingAnchor),
            chevronView.widthAnchor.constraint(equalToConstant: 16),
            chevronView.heightAnchor.constraint(equalToConstant: 20),
            chevronView.bottomAnchor.constraint(equalTo: containerView.layoutMarginsGuide.bottomAnchor)
        ])
    }
}
