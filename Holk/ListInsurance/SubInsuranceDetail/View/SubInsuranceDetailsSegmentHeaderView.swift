//
//  SubInsuranceDetailsSegmentHeaderView.swift
//  Holk
//
//  Created by 张梦皓 on 2020-10-18.
//  Copyright © 2020 Holk. All rights reserved.
//

import UIKit

final class SubInsuranceDetailsSegmentHeaderView: UICollectionReusableView {
    private let segmentControl = UISegmentedControl()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        segmentControl.backgroundColor = Color.mainBackground
        segmentControl.selectedSegmentTintColor = Color.label
        segmentControl.clipsToBounds = true
        segmentControl.layer.borderWidth = 1
        segmentControl.layer.borderColor = Color.placeholder.cgColor
        segmentControl.layer.cornerRadius = 22
        segmentControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: Color.label], for: .normal)
        segmentControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: Color.mainBackground], for: .selected)


        configure()

        segmentControl.translatesAutoresizingMaskIntoConstraints = false

        addSubview(segmentControl)

        NSLayoutConstraint.activate([
            segmentControl.heightAnchor.constraint(equalToConstant: 44),
            segmentControl.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            segmentControl.topAnchor.constraint(equalTo: topAnchor),
            segmentControl.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            segmentControl.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    private func configure() {

    }

}
