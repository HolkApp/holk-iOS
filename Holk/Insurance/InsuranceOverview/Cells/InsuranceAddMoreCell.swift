//
//  InsuranceAddMoreCell.swift
//  Holk
//
//  Created by 张梦皓 on 2019-06-16.
//  Copyright © 2019 Holk. All rights reserved.
//

import UIKit

final class InsuranceAddMoreCell: UICollectionViewCell {
    // MARK: - Private variables
    private var iconImageView: UIImageView!
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var isHighlighted: Bool {
        didSet {
            let scaleTransform = isHighlighted ? CGAffineTransform(scaleX: 0.95, y: 0.95) : .identity
            let animator = UIViewPropertyAnimator(duration: 0.1, curve: .easeOut) {
                self.transform = scaleTransform
            }
            animator.startAnimation()
        }
    }

    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let layoutAttributes = super.preferredLayoutAttributesFitting(layoutAttributes)
        layoutIfNeeded()
        layoutAttributes.frame.size = systemLayoutSizeFitting(UIView.layoutFittingCompressedSize, withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
        return layoutAttributes
    }
    
    private func setup() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear

        let image = UIImage(systemName: "plus.circle")?.withRenderingMode(.alwaysTemplate).withSymbolWeightConfiguration(.thin)

        iconImageView = UIImageView(image: image)
        iconImageView.tintColor = Color.mainForegroundColor
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(iconImageView)
        let iconWidthConstraint = iconImageView.widthAnchor.constraint(equalToConstant: 64)
        let iconHeightConstraint = iconImageView.heightAnchor.constraint(equalToConstant: 64)
        iconHeightConstraint.priority = .defaultHigh
        let iconTopConstraint = iconImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 200)
        iconTopConstraint.priority = .defaultHigh
        let iconBottomConstraint = iconImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -200)
        iconBottomConstraint.priority = .defaultHigh
        NSLayoutConstraint.activate([
            iconTopConstraint,
            iconBottomConstraint,
            iconHeightConstraint,
            iconWidthConstraint,
            iconImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
    }
}
