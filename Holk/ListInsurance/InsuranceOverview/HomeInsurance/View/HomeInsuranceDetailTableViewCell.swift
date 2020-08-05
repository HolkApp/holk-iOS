//
//  HomeInsuranceDetailTableViewCell.swift
//  Holk
//
//  Created by 张梦皓 on 2020-03-28.
//  Copyright © 2020 Holk. All rights reserved.
//

import UIKit

final class HomeInsuranceDetailTableViewCell: UITableViewCell {
    // MARK: - Private variables
    private let lightFeedbackGenerator = UIImpactFeedbackGenerator(style: .light)
    private let containerView = UIView()
    private let reminderValueLabel = HolkRoundBackgroundLabel()
    private let reminderImageView = UIImageView()
    private let thinkOfValueLabel = HolkRoundBackgroundLabel()
    private let thinkOfImageView = UIImageView()
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

    func configure(with subInsurance: Insurance.SubInsurance) {
        tintColor = Color.tintColor(subInsurance)
        subInsuranceIconView.image = UIImage(subInsurance: subInsurance)?.withRenderingMode(.alwaysTemplate)
        //insuranceSegment.kind.rawValue
        titleLabel.setText(subInsurance.header, with: .header5)
        descriptionLabel.setText(subInsurance.body, with: .body1)

        ringChart.reloadSegments()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var tintColor: UIColor! {
        didSet {
            subInsuranceIconView.tintColor = tintColor ?? Color.mainHighlight
        }
    }

    func configure(_ insurance: Insurance?) {
        // TODO: Update this
        reminderValueLabel.text = "3"
        reminderImageView.image = UIImage(systemName: "bell")
        thinkOfValueLabel.text = "2"
        thinkOfImageView.image = UIImage(systemName: "exclamationmark.triangle")
    }

    private func setup() {
        selectionStyle = .none
        
        backgroundColor = .clear
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.15
        layer.shadowRadius = 30

        contentView.backgroundColor = .clear
        containerView.backgroundColor = Color.secondaryBackground
        containerView.layer.cornerRadius = 16
        containerView.layer.cornerCurve = .continuous
        containerView.translatesAutoresizingMaskIntoConstraints = false

        reminderValueLabel.font = Font.medium(.label)
        reminderValueLabel.backgroundColor = Color.mainBackground
        reminderValueLabel.textColor = Color.mainForeground
        reminderValueLabel.textAlignment = .center
        reminderValueLabel.translatesAutoresizingMaskIntoConstraints = false

        reminderImageView.tintColor = Color.mainForeground.withAlphaComponent(0.35)
        reminderImageView.translatesAutoresizingMaskIntoConstraints = false

        thinkOfValueLabel.font = Font.medium(.label)
        thinkOfValueLabel.backgroundColor = Color.mainBackground
        thinkOfValueLabel.textColor = Color.warning
        thinkOfValueLabel.textAlignment = .center
        thinkOfValueLabel.translatesAutoresizingMaskIntoConstraints = false

        thinkOfImageView.tintColor = Color.mainForeground.withAlphaComponent(0.35)
        thinkOfImageView.translatesAutoresizingMaskIntoConstraints = false

        ringChart.dataSource = self
        ringChart.translatesAutoresizingMaskIntoConstraints = false

        subInsuranceIconView.tintColor = tintColor ?? Color.mainHighlight
        subInsuranceIconView.contentMode = .scaleAspectFit
        subInsuranceIconView.translatesAutoresizingMaskIntoConstraints = false

        titleLabel.numberOfLines = 0
        titleLabel.textColor = Color.mainForeground
        titleLabel.setStyleGuide(.header5)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textColor = Color.mainForeground.withAlphaComponent(0.5)
        descriptionLabel.setStyleGuide(.body1)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false

        setupLayout()
    }

    private func setupLayout() {
        contentView.addSubview(containerView)

        containerView.addSubview(ringChart)
        containerView.addSubview(reminderValueLabel)
        containerView.addSubview(reminderImageView)
        containerView.addSubview(thinkOfValueLabel)
        containerView.addSubview(thinkOfImageView)
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
            ringChart.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            ringChart.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),

            titleLabel.topAnchor.constraint(equalTo: subInsuranceIconView.bottomAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: subInsuranceIconView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: ringChart.trailingAnchor),

            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.lastBaselineAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(lessThanOrEqualTo: reminderValueLabel.leadingAnchor, constant: -40),
            descriptionLabel.trailingAnchor.constraint(lessThanOrEqualTo: thinkOfValueLabel.leadingAnchor, constant: -40),
            descriptionLabel.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor, constant: -10),

            reminderValueLabel.topAnchor.constraint(equalTo: descriptionLabel.topAnchor),
            reminderValueLabel.centerYAnchor.constraint(equalTo: reminderImageView.centerYAnchor),
            reminderValueLabel.trailingAnchor.constraint(equalTo: reminderImageView.leadingAnchor, constant: -8),

            reminderImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            reminderImageView.centerXAnchor.constraint(equalTo: thinkOfImageView.centerXAnchor),
            reminderImageView.widthAnchor.constraint(equalToConstant: 24),
            reminderImageView.heightAnchor.constraint(equalToConstant: 24),

            thinkOfValueLabel.topAnchor.constraint(equalTo: reminderValueLabel.bottomAnchor, constant: 8),
            thinkOfValueLabel.centerYAnchor.constraint(equalTo: thinkOfImageView.centerYAnchor),
            thinkOfValueLabel.trailingAnchor.constraint(equalTo: thinkOfImageView.leadingAnchor, constant: -8),
            thinkOfValueLabel.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor, constant: -10),

            thinkOfImageView.widthAnchor.constraint(equalToConstant: 24),
            thinkOfImageView.heightAnchor.constraint(equalToConstant: 24),

            subInsuranceIconView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
            subInsuranceIconView.widthAnchor.constraint(equalToConstant: 58),
            subInsuranceIconView.heightAnchor.constraint(equalToConstant: 42),
            subInsuranceIconView.bottomAnchor.constraint(equalTo: ringChart.bottomAnchor),
        ])
    }
}

extension HomeInsuranceDetailTableViewCell: HolkRingChartDataSource {
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
            return tintColor ?? Color.mainHighlight
        } else {
            return Color.placeholder
        }
    }
}
