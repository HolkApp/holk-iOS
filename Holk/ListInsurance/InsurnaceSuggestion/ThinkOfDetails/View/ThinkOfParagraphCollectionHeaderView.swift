//
//  ThinkOfParagraphCollectionHeaderView.swift
//  Holk
//
//  Created by 张梦皓 on 2020-09-10.
//  Copyright © 2020 Holk. All rights reserved.
//

import UIKit

final class ThinkOfParagraphCollectionHeaderView: UICollectionReusableView {
    private let headerLabel = HolkLabel()
    private let descriptionLabel = HolkLabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    private func setup() {
        backgroundColor = Color.secondaryBackground

        headerLabel.styleGuide = .header5
        headerLabel.numberOfLines = 0
        headerLabel.textColor = Color.mainForeground
        headerLabel.translatesAutoresizingMaskIntoConstraints = false

        descriptionLabel.styleGuide = .subHeader5
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textColor = Color.mainForeground
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false

        setupLayout()
    }

    private func setupLayout() {
        addSubview(headerLabel)
        addSubview(descriptionLabel)

        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: topAnchor),
            headerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            headerLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),

            descriptionLabel.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),
            descriptionLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

extension ThinkOfParagraphCollectionHeaderView {
    func configure(_ viewModel: ThinkOfParagraphHeaderViewModel) {
        headerLabel.text = viewModel.detailHeader
        descriptionLabel.text = viewModel.detailDescription
    }
}
