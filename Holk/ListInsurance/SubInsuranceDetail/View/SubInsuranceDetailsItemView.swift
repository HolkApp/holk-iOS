//
//  SubInsuranceDetailsItemView.swift
//  Holk
//
//  Created by 张梦皓 on 2020-11-03.
//  Copyright © 2020 Holk. All rights reserved.
//

import UIKit

final class SubInsuranceDetailsItemView: UIView {
    private let textLabel = HolkLabel()
    private let valueLabel = HolkLabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(item: Insurance.SubInsurance.Item) {
        textLabel.text = item.infoText
        valueLabel.text = item.maxAmount
    }

    private func setup() {
        textLabel.styleGuide = .subHeader5
        textLabel.numberOfLines = 0
        textLabel.translatesAutoresizingMaskIntoConstraints = false

        valueLabel.styleGuide = .number2
        valueLabel.textAlignment = .right
        valueLabel.numberOfLines = 0
        valueLabel.translatesAutoresizingMaskIntoConstraints = false

        addSubview(textLabel)
        addSubview(valueLabel)

        NSLayoutConstraint.activate([
            textLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            textLabel.topAnchor.constraint(equalTo: topAnchor),
            textLabel.trailingAnchor.constraint(lessThanOrEqualTo: valueLabel.leadingAnchor),

            valueLabel.topAnchor.constraint(equalTo: topAnchor),
            valueLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            valueLabel.lastBaselineAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
