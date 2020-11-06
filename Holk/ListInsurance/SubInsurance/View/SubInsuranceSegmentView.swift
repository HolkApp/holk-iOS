//
//  SubInsuranceSegmentView.swift
//  Holk
//
//  Created by 张梦皓 on 2020-07-03.
//  Copyright © 2020 Holk. All rights reserved.
//

import UIKit

final class SubInsuranceSegmentView: UIControl {
    // MARK: - Private variables
    private let titleLabel = HolkLabel()
    private let numberLabel = HolkLabel()
    private let selectionView = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        layoutMargins = .init(top: 0, left: 6, bottom: 0, right: 6)

        titleLabel.textColor = Color.placeholder
        titleLabel.styleGuide = .titleHeader3
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        numberLabel.textColor = Color.placeholder
        numberLabel.styleGuide = .number4
        numberLabel.numberOfLines = 0
        numberLabel.textAlignment = .center
        numberLabel.translatesAutoresizingMaskIntoConstraints = false

        selectionView.isHidden = true
        selectionView.backgroundColor = Color.secondaryHighlight
        selectionView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(titleLabel)
        addSubview(numberLabel)
        addSubview(selectionView)

        NSLayoutConstraint.activate([
            numberLabel.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            numberLabel.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            numberLabel.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),

            titleLabel.topAnchor.constraint(equalTo: numberLabel.bottomAnchor, constant: 4),
            titleLabel.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),

            selectionView.heightAnchor.constraint(equalToConstant: 4),
            selectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            selectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            selectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            selectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    override var isSelected: Bool {
        didSet {
            selectionView.isHidden = !isSelected
            numberLabel.textColor = isSelected ? Color.mainForeground : Color.placeholder
            titleLabel.textColor = isSelected ? Color.mainForeground : Color.placeholder
        }
    }

    func configure(_ segmentKind: String, numberOfSubInsurances: Int) {
        titleLabel.text = segmentKind
        numberLabel.text = "\(numberOfSubInsurances)"
    }
}
