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
                let scaleTransform = isHighlighted ? CGAffineTransform(scaleX: 0.95, y: 0.95) : .identity
                let animator = UIViewPropertyAnimator(duration: 0.1, curve: .easeInOut) {
                    self.transform = scaleTransform
                }
                animator.startAnimation()
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
            hintValueLabel.textColor = Color.warningColor
        }
    }

    private func setup() {
        contentView.layoutMargins = .init(top: 6, left: 6, bottom: 6, right: 6)
        backgroundColor = .clear

        hintView.layoutMargins = .init(top: 12, left: 12, bottom: 4, right: 12)
        hintView.backgroundColor = Color.secondaryBackgroundColor
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

        hintImageView.tintColor = Color.mainForegroundColor.withAlphaComponent(0.35)
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
            hintValueLabel.leadingAnchor.constraint(equalTo: hintView.layoutMarginsGuide.leadingAnchor),
            hintValueLabel.topAnchor.constraint(equalTo: hintView.layoutMarginsGuide.topAnchor),
            hintValueLabel.trailingAnchor.constraint(equalTo: hintImageView.leadingAnchor, constant: -12),
            hintValueLabel.bottomAnchor.constraint(equalTo: hintLabel.topAnchor, constant: -12),

            hintImageView.widthAnchor.constraint(equalToConstant: 24),
            hintImageView.heightAnchor.constraint(equalToConstant: 24),
            hintImageView.centerYAnchor.constraint(equalTo: hintValueLabel
.centerYAnchor),
            hintImageView.trailingAnchor.constraint(lessThanOrEqualTo: hintView.layoutMarginsGuide.trailingAnchor),

            hintLabel.leadingAnchor.constraint(equalTo: hintValueLabel
.leadingAnchor),
            hintLabel.trailingAnchor.constraint(equalTo: hintView.layoutMarginsGuide.trailingAnchor),
            hintLabel.bottomAnchor.constraint(equalTo: hintView.layoutMarginsGuide.bottomAnchor),

            hintView.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            hintView.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            hintView.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            hintView.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor)
        ])
    }

}


