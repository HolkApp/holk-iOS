//
//  InsuranceTableViewCell.swift
//  Holk
//
//  Created by 张梦皓 on 2019-06-11.
//  Copyright © 2019 Holk. All rights reserved.
//

import UIKit

final class InsuranceCollectionViewCell: UICollectionViewCell {
    // MARK: - IBOutlets
    
    var insurance: Insurance?
    // MARK: - Private variables
    private let containerView = UIView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let insuranceSubNumberLabel = UILabel()
    private let insuranceTextLabel = UILabel()
    private let labelStackView = UIStackView()
    private let hintStackView = UIStackView()
    private let hintValueLabel = UILabel()
    private let hintLabel = UILabel()
    private let ideaStackView = UIStackView()
    private let ideaValueLabel = UILabel()
    private let ideaLabel = UILabel()
    private let insuranceImageView = UIImageView()
    private let ringChart = HolkRingChart()
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
            let animator = UIViewPropertyAnimator(duration: 0.1, curve: .easeOut) {
                self.transform = scaleTransform
            }
            animator.startAnimation()

            if isHighlighted {
                lightFeedbackGenerator.impactOccurred()
            }
        }
    }

    private func setup() {
        backgroundColor = .clear
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.15
        layer.cornerCurve = .continuous
        
        contentView.backgroundColor = .clear

        // TODO: remove this
        titleLabel.text = "Home insurace"
        subtitleLabel.text = "Folksam bas"
        insuranceSubNumberLabel.text = "4"
        insuranceTextLabel.text = "insurance"
        hintValueLabel.text = "3"
        hintLabel.text = "Tänk på"
        ideaValueLabel.text = "2"
        ideaLabel.text = "Luckor"
        insuranceImageView.image = UIImage(named: "Folksam")

        containerView.backgroundColor = Color.secondaryBackgroundColor
        containerView.layer.cornerRadius = 16
        containerView.layer.cornerCurve = .continuous
        containerView.translatesAutoresizingMaskIntoConstraints = false

        titleLabel.font = Font.extraBold(.title)
        titleLabel.textColor = Color.mainForegroundColor
        titleLabel.numberOfLines = 0
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        subtitleLabel.font = Font.regular(.subtitle)
        subtitleLabel.textColor = Color.mainForegroundColor
        subtitleLabel.numberOfLines = 0
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false

        insuranceSubNumberLabel.font = Font.semibold(.header)
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

        labelStackView.spacing = 16
        labelStackView.translatesAutoresizingMaskIntoConstraints = false
        hintStackView.spacing = 16
        hintStackView.isBaselineRelativeArrangement = true
        hintStackView.axis = .vertical
        hintStackView.translatesAutoresizingMaskIntoConstraints = false
        ideaStackView.spacing = 16
        ideaStackView.isBaselineRelativeArrangement = true
        ideaStackView.axis = .vertical
        ideaStackView.translatesAutoresizingMaskIntoConstraints = false

        hintValueLabel.font = Font.semibold(.header)
        hintValueLabel.textColor = Color.mainForegroundColor
        hintValueLabel.numberOfLines = 0
        hintValueLabel.textAlignment = .center
        hintValueLabel.translatesAutoresizingMaskIntoConstraints = false

        hintLabel.font = Font.regular(.description)
        hintLabel.textColor = Color.mainForegroundColor
        hintLabel.numberOfLines = 0
        hintLabel.textAlignment = .center
        hintLabel.translatesAutoresizingMaskIntoConstraints = false

        ideaValueLabel.font = Font.semibold(.header)
        ideaValueLabel.textColor = Color.warningColor
        ideaValueLabel.numberOfLines = 0
        ideaValueLabel.textAlignment = .center
        ideaValueLabel.translatesAutoresizingMaskIntoConstraints = false

        ideaLabel.font = Font.regular(.description)
        ideaLabel.textColor = Color.mainForegroundColor
        ideaLabel.numberOfLines = 0
        ideaLabel.textAlignment = .center
        ideaLabel.translatesAutoresizingMaskIntoConstraints = false

        insuranceImageView.translatesAutoresizingMaskIntoConstraints = false

        ringChart.dataSource = self
        ringChart.translatesAutoresizingMaskIntoConstraints = false
    }

    private func setupLayout() {
        contentView.addSubview(containerView)

        containerView.addSubview(titleLabel)
        containerView.addSubview(subtitleLabel)
        containerView.addSubview(ringChart)
        containerView.addSubview(insuranceImageView)

        ringChartLabelsStackView.addArrangedSubview(insuranceSubNumberLabel)
        ringChartLabelsStackView.addArrangedSubview(insuranceTextLabel)
        ringChart.addSubview(ringChartLabelsStackView)
        ringChartLabelsStackView.backgroundColor = .green
        ringChart.titleView = ringChartLabelsStackView

        containerView.addSubview(labelStackView)
        labelStackView.addArrangedSubview(hintStackView)
        labelStackView.addArrangedSubview(ideaStackView)

        hintStackView.addArrangedSubview(hintValueLabel)
        hintStackView.addArrangedSubview(hintLabel)
        ideaStackView.addArrangedSubview(ideaValueLabel)
        ideaStackView.addArrangedSubview(ideaLabel)

        let containerBottomConstraint = containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        containerBottomConstraint.priority = .defaultHigh

        let ringChartLeadingConstraint = ringChart.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 36)
        ringChartLeadingConstraint.priority = .defaultHigh
        let ringChartTrailingConstraint = ringChart.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -36)
        ringChartTrailingConstraint.priority = .defaultHigh

        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            containerBottomConstraint,

            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24),

            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.lastBaselineAnchor, constant: 8),
            subtitleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
            subtitleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),

            ringChart.widthAnchor.constraint(lessThanOrEqualToConstant: 224),
            ringChart.heightAnchor.constraint(equalTo: ringChart.widthAnchor),
            ringChart.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 48),
            ringChartLeadingConstraint,
            ringChartTrailingConstraint,
            ringChart.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),

            labelStackView.topAnchor.constraint(equalTo: ringChart.bottomAnchor, constant: 48),
            labelStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
            labelStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16),

            insuranceImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24),
            insuranceImageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16)
        ])
    }
    
    func configureCell(_ insurance: Insurance) {
        self.insurance = insurance

        titleLabel.text = insurance.insuranceType
        subtitleLabel.text = insurance.insuranceProvider
        hintValueLabel.text = "3"
        hintLabel.text = "Tänk på"
        ideaValueLabel.text = "2"
        ideaLabel.text = "Luckor"
    }
}

