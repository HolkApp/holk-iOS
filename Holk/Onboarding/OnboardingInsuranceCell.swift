//
//  OnboardingInsuranceCell.swift
//  Holk
//
//  Created by 张梦皓 on 2020-02-11.
//  Copyright © 2020 Holk. All rights reserved.
//

import UIKit

final class OnboardingInsuranceCell: UITableViewCell {
    private let stackView = UIStackView()
    private let comingUpLabel = UILabel()
    
    let iconView = UIImageView()
    let titleLabel = UILabel()
    
    var isUpcoming: Bool = false {
        didSet {
            if isUpcoming {
                if comingUpLabel.superview == nil {
                    stackView.addArrangedSubview(comingUpLabel)
                }
                accessoryView = nil
            } else {
                if !isUpcoming, comingUpLabel.superview != nil {
                    comingUpLabel.removeFromSuperview()
                }
                let image = UIImage(systemName: "chevron.right")?.withRenderingMode(.alwaysTemplate)
                let detailDisclosureView = UIImageView(image: image)
                detailDisclosureView.tintColor = Color.mainForeground
                accessoryView = detailDisclosureView
            }
            updateColor()
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        layoutMargins = .init(top: 12, left: 36, bottom: 12, right: 36)
        selectionStyle = .none
        backgroundColor = Color.mainBackground
        contentView.backgroundColor = .clear
        
        let image = UIImage(systemName: "chevron.right")?.withRenderingMode(.alwaysTemplate)
        let detailDisclosureView = UIImageView(image: image)
        detailDisclosureView.tintColor = Color.mainForeground
        accessoryView = detailDisclosureView
        
        contentView.addSubview(stackView)
        contentView.addSubview(iconView)
        stackView.addArrangedSubview(titleLabel)
        
        titleLabel.numberOfLines = 0
        titleLabel.font = Font.bold(.label)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        iconView.contentMode = .scaleAspectFit
        iconView.translatesAutoresizingMaskIntoConstraints = false
        
        comingUpLabel.numberOfLines = 0
        comingUpLabel.font = Font.semiBold(.description)
        comingUpLabel.text = "Coming Soon"
        
        stackView.axis = .vertical
        stackView.spacing = -10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        updateColor()
        
        let bottomConstraint = iconView.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor)
        bottomConstraint.priority = .defaultHigh
        NSLayoutConstraint.activate([
            iconView.widthAnchor.constraint(equalToConstant: 48),
            iconView.heightAnchor.constraint(equalToConstant: 48),
            iconView.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            iconView.trailingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: -20),
            iconView.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            bottomConstraint,
            
            stackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor, constant: -20),
            stackView.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            stackView.bottomAnchor.constraint(greaterThanOrEqualTo: contentView.layoutMarginsGuide.bottomAnchor)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        isUpcoming = false
    }
    
    override func layoutMarginsDidChange() {
        super.layoutMarginsDidChange()
        
        separatorInset.left = 0
        separatorInset.right = layoutMargins.right
    }
    
    private func updateColor() {
        iconView.tintColor = isUpcoming ? Color.placeHolder : Color.mainForeground
        titleLabel.textColor = isUpcoming ? Color.placeHolder : Color.mainForeground
        comingUpLabel.textColor = isUpcoming ? Color.placeHolder : Color.mainForeground
    }
    
    func configure(title: String, image: UIImage? = nil, isUpcoming: Bool = false) {
        titleLabel.text = title
        iconView.image = image
        self.isUpcoming = isUpcoming
    }
}
