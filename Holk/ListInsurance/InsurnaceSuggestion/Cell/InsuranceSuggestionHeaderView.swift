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

        textLabel.textColor = Color.secondaryForegroundColor
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(textLabel)

        NSLayoutConstraint.activate([
            textLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            textLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            textLabel.lastBaselineAnchor.constraint(equalTo: topAnchor, constant: 36)
        ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    func configure(_ text: String) {
        textLabel.text = text
    }
}

