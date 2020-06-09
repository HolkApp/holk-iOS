//
//  InsuranceTableViewCell.swift
//  Holk
//
//  Created by 张梦皓 on 2019-06-11.
//  Copyright © 2019 Holk. All rights reserved.
//

import UIKit

final class HomeInsurnaceCollectionViewCell: UICollectionViewCell {
    // MARK: - Public variables
    var insurance: Insurance?
    let containerView = UIView()
    let ringChart = HolkRingChart()

    // MARK: - Private variables
    private let titleLabel = UILabel()
    private let insuranceSubNumberLabel = UILabel()
    private let insuranceTextLabel = UILabel()
    private let insuranceImageView = UIImageView()
    private let chevronView = UIImageView()

    private let ringChartLabelsStackView = UIStackView()

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

//            if isHighlighted {
//                lightFeedbackGenerator.impactOccurred()
//            }
        }
    }

    func configure(_ insurance: Insurance) {
        self.insurance = insurance

        titleLabel.text = "Dina skydd"
        insuranceSubNumberLabel.text = String(insurance.segments.count)
        insuranceTextLabel.text = "Sub insurances"
        insuranceImageView.image = UIImage(named: "Folksam")

        ringChart.reloadSegments()
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
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        insuranceSubNumberLabel.font = Font.semiBold(.header)
        insuranceSubNumberLabel.textColor = Color.mainForegroundColor
        insuranceSubNumberLabel.numberOfLines = 0
        insuranceSubNumberLabel.textAlignment = .center
        insuranceSubNumberLabel.translatesAutoresizingMaskIntoConstraints = false

        insuranceTextLabel.font = Font.regular(.subtitle)
        insuranceTextLabel.textColor = Color.mainForegroundColor
        insuranceTextLabel.numberOfLines = 0
        insuranceTextLabel.textAlignment = .center
        insuranceTextLabel.translatesAutoresizingMaskIntoConstraints = false

        ringChartLabelsStackView.axis = .vertical
        ringChartLabelsStackView.spacing = 20
        ringChartLabelsStackView.isBaselineRelativeArrangement = true
        ringChartLabelsStackView.backgroundColor = .green
        ringChartLabelsStackView.translatesAutoresizingMaskIntoConstraints = false

        insuranceImageView.contentMode = .scaleAspectFit
        insuranceImageView.translatesAutoresizingMaskIntoConstraints = false

        chevronView.image = UIImage(systemName: "chevron.right")
        chevronView.tintColor = Color.mainForegroundColor
        chevronView.translatesAutoresizingMaskIntoConstraints = false

        ringChart.dataSource = self
        ringChart.translatesAutoresizingMaskIntoConstraints = false
    }

    private func setupLayout() {
        contentView.addSubview(containerView)

        containerView.addSubview(titleLabel)
        containerView.addSubview(ringChart)
        containerView.addSubview(insuranceImageView)
        containerView.addSubview(chevronView)

        ringChartLabelsStackView.addArrangedSubview(insuranceSubNumberLabel)
        ringChartLabelsStackView.addArrangedSubview(insuranceTextLabel)
        ringChart.addSubview(ringChartLabelsStackView)
        ringChart.titleView = ringChartLabelsStackView

        let ringChartLeadingConstraint = ringChart.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 36)
        ringChartLeadingConstraint.priority = .defaultHigh
        let ringChartTrailingConstraint = ringChart.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -36)
        ringChartTrailingConstraint.priority = .defaultHigh

        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            containerView.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor),

            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24),

            ringChart.widthAnchor.constraint(lessThanOrEqualToConstant: 224),
            ringChart.heightAnchor.constraint(equalTo: ringChart.widthAnchor),
            ringChart.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 48),
            ringChartLeadingConstraint,
            ringChartTrailingConstraint,
            ringChart.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),

            insuranceImageView.topAnchor.constraint(equalTo: ringChart.bottomAnchor, constant: 36),
            insuranceImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            insuranceImageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16),

            chevronView.widthAnchor.constraint(equalToConstant: 16),
            chevronView.heightAnchor.constraint(equalToConstant: 24),
            chevronView.bottomAnchor.constraint(equalTo: insuranceImageView.bottomAnchor),
            chevronView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8)
        ])
    }
}

extension HomeInsurnaceCollectionViewCell: HolkRingChartDataSource {
    private var mockNumberOfSegments: Int {
        return insurance?.segments.count ?? 6
    }

    func numberOfSegments(_ ringChart: HolkRingChart) -> Int {
        return mockNumberOfSegments
    }

    func ringChart(_ ringChart: HolkRingChart, sizeForSegmentAt index: Int) -> CGFloat {
        return 1 / CGFloat(numberOfSegments(ringChart))
    }

    func ringChart(_ ringChart: HolkRingChart, ringChartWidthAt index: Int) -> CGFloat? {
        return 16
    }

    func ringChart(_ ringChart: HolkRingChart, colorForSegmentAt index: Int) -> UIColor? {
        if index == 0 {
            return Color.mainForegroundColor
        } else if index == 1 {
            return Color.mainHighlightColor
        } else if index == 2 {
            return Color.successColor
        } else if index == 3 {
            return .green
        } else if index == 4 {
            return .red
        } else {
            return .cyan
        }
    }

    func ringChart(_ ringChart: HolkRingChart, iconForSegmentAt index: Int) -> UIImage? {
        if index == 0 {
            return UIImage(named: "Heart")?.withRenderingMode(.alwaysTemplate)
        } else if index == 1 {
            return UIImage(named: "Plane")?.withRenderingMode(.alwaysTemplate)
        } else if index == 2{
            return UIImage(named: "Shoe")?.withRenderingMode(.alwaysTemplate)
        } else {
            return UIImage(named: "Car")?.withRenderingMode(.alwaysTemplate)
        }
    }
}
