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
        titleLabel.font = Font.semibold(.title)
        titleLabel.textColor = Color.mainForegroundColor
        addressLabel.font = Font.regular(.subtitle)
        addressLabel.textColor = Color.mainForegroundColor
        
        hintValueLabel.font = Font.semibold(.header)
        hintValueLabel.textColor = Color.mainForegroundColor
        hintValueLabel.suffixColor = Color.mainAlertColor
        hintValueLabel.suffixFont = Font.fontAwesome(style: .light, size: .subtitle)
        hintLabel.font = Font.regular(.description)
        hintLabel.textColor = Color.mainForegroundColor
        
        ideaValueLabel.font = Font.semibold(.header)
        ideaValueLabel.textColor = Color.mainForegroundColor
        ideaValueLabel.suffixColor = Color.mainWarningColor
        ideaValueLabel.suffixFont = Font.fontAwesome(style: .light, size: .subtitle)
        ideaLabel.font = Font.regular(.description)
        ideaLabel.textColor = Color.mainForegroundColor
        
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        containerView.backgroundColor = Color.secondaryBackgroundColor
        
        selectionStyle = .none
        containerView.layer.cornerRadius = 6
        if #available(iOS 13.0, *) {
            containerView.layer.cornerCurve = .continuous
        }
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        let scaleTransform = highlighted ? CGAffineTransform(scaleX: 0.95, y: 0.95) : .identity
        let animator = UIViewPropertyAnimator(duration: 0.1, curve: .easeOut) {
            self.transform = scaleTransform
        }
        animator.startAnimation()
        
        lightFeedbackGenerator.impactOccurred()
    }
    
    func configureCell() {
        // TODO: Create a model
        titleLabel.text = "Hemförsäkring"
        addressLabel.text = "Sveavägen 140, 1 trp"
        hintValueLabel.text = "3"
        hintValueLabel.suffixText = String.fontAwesomeIcon(name: .lightbulbOn)
        hintLabel.text = "Tänk på"
        ideaValueLabel.text = "2"
        ideaValueLabel.suffixText = String.fontAwesomeIcon(name: .bell)
        ideaLabel.text = "Luckor"
        
        logoImageView.image = UIImage(named: "Folksam")
    }
}
