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
    private let insurancePartsLabel = UILabel()
    private let insuranceTextLabel = UILabel()
    private let labelStackView = UIStackView()
    private let hintStackView = UIStackView()
    private let hintValueLabel = UILabel()
    private let hintLabel = UILabel()
    private let ideaStackView = UIStackView()
    private let ideaValueLabel = UILabel()
    private let ideaLabel = UILabel()
    private let ringChart = HolkRingChart()
    
    private let lightFeedbackGenerator = UIImpactFeedbackGenerator(style: .light)

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear

        // TODO: remove this
        titleLabel.text = "insurance.insuranceType"
        subtitleLabel.text = "insurance.insuranceProvider"
        hintValueLabel.text = "3"
        hintLabel.text = "Tänk på"
        ideaValueLabel.text = "2"
        ideaLabel.text = "Luckor"

        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.1
        layer.cornerRadius = 6
        layer.cornerCurve = .continuous

        containerView.backgroundColor = Color.mainBackgroundColor
        containerView.translatesAutoresizingMaskIntoConstraints = false

        titleLabel.font = Font.semibold(.title)
        titleLabel.textColor = Color.mainForegroundColor
        titleLabel.numberOfLines = 0
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        subtitleLabel.font = Font.regular(.subtitle)
        subtitleLabel.textColor = Color.mainForegroundColor
        subtitleLabel.numberOfLines = 0
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false

        insuranceTextLabel.font = Font.regular(.subtitle)
        insuranceTextLabel.textColor = Color.mainForegroundColor
        insuranceTextLabel.numberOfLines = 0
        insuranceTextLabel.textAlignment = .center
        insuranceTextLabel.translatesAutoresizingMaskIntoConstraints = false

        insurancePartsLabel.font = Font.semibold(.title)
        insurancePartsLabel.textColor = Color.mainForegroundColor
        insurancePartsLabel.numberOfLines = 0
        insurancePartsLabel.textAlignment = .center
        insurancePartsLabel.translatesAutoresizingMaskIntoConstraints = false

        labelStackView.spacing = 16
        labelStackView.translatesAutoresizingMaskIntoConstraints = false
        hintStackView.axis = .vertical
        hintStackView.translatesAutoresizingMaskIntoConstraints = false
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
        ideaValueLabel.textColor = Color.mainForegroundColor
        ideaValueLabel.numberOfLines = 0
        ideaValueLabel.textAlignment = .center
        ideaValueLabel.translatesAutoresizingMaskIntoConstraints = false

        ideaLabel.font = Font.regular(.description)
        ideaLabel.textColor = Color.mainForegroundColor
        ideaLabel.numberOfLines = 0
        ideaLabel.textAlignment = .center
        ideaLabel.translatesAutoresizingMaskIntoConstraints = false

        ringChart.dataSource = self

        ringChart.translatesAutoresizingMaskIntoConstraints = false
    }

    private func setupConstraints() {
        contentView.addSubview(containerView)

        containerView.addSubview(titleLabel)
        containerView.addSubview(subtitleLabel)
        containerView.addSubview(ringChart)
        //        containerView.addSubview(insuranceTextLabel)
        //        containerView.addSubview(insurancePartsLabel)

        containerView.addSubview(labelStackView)
        labelStackView.addArrangedSubview(hintStackView)
        labelStackView.addArrangedSubview(ideaStackView)

        hintStackView.addArrangedSubview(hintValueLabel)
        hintStackView.addArrangedSubview(hintLabel)
        ideaStackView.addArrangedSubview(ideaValueLabel)
        ideaStackView.addArrangedSubview(ideaLabel)


        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor
                , constant: -16),

            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24),
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),

            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.lastBaselineAnchor, constant: 8),
            subtitleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
            subtitleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),

            ringChart.topAnchor.constraint(equalTo: subtitleLabel.lastBaselineAnchor, constant: 16),
            ringChart.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
            ringChart.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24),
            ringChart.heightAnchor.constraint(equalTo: ringChart.widthAnchor),

            labelStackView.topAnchor.constraint(equalTo: ringChart.bottomAnchor, constant: 16),
            labelStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
            labelStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -24)
        ])
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

extension InsuranceTableViewCell: HolkRingChartDataSource {
    func ringChart(_ pieChart: HolkRingChart, sizeForSegmentAt index: Int) -> CGFloat {
        return 1 / CGFloat(insurance?.insuranceParts.count ?? 1)
    }

    func numberOfSegments(_ pieChart: HolkRingChart) -> Int {
        return insurance?.insuranceParts.count ?? 1
    }

    func ringChart(_ pieChart: HolkRingChart, colorForSegmentAt index: Int) -> UIColor? {
        return .red
    }
}
