//
//  InsuranceTableViewCell.swift
//  Holk
//
//  Created by 张梦皓 on 2019-06-11.
//  Copyright © 2019 Holk. All rights reserved.
//

import UIKit

final class InsuranceTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var addressLabel: UILabel!
    @IBOutlet private weak var hintValueLabel: HolkillustrationLabel!
    @IBOutlet private weak var hintLabel: UILabel!
    @IBOutlet private weak var ideaValueLabel: HolkillustrationLabel!
    @IBOutlet private weak var ideaLabel: UILabel!
    @IBOutlet private weak var logoImageView: UIImageView!
    
    private let lightFeedbackGenerator = UIImpactFeedbackGenerator(style: .light)
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        logoImageView.image = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleLabel.font = Font.semibold(.title)
        titleLabel.textColor = Color.mainForegroundColor
        addressLabel.font = Font.regular(.subtitle)
        addressLabel.textColor = Color.mainForegroundColor
        
        hintValueLabel.font = Font.semibold(.header)
        hintValueLabel.textColor = Color.mainForegroundColor
        hintLabel.font = Font.regular(.description)
        hintLabel.textColor = Color.mainForegroundColor
        
        ideaValueLabel.font = Font.semibold(.header)
        ideaValueLabel.textColor = Color.mainForegroundColor
        ideaLabel.font = Font.regular(.description)
        ideaLabel.textColor = Color.mainForegroundColor
        
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        containerView.backgroundColor = Color.secondaryBackgroundColor
        
        selectionStyle = .none
        containerView.layer.cornerRadius = 6
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
        hintLabel.text = "Tänk på"
        ideaValueLabel.text = "2"
        ideaLabel.text = "Luckor"
        
        logoImageView.image = UIImage(named: "Folksam")
    }
}
