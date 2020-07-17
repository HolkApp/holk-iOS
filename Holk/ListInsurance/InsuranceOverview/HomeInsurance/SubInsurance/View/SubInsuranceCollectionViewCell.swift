//
//  SubInsuranceCollectionViewCell.swift
//  Holk
//
//  Created by 张梦皓 on 2020-07-05.
//  Copyright © 2020 Holk. All rights reserved.
//

import UIKit

final class SubInsuranceCollectionViewCell: UICollectionViewCell {
    private let cardView = UIView()
    private let iconView = HolkIconView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let chevronView = UIImageView()

    private let gapView = UIView()
    private let gapValueLabel = HolkRoundBackgroundLabel()
    private let gapImageView = UIImageView()
    private let thinkOfView = UIView()
    private let thinkOfValueLabel = HolkRoundBackgroundLabel()
    private let thinkOfImageView = UIImageView()
    private let stackView = UIStackView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        iconView.imageView.image = nil
    }

    func configure(_ segment: Insurance.Segment) {
        switch segment.kind {
        case .home:
            iconView.imageView.image = UIImage.init(insuranceSegment: segment)
            iconView.backgroundColor = Color.goodsInsuranceIconBackgroundColor
            cardView.backgroundColor = Color.goodsInsuranceBackgroundColor
        case .travel:
            iconView.imageView.image = UIImage.init(insuranceSegment: segment)
            iconView.backgroundColor = Color.travelInsuranceIconBackgroundColor
            cardView.backgroundColor = Color.travelInsuranceBackgroundColor
        case .pets:
            // TODO:
            iconView.backgroundColor = .systemPink
            cardView.backgroundColor = Color.mainHighlight
        }
        titleLabel.text = segment.kind.rawValue
        descriptionLabel.text = segment.description

        // TODO:
        gapValueLabel.text = "1"
        thinkOfValueLabel.text = "0"
    }

    private func setup() {
        layer.cornerRadius = 15
        layer.shadowOffset = CGSize(width: 0, height: 8)
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.08

        translatesAutoresizingMaskIntoConstraints = false
        contentView.layoutMargins = .init(top: 0, left: 18, bottom: 0, right: 18)

        cardView.layer.cornerRadius = 10
        cardView.translatesAutoresizingMaskIntoConstraints = false

        iconView.imageView.tintColor = Color.mainForeground
        iconView.translatesAutoresizingMaskIntoConstraints = false

        titleLabel.setStyleGuide(.cardHeader2)
        titleLabel.textColor = Color.secondaryLabel
        titleLabel.numberOfLines = 0
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        descriptionLabel.setStyleGuide(.body1)
        descriptionLabel.textColor = Color.mainForeground
        descriptionLabel.numberOfLines = 0
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false

        chevronView.image = UIImage(systemName: "chevron.right")
        chevronView.tintColor = Color.mainForeground
        chevronView.translatesAutoresizingMaskIntoConstraints = false

        gapImageView.image = UIImage(systemName: "bell")?.withSymbolWeightConfiguration(.light)
        gapImageView.contentMode = .scaleAspectFit
        gapImageView.tintColor = Color.mainForeground
        gapImageView.translatesAutoresizingMaskIntoConstraints = false

        gapValueLabel.cornerRadius = 10
        gapValueLabel.setStyleGuide(.number1)
        gapValueLabel.textColor = Color.warning
        gapValueLabel.backgroundColor = Color.secondaryBackground
        gapValueLabel.textAlignment = .center
        gapValueLabel.translatesAutoresizingMaskIntoConstraints = false

        thinkOfImageView.image = UIImage(named: "light")?.withSymbolWeightConfiguration(.light)
        thinkOfImageView.contentMode = .scaleAspectFit
        thinkOfImageView.tintColor = Color.mainForeground
        thinkOfImageView.translatesAutoresizingMaskIntoConstraints = false

        thinkOfValueLabel.cornerRadius = 10
        thinkOfValueLabel.setStyleGuide(.number1)
        thinkOfValueLabel.textColor = Color.mainForeground
        thinkOfValueLabel.backgroundColor = Color.secondaryBackground
        thinkOfValueLabel.textAlignment = .center
        thinkOfValueLabel.translatesAutoresizingMaskIntoConstraints = false

        gapView.translatesAutoresizingMaskIntoConstraints = false
        thinkOfView.translatesAutoresizingMaskIntoConstraints = false

        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.translatesAutoresizingMaskIntoConstraints = false
    }

    private func setupLayout() {
        contentView.addSubview(cardView)

        cardView.addSubview(iconView)
        cardView.addSubview(titleLabel)
        cardView.addSubview(descriptionLabel)
        cardView.addSubview(chevronView)
        cardView.addSubview(stackView)

        gapView.addSubview(gapImageView)
        gapView.addSubview(gapValueLabel)
        thinkOfView.addSubview(thinkOfImageView)
        thinkOfView.addSubview(thinkOfValueLabel)

        stackView.addArrangedSubview(gapView)
        stackView.addArrangedSubview(thinkOfView)

        NSLayoutConstraint.activate([
            cardView.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            cardView.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            cardView.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            cardView.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor),

            iconView.widthAnchor.constraint(equalToConstant: 56),
            iconView.heightAnchor.constraint(equalToConstant: 56),
            iconView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 24),
            iconView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 24),

            titleLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 24),
            titleLabel.topAnchor.constraint(equalTo: iconView.bottomAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -24),

            descriptionLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 24),
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6),
            descriptionLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -24),
            descriptionLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -16),

            gapImageView.heightAnchor.constraint(equalToConstant: 30),
            gapImageView.widthAnchor.constraint(equalToConstant: 30),
            gapImageView.leadingAnchor.constraint(equalTo: gapView.leadingAnchor),
            gapImageView.topAnchor.constraint(equalTo: gapView.topAnchor),
            gapImageView.bottomAnchor.constraint(equalTo: gapView.bottomAnchor),

            gapValueLabel.leadingAnchor.constraint(equalTo: gapImageView.trailingAnchor, constant: 8),
            gapValueLabel.topAnchor.constraint(equalTo: gapView.topAnchor),
            gapValueLabel.bottomAnchor.constraint(equalTo: gapView.bottomAnchor),
            gapValueLabel.trailingAnchor.constraint(equalTo: gapView.trailingAnchor),

            thinkOfImageView.heightAnchor.constraint(equalToConstant: 30),
            thinkOfImageView.widthAnchor.constraint(equalToConstant: 30),
            thinkOfImageView.leadingAnchor.constraint(equalTo: thinkOfView.leadingAnchor),
            thinkOfImageView.topAnchor.constraint(equalTo: thinkOfView.topAnchor),
            thinkOfImageView.bottomAnchor.constraint(equalTo: thinkOfView.bottomAnchor),

            thinkOfValueLabel.leadingAnchor.constraint(equalTo: thinkOfImageView.trailingAnchor, constant: 8),
            thinkOfValueLabel.topAnchor.constraint(equalTo: thinkOfView.topAnchor),
            thinkOfValueLabel.bottomAnchor.constraint(equalTo: thinkOfView.bottomAnchor),
            thinkOfValueLabel.trailingAnchor.constraint(equalTo: thinkOfView.trailingAnchor),

            stackView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 12),
            stackView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -12),

            chevronView.widthAnchor.constraint(equalToConstant: 16),
            chevronView.heightAnchor.constraint(equalToConstant: 24),
            chevronView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -12),
            chevronView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -12)
        ])
    }
}
