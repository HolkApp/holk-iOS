//
//  InsuranceSuggestionHeaderView.swift
//  Holk
//
//  Created by 张梦皓 on 2020-06-13.
//  Copyright © 2020 Holk. All rights reserved.
//

import UIKit

final class InsuranceSuggestionHeaderView: UICollectionReusableView {
    let textLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: .zero)

        clipsToBounds = true
        backgroundColor = .clear

        textLabel.setStyleGuide(.body3)
        textLabel.textColor = Color.secondaryForegroundColor
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(textLabel)

        NSLayoutConstraint.activate([
            textLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            textLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            textLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),
            textLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -32)
        ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    func configure(_ text: String) {
        textLabel.text = text
    }
}

