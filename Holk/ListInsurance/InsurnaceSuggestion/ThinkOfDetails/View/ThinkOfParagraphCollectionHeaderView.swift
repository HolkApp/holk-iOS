//
//  ThinkOfParagraphCollectionHeaderView.swift
//  Holk
//
//  Created by 张梦皓 on 2020-09-10.
//  Copyright © 2020 Holk. All rights reserved.
//

import UIKit

final class ThinkOfParagraphCollectionHeaderView: UICollectionReusableView {
    private let headerLabel = UILabel()
    private let descriptionLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: .zero)

        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    private func setup() {
        backgroundColor = Color.secondaryBackground

        headerLabel.setStyleGuide(.header5)
        headerLabel.numberOfLines = 0
        headerLabel.textColor = Color.mainForeground
        headerLabel.translatesAutoresizingMaskIntoConstraints = false

        descriptionLabel.setStyleGuide(.subHeader5)
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
        headerLabel.setText(viewModel.detailHeader, with: .header5)
        descriptionLabel.setText(viewModel.detailDescription, with: .subHeader5)
    }
}
