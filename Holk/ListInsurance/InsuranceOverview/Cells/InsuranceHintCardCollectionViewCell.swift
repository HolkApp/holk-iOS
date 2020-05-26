//
//  InsuranceHintCardCollectionViewCell.swift
//  Holk
//
//  Created by 张梦皓 on 2020-04-21.
//  Copyright © 2020 Holk. All rights reserved.
//

import UIKit
import Lottie

class InsuranceHintCardCollectionViewCell: UICollectionViewCell {
    enum HintType {
        case reminder
        case thinkOf
    }

    // MARK: Private variables
    private let hintView = UIView()
    private let hintValueLabel = HolkRoundBackgroundLabel()
    private let hintImageView = AnimationView()
    private let hintLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
        setupLayout()
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
            hintView.backgroundColor = isHighlighted ? Color.hintCardPressDownBackgroundColor : Color.hintCardBackgroundColor
        }
    }

    func configure(_ insurance: Insurance?, hintType: HintType) {
        // TODO: Update this
        switch hintType {
        case .reminder:
            hintValueLabel.text = "3"
            let starAnimation = Animation.named("Bell")
            hintImageView.animation = starAnimation
            hintImageView.play(fromProgress: 0, toProgress: 0.55, loopMode: .repeat(2)) {  [weak self] finished in
                self?.hintImageView.currentProgress = 0.85
            }
            
            hintLabel.text = "Luckor"
            hintValueLabel.textColor = Color.mainForegroundColor
        case .thinkOf:
            hintValueLabel.text = "2"
            let starAnimation = Animation.named("Bell")
            hintImageView.animation = starAnimation
            hintImageView.play(fromProgress: 0, toProgress: 0.55, loopMode: .repeat(2)) {  [weak self] finished in
                self?.hintImageView.currentProgress = 0.85
            }

            hintLabel.text = "Tänk på"
            hintValueLabel.textColor = Color.mainForegroundColor
        }
    }

    private func setup() {
        contentView.layoutMargins = .init(top: 6, left: 6, bottom: 6, right: 6)
        backgroundColor = .clear

        hintView.layoutMargins = .init(top: 8, left: 12, bottom: 8, right: 12)
        hintView.backgroundColor = Color.hintCardBackgroundColor
        hintView.layer.shadowOffset = CGSize(width: 0, height: 2)
        hintView.layer.shadowColor = UIColor.black.cgColor
        hintView.layer.shadowOpacity = 0.15
        hintView.layer.shadowRadius = 30
        hintView.layer.cornerRadius = 8
        hintView.layer.cornerCurve = .continuous
        hintView.translatesAutoresizingMaskIntoConstraints = false

        hintValueLabel.setStyleGuide(.header5)
        hintValueLabel.backgroundColor = Color.mainBackgroundColor
        hintValueLabel.textAlignment = .center
        hintValueLabel.translatesAutoresizingMaskIntoConstraints = false

        hintImageView.contentMode = .scaleAspectFit
        hintImageView.translatesAutoresizingMaskIntoConstraints = false

        hintLabel.setStyleGuide(.body1)
        hintLabel.textColor = Color.mainForegroundColor
        hintLabel.numberOfLines = 0
        hintLabel.translatesAutoresizingMaskIntoConstraints = false
    }

    private func setupLayout() {
        contentView.addSubview(hintView)

        hintView.addSubview(hintValueLabel)
        hintView.addSubview(hintImageView)
        hintView.addSubview(hintLabel)

        NSLayoutConstraint.activate([
            hintValueLabel.widthAnchor.constraint(equalToConstant: 40),
            hintValueLabel.heightAnchor.constraint(equalToConstant: 30),
            hintValueLabel.centerYAnchor.constraint(equalTo: hintImageView
                .centerYAnchor),
            hintValueLabel.trailingAnchor.constraint(lessThanOrEqualTo: hintView.layoutMarginsGuide.trailingAnchor),

            hintImageView.widthAnchor.constraint(equalToConstant: 36),
            hintImageView.heightAnchor.constraint(equalToConstant: 36),
            hintImageView.leadingAnchor.constraint(equalTo: hintView.layoutMarginsGuide.leadingAnchor),
            hintImageView.topAnchor.constraint(equalTo: hintView.layoutMarginsGuide.topAnchor),
            hintImageView.bottomAnchor.constraint(equalTo: hintLabel.topAnchor, constant: -4),

            hintLabel.leadingAnchor.constraint(equalTo: hintImageView
.leadingAnchor),
            hintLabel.trailingAnchor.constraint(equalTo: hintView.layoutMarginsGuide.trailingAnchor),
            hintLabel.lastBaselineAnchor.constraint(equalTo: hintView.layoutMarginsGuide.bottomAnchor),

            hintView.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            hintView.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            hintView.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            hintView.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor)
        ])
    }
}


