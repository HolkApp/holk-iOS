//
//  InsurancesuggestionCardCollectionViewCell.swift
//  Holk
//
//  Created by 张梦皓 on 2020-04-21.
//  Copyright © 2020 Holk. All rights reserved.
//

import UIKit
import Lottie

class InsuranceSuggestionCardCollectionViewCell: UICollectionViewCell {
    enum SuggestionType {
        case reminder
        case thinkOf
    }

    // MARK: Private variables
    private let suggestionView = UIView()
    private let suggestionValueLabel = HolkRoundBackgroundLabel()
    private let suggestionImageView = AnimationView()
    private let suggestionLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let layoutAttributes = super.preferredLayoutAttributesFitting(layoutAttributes)
        layoutIfNeeded()
        layoutAttributes.frame.size = systemLayoutSizeFitting(UIView.layoutFittingCompressedSize, withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
        return layoutAttributes
    }

    override var isHighlighted: Bool {
        didSet {
            suggestionView.backgroundColor = isHighlighted ? Color.suggestionCardPressDownBackgroundColor : Color.suggestionCardBackgroundColor
        }
    }

    func configure(_ insurance: Insurance?, suggestionType: SuggestionType) {
        // TODO: Update this
        switch suggestionType {
        case .reminder:
            suggestionValueLabel.text = "3"
            let starAnimation = Animation.named("Bell")
            suggestionImageView.animation = starAnimation
            suggestionImageView.play(fromProgress: 0, toProgress: 0.55, loopMode: .repeat(2)) {  [weak self] finished in
                self?.suggestionImageView.currentProgress = 0.85
            }
            
            suggestionLabel.text = "Luckor"
            suggestionValueLabel.textColor = Color.mainForegroundColor
        case .thinkOf:
            suggestionValueLabel.text = "2"
            let starAnimation = Animation.named("Bell")
            suggestionImageView.animation = starAnimation
            suggestionImageView.play(fromProgress: 0, toProgress: 0.55, loopMode: .repeat(2)) {  [weak self] finished in
                self?.suggestionImageView.currentProgress = 0.85
            }

            suggestionLabel.text = "Tänk på"
            suggestionValueLabel.textColor = Color.mainForegroundColor
        }
    }

    private func setup() {
        contentView.layoutMargins = .init(top: 6, left: 6, bottom: 6, right: 6)
        backgroundColor = .clear

        suggestionView.layoutMargins = .init(top: 8, left: 12, bottom: 8, right: 12)
        suggestionView.backgroundColor = Color.suggestionCardBackgroundColor
        suggestionView.layer.shadowOffset = CGSize(width: 0, height: 2)
        suggestionView.layer.shadowColor = UIColor.black.cgColor
        suggestionView.layer.shadowOpacity = 0.15
        suggestionView.layer.shadowRadius = 30
        suggestionView.layer.cornerRadius = 8
        suggestionView.layer.cornerCurve = .continuous
        suggestionView.translatesAutoresizingMaskIntoConstraints = false

        suggestionValueLabel.cornerRadius = 10
        suggestionValueLabel.setStyleGuide(.numbers1)
        suggestionValueLabel.backgroundColor = Color.secondaryBackgroundColor
        suggestionValueLabel.textAlignment = .center
        suggestionValueLabel.translatesAutoresizingMaskIntoConstraints = false

        suggestionImageView.contentMode = .scaleAspectFit
        suggestionImageView.translatesAutoresizingMaskIntoConstraints = false

        suggestionLabel.setStyleGuide(.body1)
        suggestionLabel.textColor = Color.mainForegroundColor
        suggestionLabel.numberOfLines = 0
        suggestionLabel.translatesAutoresizingMaskIntoConstraints = false

        setupLayout()
    }

    private func setupLayout() {
        contentView.addSubview(suggestionView)

        suggestionView.addSubview(suggestionValueLabel)
        suggestionView.addSubview(suggestionImageView)
        suggestionView.addSubview(suggestionLabel)

        NSLayoutConstraint.activate([
            suggestionValueLabel.widthAnchor.constraint(equalToConstant: 40),
            suggestionValueLabel.heightAnchor.constraint(equalToConstant: 30),
            suggestionValueLabel.centerYAnchor.constraint(equalTo: suggestionImageView
                .centerYAnchor),
            suggestionValueLabel.trailingAnchor.constraint(lessThanOrEqualTo: suggestionView.layoutMarginsGuide.trailingAnchor),

            suggestionImageView.widthAnchor.constraint(equalToConstant: 36),
            suggestionImageView.heightAnchor.constraint(equalToConstant: 36),
            suggestionImageView.leadingAnchor.constraint(equalTo: suggestionView.layoutMarginsGuide.leadingAnchor),
            suggestionImageView.topAnchor.constraint(equalTo: suggestionView.layoutMarginsGuide.topAnchor),
            suggestionImageView.bottomAnchor.constraint(equalTo: suggestionLabel.topAnchor, constant: -4),

            suggestionLabel.leadingAnchor.constraint(equalTo: suggestionImageView
.leadingAnchor),
            suggestionLabel.trailingAnchor.constraint(equalTo: suggestionView.layoutMarginsGuide.trailingAnchor),
            suggestionLabel.lastBaselineAnchor.constraint(equalTo: suggestionView.layoutMarginsGuide.bottomAnchor),

            suggestionView.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            suggestionView.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            suggestionView.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            suggestionView.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor)
        ])
    }
}