extension InsuranceCollectionViewCell: HolkRingChartDataSource {
    private var mockNumberOfSegments: Int {
        return insurance?.insuranceParts.count ?? 4
    }

    func numberOfSegments(_ ringChart: HolkRingChart) -> Int {
        return mockNumberOfSegments
    }

    func ringChart(_ ringChart: HolkRingChart, sizeForSegmentAt index: Int) -> CGFloat {
        return 1 / CGFloat(numberOfSegments(ringChart))
    }

    func ringChart(_ ringChart: HolkRingChart, colorForSegmentAt index: Int) -> UIColor? {
        if index == 0 {
            return .red
        } else if index == 1 {
            return .blue
        } else if index == 2 {
            return .orange
        } else if index == 3 {
            return .green
        } else {
            return .cyan
        }
    }

    func ringChart(_ ringChart: HolkRingChart, iconForSegmentAt index: Int) -> UIImage? {
        if index == 0 {
            return UIImage(systemName: "pencil")?.withRenderingMode(.alwaysTemplate)
        } else if index == 1 {
            return UIImage(systemName: "flame")?.withRenderingMode(.alwaysTemplate)
        } else if index == 2{
            return UIImage(systemName: "person")?.withRenderingMode(.alwaysTemplate)
        } else {
            return UIImage(systemName: "bolt")?.withRenderingMode(.alwaysTemplate)
        }

    }
}
