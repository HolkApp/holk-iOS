//
//  InsuranceTableViewCell.swift
//  Holk
//
//  Created by 张梦皓 on 2019-06-11.
//  Copyright © 2019 Holk. All rights reserved.
//

import UIKit
import Kingfisher

final class InsuranceCollectionViewCell: UICollectionViewCell {
    // MARK: - Public variables
    var insurance: Insurance?
    let containerView = UIView()

    // MARK: - Private variables
    private let titleLabel = HolkLabel()
    private let subtitleLabel = HolkLabel()
    private let insuranceTypeImageView = UIImageView()
    private let insuranceImageView = UIImageView()
    private let clockImageView = UIImageView()
    private let daysLabel = HolkLabel()
    private let daysTextLabel = HolkLabel()
    
    private let lightFeedbackGenerator = UIImpactFeedbackGenerator(style: .light)

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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

    func configure(_ insurance: Insurance, provider: InsuranceProvider?) {
        self.insurance = insurance
        titleLabel.text = insurance.kind.description
        subtitleLabel.text = insurance.address
        insuranceImageView.kf.setImage(with: provider?.logoUrl)

        switch insurance.endDate.expirationDaysLeft() {
        case .valid(let daysLeft):
            daysLabel.text = "\(daysLeft)"
            daysTextLabel.text = "Dagar kvar"
        case .today:
            daysLabel.text = ""
            daysTextLabel.text = "Ends today"
        case .expired:
            daysLabel.text = ""
            daysTextLabel.text = "Expired"
        default:
            daysLabel.text = ""
            daysTextLabel.text = ""
        }
    }

    private func setup() {
        backgroundColor = .clear
        contentView.layoutMargins = .init(top: 6, left: 6, bottom: 6, right: 6)

        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowRadius = 40

        containerView.backgroundColor = Color.mainBackground
        containerView.layer.cornerRadius = 16
        containerView.layer.cornerCurve = .continuous
        containerView.translatesAutoresizingMaskIntoConstraints = false

        titleLabel.styleGuide = .header5
        titleLabel.textColor = Color.mainForeground
        titleLabel.numberOfLines = 0
        titleLabel.setContentHuggingPriority(.required, for: .vertical)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        subtitleLabel.styleGuide = .subHeader3
        subtitleLabel.textColor = Color.mainForeground
        subtitleLabel.numberOfLines = 0
        subtitleLabel.setContentHuggingPriority(.required, for: .vertical)
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false

        clockImageView.contentMode = .scaleAspectFit
        clockImageView.image = UIImage(systemName: "clock")?.withSymbolWeightConfiguration(.regular)
        clockImageView.tintColor = Color.mainForeground
        clockImageView.translatesAutoresizingMaskIntoConstraints = false

        daysLabel.styleGuide = .number2
        daysLabel.textColor = Color.mainForeground
        daysLabel.numberOfLines = 0
        daysLabel.textAlignment = .center
        daysLabel.translatesAutoresizingMaskIntoConstraints = false

        daysTextLabel.styleGuide = .body1
        daysTextLabel.textColor = Color.secondaryForeground
        daysTextLabel.numberOfLines = 0
        daysTextLabel.textAlignment = .center
        daysTextLabel.translatesAutoresizingMaskIntoConstraints = false

        insuranceTypeImageView.image = UIImage(named: "house")
        insuranceTypeImageView.contentMode = .scaleAspectFit
        insuranceTypeImageView.translatesAutoresizingMaskIntoConstraints = false

        insuranceImageView.contentMode = .scaleAspectFit
        insuranceImageView.translatesAutoresizingMaskIntoConstraints = false

        setupLayout()
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

            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 18),
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

            insuranceImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            insuranceImageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -8),
            insuranceImageView.widthAnchor.constraint(equalToConstant: 120),
            insuranceImageView.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
}
