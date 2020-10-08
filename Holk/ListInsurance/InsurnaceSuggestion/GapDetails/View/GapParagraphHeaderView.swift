//
//  GapParagraphHeaderView.swift
//  Holk
//
//  Created by 张梦皓 on 2020-09-10.
//  Copyright © 2020 Holk. All rights reserved.
//

import UIKit

final class GapParagraphHeaderView: UICollectionReusableView {
    // MARK: - Private variables
    private let headerLabel = HolkLabel()
    private let descriptionLabel = HolkLabel()
    private let separatorLine = UIView()
    private let paragraphHeaderLabel = HolkLabel()


    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        headerLabel.styleGuide = .header5
        headerLabel.numberOfLines = 0
        headerLabel.textColor = Color.label
        headerLabel.translatesAutoresizingMaskIntoConstraints = false

        descriptionLabel.styleGuide = .body4
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textColor = Color.secondaryForeground
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false

        paragraphHeaderLabel.styleGuide = .header5
        paragraphHeaderLabel.numberOfLines = 0
        paragraphHeaderLabel.textColor = Color.label
        paragraphHeaderLabel.translatesAutoresizingMaskIntoConstraints = false

        separatorLine.backgroundColor = Color.gapSeparator
        separatorLine.translatesAutoresizingMaskIntoConstraints = false

        setupLayout()
    }

    private func setupLayout() {
        addSubview(headerLabel)
        addSubview(descriptionLabel)
        addSubview(separatorLine)
        addSubview(paragraphHeaderLabel)

        NSLayoutConstraint.activate([
            headerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            headerLabel.topAnchor.constraint(equalTo: topAnchor),
            headerLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),
            headerLabel.bottomAnchor.constraint(equalTo: descriptionLabel.topAnchor, constant: -16),

            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),
            descriptionLabel.bottomAnchor.constraint(equalTo: separatorLine.topAnchor),

            separatorLine.heightAnchor.constraint(equalToConstant: 1),
            separatorLine.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            separatorLine.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),
            separatorLine.bottomAnchor.constraint(equalTo: paragraphHeaderLabel.topAnchor, constant: -36),

            paragraphHeaderLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            paragraphHeaderLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 32),
            paragraphHeaderLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -24)
        ])
    }
}

extension GapParagraphHeaderView {
    func configure(_ viewModel: GapParagraphHeaderViewModel) {
        headerLabel.text = viewModel.header
        descriptionLabel.text = viewModel.description
        paragraphHeaderLabel.text = viewModel.paragraphHeader
    }
}
