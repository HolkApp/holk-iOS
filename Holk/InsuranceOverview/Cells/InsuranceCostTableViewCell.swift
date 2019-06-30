//
//  InsuranceCostTableViewCell.swift
//  Holk
//
//  Created by 张梦皓 on 2019-06-30.
//  Copyright © 2019 Holk. All rights reserved.
//

import UIKit

class InsuranceCostTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var insuranceImageView: UIImageView!
    @IBOutlet private weak var illustrationView: UIImageView!
    @IBOutlet private weak var typeLabel: UILabel!
    @IBOutlet private weak var costLabel: UILabel!
    @IBOutlet private weak var costValueLabel: UILabel!
    
    override var reuseIdentifier: String? {
        return InsuranceCostTableViewCell.identifier
    }
    
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
    }
    
    private func setup() {
        selectionStyle = .none
        
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        containerView.backgroundColor = Color.secondaryBackgroundColor
        containerView.layer.cornerRadius = 6
        
        typeLabel.font = Font.light(.cellTitle)
        costLabel.font = Font.regular(.description)
        costLabel.textColor = Color.secondaryForegroundColor
        costValueLabel.font = Font.regular(.secondHeader)
    }
    
}
