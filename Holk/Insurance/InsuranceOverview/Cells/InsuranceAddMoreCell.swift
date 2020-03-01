//
//  InsuranceAddMoreCell.swift
//  Holk
//
//  Created by 张梦皓 on 2019-06-16.
//  Copyright © 2019 Holk. All rights reserved.
//

import UIKit

final class InsuranceAddMoreCell: UITableViewCell {
    // MARK: - Public variables
    override var reuseIdentifier: String? {
        return InsuranceAddMoreCell.identifier
    }
    // MARK: - Private variables
    private var iconImageView: UIImageView!
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        let scaleTransform = highlighted ? CGAffineTransform(scaleX: 0.95, y: 0.95) : .identity
        let animator = UIViewPropertyAnimator(duration: 0.1, curve: .easeOut) {
            self.transform = scaleTransform
        }
        animator.startAnimation()
    }
    
    private func setup() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        selectionStyle = .none

        let image = UIImage(systemName: "plus.circle")?.withRenderingMode(.alwaysTemplate).withSymbolWeightConfiguration(.thin)
        
        iconImageView = UIImageView(image: image)
        iconImageView.tintColor = Color.mainForegroundColor
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(iconImageView)
        NSLayoutConstraint.activate([
            iconImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            iconImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            iconImageView.heightAnchor.constraint(equalToConstant: 55),
            iconImageView.widthAnchor.constraint(equalToConstant: 55),
            iconImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
        ])
    }
}
