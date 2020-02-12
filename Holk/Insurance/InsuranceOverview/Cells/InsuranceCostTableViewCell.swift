//
//  InsuranceCostTableViewCell.swift
//  Holk
//
//  Created by 张梦皓 on 2019-06-30.
//  Copyright © 2019 Holk. All rights reserved.
//

import UIKit

class InsuranceCostTableViewCell: UITableViewCell {
    // MARK: - IBOutlets
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var insuranceImageView: UIImageView!
    @IBOutlet private weak var illustrationView: UIImageView!
    @IBOutlet private weak var typeLabel: UILabel!
    @IBOutlet private weak var costLabel: UILabel!
    @IBOutlet private weak var costValueLabel: UILabel!
    // MARK: - Public variables
    override var reuseIdentifier: String? {
        return InsuranceCostTableViewCell.identifier
    }
    // MARK: - Private variables
    private let lightFeedbackGenerator = UIImpactFeedbackGenerator(style: .light)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setup()
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        let scaleTransform = highlighted ? CGAffineTransform(scaleX: 0.95, y: 0.95) : .identity
        let animator = UIViewPropertyAnimator(duration: 0.1, curve: .easeOut) {
            self.transform = scaleTransform
        }
        animator.startAnimation()
        
        lightFeedbackGenerator.impactOccurred()
    }
    
    private func setup() {
        selectionStyle = .none
        
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        containerView.backgroundColor = Color.secondaryBackgroundColor
        containerView.layer.cornerRadius = 6
        if #available(iOS 13.0, *) {
            containerView.layer.cornerCurve = .continuous
        }
        typeLabel.font = Font.light(.cellTitle)
        typeLabel.textColor = Color.mainForegroundColor
        costLabel.font = Font.regular(.description)
        costLabel.textColor = Color.secondaryForegroundColor
        costValueLabel.font = Font.regular(.subHeader)
        costValueLabel.textColor = Color.mainForegroundColor
        lightFeedbackGenerator.prepare()
    }
    
}
