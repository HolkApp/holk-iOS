//
//  ThinkOfRelatedCollectionHeaderView.swift
//  Holk
//
//  Created by 张梦皓 on 2020-07-12.
//  Copyright © 2020 Holk. All rights reserved.
//

import UIKit

final class ThinkOfRelatedInsuranceCollectionHeaderView: UICollectionReusableView {
    private let titleLabel = UILabel()
    private let titleSeparatorline = UIView()
    private let nameLabel = UILabel()
    private let nameValueLabel = UILabel()
    private let nameSeparatorline = UIView()
    private let providerLabel = UILabel()
    private let providerValueLabel = UIImageView()
    private let providerSeparatorline = UIView()
    private let endDateLabel = UILabel()
    private let endDateValueLabel = UILabel()
    private let endDateSeparatorline = UIView()

    override init(frame: CGRect) {
        super.init(frame: .zero)

        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    func configure(_ viewModel: ThinkOfInsuranceViewModel) {
        nameValueLabel.setText(viewModel.insuranceName, with: .titleHeader2)
        endDateValueLabel.setText(viewModel.endDateString, with: .titleHeader2)
        if let imageURL = viewModel.insuranceImageURL {
            UIImage.makeImageWithURL(imageURL) { [weak self] image in
                self?.providerValueLabel.image = image
            }
        }
    }

    private func setup() {
        clipsToBounds = true

        layoutMargins = .init(top: 36, left: 26, bottom: 36, right: 26)

        titleLabel.setText("Din info", with: .header6)
        titleLabel.textColor = Color.mainForeground
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        titleSeparatorline.backgroundColor = Color.separator
        titleSeparatorline.translatesAutoresizingMaskIntoConstraints = false

        nameLabel.setText("Försäkring", with: .titleHeader1)
        nameLabel.textColor = Color.mainForeground
        nameLabel.translatesAutoresizingMaskIntoConstraints = false

        nameValueLabel.setStyleGuide(.titleHeader2)
        nameValueLabel.textColor = Color.secondaryForeground
        nameValueLabel.textAlignment = .right
        nameValueLabel.translatesAutoresizingMaskIntoConstraints = false

        nameSeparatorline.backgroundColor = Color.separator
        nameSeparatorline.translatesAutoresizingMaskIntoConstraints = false

        providerLabel.text = "Bolag"
        providerLabel.setText("Bolag", with: .titleHeader1)
        providerLabel.textColor = Color.mainForeground
        providerLabel.translatesAutoresizingMaskIntoConstraints = false

        providerValueLabel.contentMode = .scaleAspectFit
        providerValueLabel.translatesAutoresizingMaskIntoConstraints = false

        providerSeparatorline.backgroundColor = Color.separator
        providerSeparatorline.translatesAutoresizingMaskIntoConstraints = false

        endDateLabel.setText("Gäller till", with: .titleHeader1)
        endDateLabel.textColor = Color.mainForeground
        endDateLabel.translatesAutoresizingMaskIntoConstraints = false

        endDateValueLabel.setStyleGuide(.titleHeader2)
        endDateValueLabel.textColor = Color.secondaryForeground
        endDateValueLabel.textAlignment = .right
        endDateValueLabel.translatesAutoresizingMaskIntoConstraints = false

        endDateSeparatorline.backgroundColor = Color.separator
        endDateSeparatorline.translatesAutoresizingMaskIntoConstraints = false

        setupLayout()
    }

    private func setupLayout() {
        addSubview(titleLabel)
        addSubview(titleSeparatorline)
        addSubview(nameLabel)
        addSubview(nameValueLabel)
        addSubview(nameSeparatorline)
        addSubview(providerLabel)
        addSubview(providerValueLabel)
        addSubview(providerSeparatorline)
        addSubview(endDateLabel)
        addSubview(endDateValueLabel)
        addSubview(endDateSeparatorline)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),

            titleSeparatorline.heightAnchor.constraint(equalToConstant: 2),
            titleSeparatorline.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            titleSeparatorline.topAnchor.constraint(equalTo: titleLabel.lastBaselineAnchor, constant: 16),
            titleSeparatorline.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),

            nameLabel.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            nameLabel.topAnchor.constraint(equalTo: titleSeparatorline.bottomAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: nameValueLabel.leadingAnchor, constant: -8),

            nameValueLabel.lastBaselineAnchor.constraint(equalTo: nameLabel.lastBaselineAnchor),
            nameValueLabel.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),

            nameSeparatorline.heightAnchor.constraint(equalToConstant: 2),
            nameSeparatorline.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            nameSeparatorline.topAnchor.constraint(equalTo: nameLabel.lastBaselineAnchor, constant: 16),
            nameSeparatorline.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),

            providerLabel.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            providerLabel.topAnchor.constraint(equalTo: nameSeparatorline.bottomAnchor, constant: 16),
            providerLabel.trailingAnchor.constraint(equalTo: providerValueLabel.leadingAnchor, constant: -8),

            providerValueLabel.heightAnchor.constraint(equalToConstant: 32),
            providerValueLabel.widthAnchor.constraint(equalToConstant: 140),
            providerValueLabel.centerYAnchor.constraint(equalTo: providerLabel.centerYAnchor),
            providerValueLabel.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),

            providerSeparatorline.heightAnchor.constraint(equalToConstant: 2),
            providerSeparatorline.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            providerSeparatorline.topAnchor.constraint(equalTo: providerLabel.lastBaselineAnchor, constant: 16),
            providerSeparatorline.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),

            endDateLabel.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            endDateLabel.topAnchor.constraint(equalTo: providerSeparatorline.bottomAnchor, constant: 16),
            endDateLabel.trailingAnchor.constraint(equalTo: endDateValueLabel.leadingAnchor, constant: -8),

            endDateValueLabel.lastBaselineAnchor.constraint(equalTo: endDateLabel.lastBaselineAnchor),
            endDateValueLabel.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),

            endDateSeparatorline.heightAnchor.constraint(equalToConstant: 2),
            endDateSeparatorline.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            endDateSeparatorline.topAnchor.constraint(equalTo: endDateLabel.lastBaselineAnchor, constant: 16),
            endDateSeparatorline.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            endDateSeparatorline.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor)
        ])
    }
}
