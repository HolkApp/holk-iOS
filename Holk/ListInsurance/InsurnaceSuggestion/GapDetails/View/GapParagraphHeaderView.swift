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
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let separatorLine = UIView()
    private let headerLabel = UILabel()


    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(_ viewModel: GapParagraphHeaderViewModel) {
        titleLabel.set(text: viewModel.title, with: .cardHeader3)
        descriptionLabel.set(text: viewModel.description, with: .body4)
        headerLabel.set(text: viewModel.paragraphHeader, with: .header5)
    }

    private func setup() {
        titleLabel.numberOfLines = 0
        titleLabel.textColor = Color.label
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        descriptionLabel.numberOfLines = 0
        descriptionLabel.textColor = Color.secondaryForeground
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false

        headerLabel.numberOfLines = 0
        headerLabel.textColor = Color.label
        headerLabel.translatesAutoresizingMaskIntoConstraints = false

        separatorLine.backgroundColor = Color.gapSeparator
        separatorLine.translatesAutoresizingMaskIntoConstraints = false

        setupLayout()
    }

    private func setupLayout() {
        addSubview(titleLabel)
        addSubview(descriptionLabel)
        addSubview(separatorLine)
        addSubview(headerLabel)

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),
            titleLabel.bottomAnchor.constraint(equalTo: descriptionLabel.topAnchor, constant: -8),

            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),
            descriptionLabel.bottomAnchor.constraint(equalTo: separatorLine.topAnchor, constant: -24),

            separatorLine.heightAnchor.constraint(equalToConstant: 1),
            separatorLine.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            separatorLine.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),
            separatorLine.bottomAnchor.constraint(equalTo: headerLabel.topAnchor, constant: -36),

            headerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            headerLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 32),
            headerLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -24)
        ])
    }
}
