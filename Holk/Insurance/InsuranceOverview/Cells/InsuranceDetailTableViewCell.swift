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
    private let ringChart = HolkRingChart()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let labelsStackView = UIStackView()

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

    private func setup() {
        selectionStyle = .none
        
        backgroundColor = .clear
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.15
        layer.cornerCurve = .continuous

        contentView.backgroundColor = .clear
        containerView.backgroundColor = Color.mainBackgroundColor
        containerView.layer.cornerRadius = 16
        containerView.layer.cornerCurve = .continuous
        containerView.translatesAutoresizingMaskIntoConstraints = false

        ringChart.dataSource = self
        ringChart.translatesAutoresizingMaskIntoConstraints = false

        titleLabel.text = "Lösöre"
        titleLabel.textColor = Color.mainForegroundColor
        titleLabel.font = Font.semibold(.cellTitle)
        descriptionLabel.text = "Din ersättning vid tex brand eller stöld"
        descriptionLabel.font = Font.regular(.body)
        descriptionLabel.textColor = Color.mainForegroundColor
        labelsStackView.translatesAutoresizingMaskIntoConstraints = false

        setupLayout()
    }

    private func setupLayout() {
        contentView.addSubview(containerView)
        containerView.addSubview(ringChart)
        containerView.addSubview(labelsStackView)
        labelsStackView.axis = .vertical
        labelsStackView.addArrangedSubview(titleLabel)
        labelsStackView.addArrangedSubview(descriptionLabel)

        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),

            ringChart.widthAnchor.constraint(equalToConstant: 60),
            ringChart.heightAnchor.constraint(equalTo: ringChart.widthAnchor),
            ringChart.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8),
            ringChart.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),

            labelsStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
            labelsStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24),
            labelsStackView.topAnchor.constraint(equalTo: ringChart.bottomAnchor, constant: 8),
            labelsStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -8),
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
        if index == 0 {
            return 8
        } else {
            return 4
        }
    }

    func ringChart(_ ringChart: HolkRingChart, colorForSegmentAt index: Int) -> UIColor? {
        if index == 0 {
            return tintColor ?? Color.mainHighlightColor
        } else {
            return Color.placeHolderColor
        }
    }
}
