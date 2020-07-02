//
//  InsuranceSubmodelHeaderView.swift
//  Holk
//
//  Created by 张梦皓 on 2020-07-02.
//  Copyright © 2020 Holk. All rights reserved.
//

import UIKit

final class InsuranceSubmodelHeaderView: UICollectionReusableView {
    let titleLabel = UILabel()
    let descriptionLabel = UILabel()
    let imageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: .zero)

        clipsToBounds = true
        backgroundColor = .clear

        titleLabel.setStyleGuide(.header4)
        titleLabel.textColor = Color.secondaryForeground
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        descriptionLabel.setStyleGuide(.subHeaders3)
        descriptionLabel.textColor = Color.secondaryForeground
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false

        imageView.image = UIImage(named: "house")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(titleLabel)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 30),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),

            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.lastBaselineAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor),

            imageView.topAnchor.constraint(equalTo: descriptionLabel.lastBaselineAnchor, constant: 30),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 114),
            imageView.heightAnchor.constraint(equalToConstant: 92),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 48)
        ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        titleLabel.text = nil
        descriptionLabel.text = nil
    }

    func configure(_ insurance: Insurance) {
        titleLabel.text = "Dina skydd"
        descriptionLabel.text = insurance.insuranceType.description
    }
}
