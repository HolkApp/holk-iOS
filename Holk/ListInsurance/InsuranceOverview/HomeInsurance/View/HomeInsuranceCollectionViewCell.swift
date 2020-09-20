//
//  InsuranceTableViewCell.swift
//  Holk
//
//  Created by 张梦皓 on 2019-06-11.
//  Copyright © 2019 Holk. All rights reserved.
//

import UIKit

final class HomeInsuranceCollectionViewCell: UICollectionViewCell {
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

        titleLabel.set(text: "Dina skydd", with: .header6)
        insuranceSubNumberLabel.set(text: "\(insurance.subInsurances.count)", with: .largeNumber)
        insuranceTextLabel.set(text: "Skydd", with: .subHeader2)
        
        if let provider = provider {
            UIImage.makeImage(with: provider.logoUrl) { [weak self] image in
                self?.insuranceImageView.image = image
            }
        }

        ringChart.reloadSegments()
    }

    private func setup() {
        backgroundColor = .clear
        contentView.layoutMargins = .init(top: 6, left: 6, bottom: 6, right: 6)

        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.05
        layer.shadowRadius = 30

        containerView.backgroundColor = Color.insuranceBackground
        containerView.layer.cornerRadius = 16
        containerView.layer.cornerCurve = .continuous
        containerView.translatesAutoresizingMaskIntoConstraints = false

        titleLabel.setStyleGuide(.header6)
        titleLabel.textColor = Color.mainForeground
        titleLabel.numberOfLines = 0
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        insuranceSubNumberLabel.setStyleGuide(.largeNumber)
        insuranceSubNumberLabel.textColor = Color.mainForeground
        insuranceSubNumberLabel.numberOfLines = 0
        insuranceSubNumberLabel.textAlignment = .center
        insuranceSubNumberLabel.translatesAutoresizingMaskIntoConstraints = false

        insuranceTextLabel.textColor = Color.mainForeground
        insuranceTextLabel.numberOfLines = 0
        insuranceTextLabel.textAlignment = .center
        insuranceTextLabel.translatesAutoresizingMaskIntoConstraints = false

        ringChartLabelsStackView.axis = .vertical
        ringChartLabelsStackView.spacing = 24
        ringChartLabelsStackView.isBaselineRelativeArrangement = true
        ringChartLabelsStackView.backgroundColor = .clear
        ringChartLabelsStackView.translatesAutoresizingMaskIntoConstraints = false

        insuranceImageView.contentMode = .scaleAspectFit
        insuranceImageView.translatesAutoresizingMaskIntoConstraints = false

        chevronView.image = UIImage(systemName: "chevron.right")
        chevronView.tintColor = Color.mainForeground
        chevronView.translatesAutoresizingMaskIntoConstraints = false

        ringChart.dataSource = self
        ringChart.translatesAutoresizingMaskIntoConstraints = false

        setupLayout()
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
            insuranceImageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -8),
            insuranceImageView.widthAnchor.constraint(equalToConstant: 120),
            insuranceImageView.heightAnchor.constraint(equalToConstant: 48),

            chevronView.widthAnchor.constraint(equalToConstant: 16),
            chevronView.heightAnchor.constraint(equalToConstant: 24),
            chevronView.centerYAnchor.constraint(equalTo: insuranceImageView.centerYAnchor),
            chevronView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16)
        ])
    }
}

extension HomeInsuranceCollectionViewCell: HolkRingChartDataSource {
    private var mockNumberOfSegments: Int {
        return insurance?.subInsurances.count ?? 6
    }

    func numberOfSegments(_ ringChart: HolkRingChart) -> Int {
        return mockNumberOfSegments
    }

    func ringChart(_ ringChart: HolkRingChart, sizeForSegmentAt index: Int) -> CGFloat {
        return 1 / CGFloat(numberOfSegments(ringChart))
    }

    func ringChart(_ ringChart: HolkRingChart, ringChartWidthAt index: Int) -> CGFloat? {
        return 4
    }

    func ringChart(_ ringChart: HolkRingChart, colorForSegmentAt index: Int) -> UIColor? {
        if index == 0 {
            return Color.mainForeground
        } else if index == 1 {
            return Color.mainHighlight
        } else if index == 2 {
            return Color.success
        } else if index == 3 {
            return .green
        } else if index == 4 {
            return .red
        } else {
            return .cyan
        }
    }

    func ringChart(_ ringChart: HolkRingChart, iconForSegmentAt index: Int) -> UIImage? {
        let subInsurance = insurance?.subInsurances[index]
        return subInsurance.flatMap(
            UIImage.init(subInsurance: )
        )?.withRenderingMode(.alwaysTemplate)
    }
}
