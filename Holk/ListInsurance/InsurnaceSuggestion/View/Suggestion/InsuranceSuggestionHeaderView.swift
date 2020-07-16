//
//  InsuranceSuggestionCollectionHeaderView.swift
//  Holk
//
//  Created by 张梦皓 on 2020-06-13.
//  Copyright © 2020 Holk. All rights reserved.
//

import UIKit

final class InsuranceSuggestionCollectionHeaderView: UICollectionReusableView {
    let textLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: .zero)

        clipsToBounds = true
        backgroundColor = .clear

        textLabel.setStyleGuide(.body3)
        textLabel.textColor = Color.secondaryForeground
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(textLabel)

        NSLayoutConstraint.activate([
            textLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            textLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            textLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -28),
            textLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    func configure(_ text: String) {
        textLabel.text = text
    }
}

