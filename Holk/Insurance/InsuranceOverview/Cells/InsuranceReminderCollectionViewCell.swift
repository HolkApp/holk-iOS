//
//  InsuranceReminderCollectionViewCell.swift
//  Holk
//
//  Created by 张梦皓 on 2020-04-19.
//  Copyright © 2020 Holk. All rights reserved.
//

import UIKit

protocol InsuranceReminderCollectionViewCellDelegate: AnyObject {
    func thinkOfTapped()
    func reminderTapped()
}

final class InsuranceReminderCollectionViewCell: UICollectionViewCell {
    // MARK: Public variables
    weak var delegate: InsuranceReminderCollectionViewCellDelegate?

    // MARK: Private variables
    private let reminderView = HolkFloatingCardView()
    private let thinkOfView = HolkFloatingCardView()
    private let reminderValueLabel = HolkRoundBackgroundLabel()
    private let reminderImageView = UIImageView()
    private let reminderLabel = UILabel()
    private let thinkOfValueLabel = HolkRoundBackgroundLabel()
    private let thinkOfImageView = UIImageView()
    private let thinkOfLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        delegate = nil
    }

    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let layoutAttributes = super.preferredLayoutAttributesFitting(layoutAttributes)
        layoutIfNeeded()
        layoutAttributes.frame.size = systemLayoutSizeFitting(UIView.layoutFittingCompressedSize, withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
        return layoutAttributes
    }

    func configure(_ insurance: Insurance?) {
        // TODO: Update this
        thinkOfValueLabel.text = "2"
        thinkOfImageView.image = UIImage(systemName: "exclamationmark.triangle")
        thinkOfLabel.text = "Tänka på"
        reminderValueLabel.text = "3"
        reminderImageView.image = UIImage(systemName: "bell")
        reminderLabel.text = "Luckor"
    }

    private func setup() {
        backgroundColor = .clear

        // TODO: Remove this
        configure(nil)

        reminderValueLabel.font = Font.medium(.label)
        reminderValueLabel.backgroundColor = Color.mainBackgroundColor
        reminderValueLabel.textColor = Color.mainForegroundColor
        reminderValueLabel.textAlignment = .center
        reminderValueLabel.translatesAutoresizingMaskIntoConstraints = false

        reminderImageView.tintColor = Color.mainForegroundColor.withAlphaComponent(0.35)
        reminderImageView.translatesAutoresizingMaskIntoConstraints = false

        reminderLabel.textColor = Color.mainForegroundColor
        reminderLabel.numberOfLines = 0
        reminderLabel.translatesAutoresizingMaskIntoConstraints = false

        thinkOfValueLabel.font = Font.medium(.label)
        thinkOfValueLabel.backgroundColor = Color.mainBackgroundColor
        thinkOfValueLabel.textColor = Color.warningColor
        thinkOfValueLabel.textAlignment = .center
        thinkOfValueLabel.translatesAutoresizingMaskIntoConstraints = false

        thinkOfImageView.tintColor = Color.mainForegroundColor.withAlphaComponent(0.35)
        thinkOfImageView.translatesAutoresizingMaskIntoConstraints = false

        thinkOfLabel.textColor = Color.mainForegroundColor
        thinkOfLabel.numberOfLines = 0
        thinkOfLabel.translatesAutoresizingMaskIntoConstraints = false
        
        reminderView.backgroundColor = Color.secondaryBackgroundColor
        reminderView.layer.shadowOffset = CGSize(width: 0, height: 2)
        reminderView.layer.shadowColor = UIColor.black.cgColor
        reminderView.layer.shadowOpacity = 0.15
        reminderView.layer.shadowRadius = 30
        reminderView.layer.cornerRadius = 8
        reminderView.layer.cornerCurve = .continuous
        reminderView.addTarget(self, action: #selector(reminderTapped(sender:)), for: .touchUpInside)
        reminderView.translatesAutoresizingMaskIntoConstraints = false

        thinkOfView.backgroundColor = Color.secondaryBackgroundColor
        thinkOfView.layer.shadowOffset = CGSize(width: 0, height: 2)
        thinkOfView.layer.shadowColor = UIColor.black.cgColor
        thinkOfView.layer.shadowOpacity = 0.15
        thinkOfView.layer.shadowRadius = 30
        thinkOfView.layer.cornerRadius = 8
        thinkOfView.layer.cornerCurve = .continuous
        thinkOfView.addTarget(self, action: #selector(thinkOfTapped(sender:)), for: .touchUpInside)
        thinkOfView.translatesAutoresizingMaskIntoConstraints = false
    }

    private func setupLayout() {
        contentView.addSubview(thinkOfView)
        contentView.addSubview(reminderView)

        thinkOfView.addSubview(thinkOfValueLabel)
        thinkOfView.addSubview(thinkOfImageView)
        thinkOfView.addSubview(thinkOfLabel)

        reminderView.addSubview(reminderValueLabel)
        reminderView.addSubview(reminderImageView)
        reminderView.addSubview(reminderLabel)

        NSLayoutConstraint.activate([
            thinkOfValueLabel.leadingAnchor.constraint(equalTo: thinkOfView.leadingAnchor, constant: 12),
            thinkOfValueLabel.topAnchor.constraint(equalTo: thinkOfView.topAnchor, constant: 12),
            thinkOfValueLabel.trailingAnchor.constraint(equalTo: thinkOfImageView.leadingAnchor, constant: -12),
            thinkOfValueLabel.bottomAnchor.constraint(equalTo: thinkOfLabel.topAnchor, constant: -12),

            thinkOfImageView.widthAnchor.constraint(equalToConstant: 24),
            thinkOfImageView.heightAnchor.constraint(equalToConstant: 24),
            thinkOfImageView.centerYAnchor.constraint(equalTo: thinkOfValueLabel.centerYAnchor),
            thinkOfImageView.trailingAnchor.constraint(lessThanOrEqualTo: thinkOfView.trailingAnchor, constant: -12),

            thinkOfLabel.leadingAnchor.constraint(equalTo: thinkOfValueLabel.leadingAnchor),
            thinkOfLabel.trailingAnchor.constraint(equalTo: thinkOfView.trailingAnchor, constant: -12),
            thinkOfLabel.bottomAnchor.constraint(equalTo: thinkOfView.bottomAnchor, constant: -12),

            reminderValueLabel.leadingAnchor.constraint(equalTo: reminderView.leadingAnchor, constant: 12),
            reminderValueLabel.topAnchor.constraint(equalTo: reminderView.topAnchor, constant: 12),
            reminderValueLabel.trailingAnchor.constraint(equalTo: reminderImageView.leadingAnchor, constant: -12),
            reminderValueLabel.bottomAnchor.constraint(equalTo: reminderLabel.topAnchor, constant: -12),

            reminderImageView.widthAnchor.constraint(equalToConstant: 24),
            reminderImageView.heightAnchor.constraint(equalToConstant: 24),
            reminderImageView.centerYAnchor.constraint(equalTo: reminderValueLabel.centerYAnchor),
            reminderImageView.trailingAnchor.constraint(lessThanOrEqualTo: reminderView.trailingAnchor, constant: -12),

            reminderLabel.leadingAnchor.constraint(equalTo: reminderValueLabel.leadingAnchor),
            reminderLabel.trailingAnchor.constraint(equalTo: reminderView.trailingAnchor, constant: -12),
            reminderLabel.bottomAnchor.constraint(equalTo: reminderView.bottomAnchor, constant: -12),

            reminderView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            reminderView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            reminderView.widthAnchor.constraint(equalTo: thinkOfView.widthAnchor),
            reminderView.trailingAnchor.constraint(equalTo: thinkOfView.leadingAnchor, constant: -24),
            reminderView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            
            thinkOfView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            thinkOfView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            thinkOfView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }

    @objc private func thinkOfTapped(sender: UIControl) {
        delegate?.thinkOfTapped()
    }

    @objc private func reminderTapped(sender: UIControl) {
        delegate?.reminderTapped()
    }
}
