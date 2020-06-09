//
//  InsuranceTableViewCell.swift
//  Holk
//
//  Created by 张梦皓 on 2019-06-11.
//  Copyright © 2019 Holk. All rights reserved.
//

import UIKit

final class InsuranceCollectionViewCell: UICollectionViewCell {
    // MARK: - Public variables
    var insurance: Insurance?
    let containerView = UIView()

    // MARK: - Private variables
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let insuranceTypeImageView = UIImageView()
    private let insuranceImageView = UIImageView()
    private let clockImageView = UIImageView()
    private let daysLabel = UILabel()
    private let daysTextLabel = UILabel()
    
    private let lightFeedbackGenerator = UIImpactFeedbackGenerator(style: .light)

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

    func configure(_ insurance: Insurance) {
        self.insurance = insurance
        titleLabel.text = insurance.insuranceType
        subtitleLabel.text = insurance.address
        UIImage.imageWithUrl(imageUrlString: insurance.insuranceProvider.logoUrl) { [weak self] image in
            self?.insuranceImageView.image = image
        }
        daysLabel.text = "118"
        daysTextLabel.text = "Dagar kvar"
    }

    private func setup() {
        backgroundColor = .clear
        contentView.layoutMargins = .init(top: 6, left: 6, bottom: 6, right: 6)

        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.15
        layer.shadowRadius = 30
        layer.cornerCurve = .continuous

        containerView.backgroundColor = Color.secondaryBackgroundColor
        containerView.layer.cornerRadius = 16
        containerView.layer.cornerCurve = .continuous
        containerView.translatesAutoresizingMaskIntoConstraints = false

        titleLabel.font = Font.extraBold(.title)
        titleLabel.textColor = Color.mainForegroundColor
        titleLabel.numberOfLines = 0
        titleLabel.setContentHuggingPriority(.required, for: .vertical)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        subtitleLabel.font = Font.regular(.subtitle)
        subtitleLabel.textColor = Color.mainForegroundColor
        subtitleLabel.numberOfLines = 0
        subtitleLabel.setContentHuggingPriority(.required, for: .vertical)
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false

        clockImageView.contentMode = .scaleAspectFit
        clockImageView.image = UIImage(systemName: "clock")?.withSymbolWeightConfiguration(.regular)
        clockImageView.tintColor = Color.mainForegroundColor
        clockImageView.translatesAutoresizingMaskIntoConstraints = false

        daysLabel.setStyleGuide(.numbers2)
        daysLabel.textColor = Color.mainForegroundColor
        daysLabel.numberOfLines = 0
        daysLabel.textAlignment = .center
        daysLabel.translatesAutoresizingMaskIntoConstraints = false

        daysTextLabel.setStyleGuide(.body1)
        daysTextLabel.textColor = Color.secondaryForegroundColor
        daysTextLabel.numberOfLines = 0
        daysTextLabel.textAlignment = .center
        daysTextLabel.translatesAutoresizingMaskIntoConstraints = false

        insuranceTypeImageView.image = UIImage(named: "house")
        insuranceTypeImageView.contentMode = .scaleAspectFit
        insuranceTypeImageView.translatesAutoresizingMaskIntoConstraints = false

        insuranceImageView.contentMode = .scaleAspectFit
        insuranceImageView.translatesAutoresizingMaskIntoConstraints = false
    }

    private func setupLayout() {
        contentView.addSubview(containerView)

        containerView.addSubview(titleLabel)
        containerView.addSubview(subtitleLabel)
        containerView.addSubview(insuranceTypeImageView)
        containerView.addSubview(insuranceImageView)

        containerView.addSubview(clockImageView)
        containerView.addSubview(daysLabel)
        containerView.addSubview(daysTextLabel)

        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            containerView.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor),

            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24),

            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.lastBaselineAnchor, constant: 8),
            subtitleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
            subtitleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),

            insuranceTypeImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
            insuranceTypeImageView.topAnchor.constraint(equalTo: subtitleLabel.lastBaselineAnchor, constant: 48),
            insuranceTypeImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24),
            insuranceTypeImageView.bottomAnchor.constraint(equalTo: clockImageView.topAnchor, constant: -56),

            clockImageView.widthAnchor.constraint(equalToConstant: 28),
            clockImageView.heightAnchor.constraint(equalToConstant: 28),
            clockImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
            clockImageView.trailingAnchor.constraint(equalTo: daysLabel.leadingAnchor, constant: -8),
            clockImageView.bottomAnchor.constraint(equalTo: daysTextLabel.topAnchor, constant: -4),

            daysLabel.centerYAnchor.constraint(equalTo: clockImageView.centerYAnchor),

            daysTextLabel.leadingAnchor.constraint(equalTo: clockImageView.leadingAnchor),
            daysTextLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16),

            insuranceImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24),
            insuranceImageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16)
        ])
    }
}
