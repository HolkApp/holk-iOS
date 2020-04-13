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
    private let hintImageView = UIImageView()
    private let reminderValueLabel = HolkRoundBackgroundLabel()
    private let reminderImageView = UIImageView()
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
        subInsuranceIconView.image = UIImage(insuranceSegment: insuranceSegment)?.withRenderingMode(.alwaysTemplate)
        titleLabel.text = "Subinsurance title" //insuranceSegment.kind.rawValue
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
        hintImageView.image = UIImage(systemName: "bell")
        reminderValueLabel.text = "2"
        reminderImageView.image = UIImage(systemName: "exclamationmark.triangle")

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

        hintImageView.tintColor = Color.mainForegroundColor.withAlphaComponent(0.35)
        hintImageView.translatesAutoresizingMaskIntoConstraints = false

        reminderValueLabel.font = Font.regular(.label)
        reminderValueLabel.backgroundColor = Color.mainBackgroundColor
        reminderValueLabel.textColor = Color.warningColor
        reminderValueLabel.textAlignment = .center
        reminderValueLabel.translatesAutoresizingMaskIntoConstraints = false

        reminderImageView.tintColor = Color.mainForegroundColor.withAlphaComponent(0.35)
        reminderImageView.translatesAutoresizingMaskIntoConstraints = false

        ringChart.dataSource = self
        ringChart.translatesAutoresizingMaskIntoConstraints = false

        subInsuranceIconView.tintColor = tintColor ?? Color.mainHighlightColor
        subInsuranceIconView.contentMode = .scaleAspectFit
        subInsuranceIconView.translatesAutoresizingMaskIntoConstraints = false

        titleLabel.numberOfLines = 0
        titleLabel.textColor = Color.mainForegroundColor
        titleLabel.setStyleGuide(.header5)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textColor = Color.mainForegroundColor.withAlphaComponent(0.5)
        descriptionLabel.setStyleGuide(.body1)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false

        setupLayout()
    }

    private func setupLayout() {
        contentView.addSubview(containerView)

        containerView.addSubview(ringChart)
        containerView.addSubview(hintValueLabel)
        containerView.addSubview(hintImageView)
        containerView.addSubview(reminderValueLabel)
        containerView.addSubview(reminderImageView)

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
            ringChart.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            ringChart.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),

            titleLabel.topAnchor.constraint(equalTo: subInsuranceIconView.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: subInsuranceIconView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: ringChart.trailingAnchor),

            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.lastBaselineAnchor, constant: 6),
            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(lessThanOrEqualTo: hintValueLabel.leadingAnchor, constant: -40),
            descriptionLabel.trailingAnchor.constraint(lessThanOrEqualTo: reminderValueLabel.leadingAnchor, constant: -40),
            descriptionLabel.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor, constant: -10),

            hintValueLabel.topAnchor.constraint(equalTo: descriptionLabel.topAnchor),
            hintValueLabel.centerYAnchor.constraint(equalTo: hintImageView.centerYAnchor),
            hintValueLabel.trailingAnchor.constraint(equalTo: hintImageView.leadingAnchor, constant: -8),

            hintImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            hintImageView.centerXAnchor.constraint(equalTo: reminderImageView.centerXAnchor),
            hintImageView.widthAnchor.constraint(equalToConstant: 24),
            hintImageView.heightAnchor.constraint(equalToConstant: 24),

            reminderValueLabel.topAnchor.constraint(equalTo: hintValueLabel.bottomAnchor, constant: 12),
            reminderValueLabel.centerYAnchor.constraint(equalTo: reminderImageView.centerYAnchor),
            reminderValueLabel.trailingAnchor.constraint(equalTo: reminderImageView.leadingAnchor, constant: -8),
            reminderValueLabel.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor, constant: -10),

            reminderImageView.widthAnchor.constraint(equalToConstant: 24),
            reminderImageView.heightAnchor.constraint(equalToConstant: 24),

            subInsuranceIconView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
            subInsuranceIconView.widthAnchor.constraint(equalToConstant: 54),
            subInsuranceIconView.heightAnchor.constraint(equalToConstant: 54),
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
