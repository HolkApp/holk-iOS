//
//  SubInsuranceDetailsTitleCollectionViewCell.swift
//  Holk
//
//  Created by 张梦皓 on 2020-10-18.
//  Copyright © 2020 Holk. All rights reserved.
//

import UIKit

final class SubInsuranceDetailsTitleCollectionViewCell: UICollectionViewCell {
    private let titleLabel = HolkLabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        contentView.layoutMargins = .init(top: 24, left: 30, bottom: 24, right: 30)

        titleLabel.styleGuide = .cardHeader2
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            titleLabel.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            titleLabel.lastBaselineAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor)
        ])
    }

    func configure(_ selectedSubInsuranceDetails: SubInsuranceDetailViewModel.SelectedSubInsuranceDetails) {
        titleLabel.text = selectedSubInsuranceDetails.description
    }
}

extension SubInsuranceDetailViewModel.SelectedSubInsuranceDetails {
    var description: String {
        switch self {
        case .cover:
            return LocalizedString.Insurance.Details.title
        case .gaps:
            return LocalizedString.Suggestion.Gap.gap
        case .thinkOfs:
            return LocalizedString.Suggestion.ThinkOf.thinkOf
        }
    }
}
