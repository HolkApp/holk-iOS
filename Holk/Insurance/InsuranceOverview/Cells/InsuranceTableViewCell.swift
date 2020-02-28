//
//  InsuranceTableViewCell.swift
//  Holk
//
//  Created by 张梦皓 on 2019-06-11.
//  Copyright © 2019 Holk. All rights reserved.
//

import UIKit

final class InsuranceTableViewCell: UITableViewCell {
    // MARK: - IBOutlets
    private let containerView = UIView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let insurancePartsLabel = UILabel()
    private let insuranceTextLabel = UILabel()
    private let hintValueLabel = HolkIllustrationLabel()
    private let hintLabel = UILabel()
    private let ideaValueLabel = HolkIllustrationLabel()
    private let ideaLabel = UILabel()
    private let ringChart = HolkRingChart()
    var insurance: Insurance?
    // MARK: - Private variables
    private let lightFeedbackGenerator = UIImpactFeedbackGenerator(style: .light)
    
    override func awakeFromNib() {
        super.awakeFromNib()

        selectionStyle = .none
        backgroundColor = .clear

        contentView.backgroundColor = .clear
        contentView.layer.shadowOffset = CGSize(width: 0, height: 8)
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOpacity = 0.08

        titleLabel.font = Font.semibold(.title)
        titleLabel.textColor = Color.mainForegroundColor
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        subtitleLabel.font = Font.regular(.subtitle)
        subtitleLabel.textColor = Color.mainForegroundColor
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false

        insurancePartsLabel.font = Font.semibold(.title)
        insurancePartsLabel.textColor = Color.mainForegroundColor
        insurancePartsLabel.translatesAutoresizingMaskIntoConstraints = false

        insuranceTextLabel.font = Font.regular(.subtitle)
        insuranceTextLabel.textColor = Color.mainForegroundColor
        insuranceTextLabel.translatesAutoresizingMaskIntoConstraints = false
        
        hintValueLabel.font = Font.semibold(.header)
        hintValueLabel.textColor = Color.mainForegroundColor
        hintValueLabel.suffixColor = Color.mainAlertColor
        hintValueLabel.suffixFont = Font.fontAwesome(style: .light, size: .subtitle)
        hintValueLabel.translatesAutoresizingMaskIntoConstraints = false

        hintLabel.font = Font.regular(.description)
        hintLabel.textColor = Color.mainForegroundColor
        hintLabel.translatesAutoresizingMaskIntoConstraints = false
        
        ideaValueLabel.font = Font.semibold(.header)
        ideaValueLabel.textColor = Color.mainForegroundColor
        ideaValueLabel.suffixColor = Color.mainWarningColor
        ideaValueLabel.suffixFont = Font.fontAwesome(style: .light, size: .subtitle)
        ideaValueLabel.translatesAutoresizingMaskIntoConstraints = false

        ideaLabel.font = Font.regular(.description)
        ideaLabel.textColor = Color.mainForegroundColor
        ideaLabel.translatesAutoresizingMaskIntoConstraints = false

        ringChart.dataSource = self

        ringChart.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(containerView)

        containerView.addSubview(ringChart)

        containerView.layer.cornerRadius = 6
        containerView.layer.cornerCurve = .continuous
        containerView.backgroundColor = Color.secondaryBackgroundColor
    }
    
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
    
    func configureCell(_ insurance: Insurance) {
        // TODO: Create a model
        self.insurance = insurance

        titleLabel.text = insurance.insuranceType
        subtitleLabel.text = insurance.insuranceProvider
        hintValueLabel.text = "3"
        hintValueLabel.suffixText = String.fontAwesomeIcon(name: .lightbulbOn)
        hintLabel.text = "Tänk på"
        ideaValueLabel.text = "2"
        ideaValueLabel.suffixText = String.fontAwesomeIcon(name: .bell)
        ideaLabel.text = "Luckor"
    }
}

extension InsuranceTableViewCell: HolkRingChartDataSource {
    func ringChart(_ pieChart: HolkRingChart, sizeForSegmentAt index: Int) -> CGFloat {
        return CGFloat(insurance?.insuranceParts.count ?? 1)
    }

    func numberOfSegments(_ pieChart: HolkRingChart) -> Int {
        return insurance?.insuranceParts.count ?? 1
    }
}
