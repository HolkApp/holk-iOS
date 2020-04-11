//
//  InsuranceDetailTableViewCell.swift
//  Holk
//
//  Created by 张梦皓 on 2020-03-28.
//  Copyright © 2020 Holk. All rights reserved.
//

import UIKit

class InsuranceDetailTableViewCell: UITableViewCell {
    // MARK: - Private variables
    private let lightFeedbackGenerator = UIImpactFeedbackGenerator(style: .light)
    private let containerView = UIView()
    private let hintValueLabel = HolkRoundBackgroundLabel()
    private let hintLabel = UILabel()
    private let reminderValueLabel = HolkRoundBackgroundLabel()
    private let reminderLabel = UILabel()
    private let subInsuranceIconView = UIImageView()
    private let ringChart = HolkRingChart()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        let scaleTransform = highlighted ? CGAffineTransform(scaleX: 0.95, y: 0.95) : .identity
        let animator = UIViewPropertyAnimator(duration: 0.1, curve: .easeOut) {
            self.transform = scaleTransform
        }
        animator.startAnimation()

        if highlighted {
            lightFeedbackGenerator.impactOccurred()
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setup()
    }

    func configure(with insuranceSegment: Insurance.Segment) {
        tintColor = Color.color(insuranceSegment)
        titleLabel.text = insuranceSegment.kind.rawValue
        descriptionLabel.text = insuranceSegment.description

        ringChart.reloadSegments()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var tintColor: UIColor! {
        didSet {
            subInsuranceIconView.tintColor = tintColor ?? Color.mainHighlightColor
        }
    }

    private func setup() {
        selectionStyle = .none
        
        backgroundColor = .clear
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.15
        layer.cornerCurve = .continuous

        // TODO: Update this
        hintValueLabel.text = "3"
        let hintImageAttachment = NSTextAttachment()
        hintImageAttachment.image = UIImage(systemName: "bell")
        hintLabel.attributedText = NSAttributedString(attachment: hintImageAttachment)
        reminderValueLabel.text = "2"
        let reminderImageAttachment = NSTextAttachment()
        reminderImageAttachment.image = UIImage(systemName: "exclamationmark.triangle")
        reminderLabel.attributedText = NSAttributedString(attachment: reminderImageAttachment)
        subInsuranceIconView.image = UIImage(systemName: "paperplane")?.withRenderingMode(.alwaysTemplate)

        contentView.backgroundColor = .clear
        containerView.backgroundColor = Color.secondaryBackgroundColor
        containerView.layer.cornerRadius = 16
        containerView.layer.cornerCurve = .continuous
        containerView.translatesAutoresizingMaskIntoConstraints = false

        hintValueLabel.font = Font.regular(.label)
        hintValueLabel.backgroundColor = Color.mainBackgroundColor
        hintValueLabel.textColor = Color.mainForegroundColor
        hintValueLabel.textAlignment = .center
        hintValueLabel.translatesAutoresizingMaskIntoConstraints = false

        hintLabel.font = Font.regular(.description)
        hintLabel.textColor = Color.mainForegroundColor
        hintLabel.numberOfLines = 0
        hintLabel.textAlignment = .center
        hintLabel.translatesAutoresizingMaskIntoConstraints = false

        reminderValueLabel.font = Font.regular(.label)
        reminderValueLabel.backgroundColor = Color.mainBackgroundColor
        reminderValueLabel.textColor = Color.warningColor
        reminderValueLabel.textAlignment = .center
        reminderValueLabel.translatesAutoresizingMaskIntoConstraints = false

        reminderLabel.font = Font.regular(.description)
        reminderLabel.textColor = Color.mainForegroundColor
        reminderLabel.numberOfLines = 0
        reminderLabel.textAlignment = .center
        reminderLabel.translatesAutoresizingMaskIntoConstraints = false

        ringChart.dataSource = self
        ringChart.translatesAutoresizingMaskIntoConstraints = false

        subInsuranceIconView.tintColor = tintColor ?? Color.mainHighlightColor
        subInsuranceIconView.translatesAutoresizingMaskIntoConstraints = false

        titleLabel.numberOfLines = 0
        titleLabel.textColor = Color.mainForegroundColor
        titleLabel.font = Font.semibold(.title)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.numberOfLines = 0
        descriptionLabel.font = Font.regular(.description)
        descriptionLabel.textColor = Color.mainForegroundColor
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false

        setupLayout()
    }

    private func setupLayout() {
        contentView.addSubview(containerView)

        containerView.addSubview(ringChart)
        containerView.addSubview(hintValueLabel)
        containerView.addSubview(hintLabel)
        containerView.addSubview(reminderValueLabel)
        containerView.addSubview(reminderLabel)

        containerView.addSubview(subInsuranceIconView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(descriptionLabel)

        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),

            ringChart.widthAnchor.constraint(equalToConstant: 60),
            ringChart.heightAnchor.constraint(equalTo: ringChart.widthAnchor),
            ringChart.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 24),
            ringChart.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),

            titleLabel.topAnchor.constraint(equalTo: subInsuranceIconView.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: subInsuranceIconView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: ringChart.trailingAnchor),

            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.lastBaselineAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(lessThanOrEqualTo: hintValueLabel.leadingAnchor, constant: -8),
            descriptionLabel.trailingAnchor.constraint(lessThanOrEqualTo: reminderValueLabel.leadingAnchor, constant: -8),
            descriptionLabel.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor, constant: -8),

            hintValueLabel.topAnchor.constraint(equalTo: descriptionLabel.topAnchor),
            hintValueLabel.centerYAnchor.constraint(equalTo: hintLabel.centerYAnchor),
            hintValueLabel.trailingAnchor.constraint(equalTo: hintLabel.leadingAnchor, constant: -8),

            hintLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),
            hintLabel.centerXAnchor.constraint(equalTo: reminderLabel.centerXAnchor),

            reminderValueLabel.topAnchor.constraint(equalTo: hintValueLabel.bottomAnchor, constant: 4),
            reminderValueLabel.centerYAnchor.constraint(equalTo: reminderLabel.centerYAnchor),
            reminderValueLabel.trailingAnchor.constraint(equalTo: reminderLabel.leadingAnchor, constant: -8),
            reminderValueLabel.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor, constant: -8),

            subInsuranceIconView.topAnchor.constraint(equalTo: ringChart.topAnchor),
            subInsuranceIconView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
            subInsuranceIconView.widthAnchor.constraint(equalTo: subInsuranceIconView.heightAnchor),
            subInsuranceIconView.bottomAnchor.constraint(equalTo: ringChart.bottomAnchor),
        ])
    }
}

extension InsuranceDetailTableViewCell: HolkRingChartDataSource {
    func numberOfSegments(_ ringChart: HolkRingChart) -> Int {
        return 6
    }

    func ringChart(_ ringChart: HolkRingChart, sizeForSegmentAt index: Int) -> CGFloat {
        return 1 / CGFloat(numberOfSegments(ringChart))
    }

    func ringChart(_ ringChart: HolkRingChart, ringChartWidthAt index: Int) -> CGFloat? {
        return 8
    }

    func ringChart(_ ringChart: HolkRingChart, colorForSegmentAt index: Int) -> UIColor? {
        if index == 0 {
            return tintColor ?? Color.mainHighlightColor
        } else {
            return Color.placeHolderColor
        }
    }
}
