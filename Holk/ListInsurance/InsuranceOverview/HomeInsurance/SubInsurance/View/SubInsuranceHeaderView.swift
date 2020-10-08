//
//  SubInsuranceHeaderView.swift
//  Holk
//
//  Created by 张梦皓 on 2020-07-02.
//  Copyright © 2020 Holk. All rights reserved.
//

import UIKit

final class SubInsuranceHeaderView: UICollectionReusableView {
    weak var subInsurancesViewController: HomeSubInsurancesViewController?
    private let titleLabel = HolkLabel()
    private let descriptionLabel = HolkLabel()
    private let imageView = UIImageView()
    private let containerView = UIView()
    private let basicSubInsurancesSegmentView = SubInsuranceSegmentView()
    private let additionalSubInsurancesSegmentView = SubInsuranceSegmentView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = Color.secondaryBackground

        titleLabel.styleGuide = .header4
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        titleLabel.textColor = Color.mainForeground
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        descriptionLabel.styleGuide = .subHeader3
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textAlignment = .center
        descriptionLabel.textColor = Color.mainForeground
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false

        imageView.image = UIImage(named: "house")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false

        basicSubInsurancesSegmentView.addTarget(self, action: #selector(segmentSelected(_:)), for: .touchUpInside)
        basicSubInsurancesSegmentView.isSelected = true
        basicSubInsurancesSegmentView.translatesAutoresizingMaskIntoConstraints = false

        additionalSubInsurancesSegmentView.addTarget(self, action: #selector(segmentSelected(_:)), for: .touchUpInside)
        additionalSubInsurancesSegmentView.isSelected = false
        additionalSubInsurancesSegmentView.translatesAutoresizingMaskIntoConstraints = false

        containerView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(titleLabel)
        addSubview(descriptionLabel)
        addSubview(imageView)
        addSubview(containerView)
        containerView.addSubview(basicSubInsurancesSegmentView)
        containerView.addSubview(additionalSubInsurancesSegmentView)

        let containerViewLeadingAnchor = containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 48)
        let containerViewTrailingAnchor = containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -48)
        containerViewLeadingAnchor.priority = .defaultHigh
        containerViewTrailingAnchor.priority = .defaultHigh

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

            basicSubInsurancesSegmentView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            basicSubInsurancesSegmentView.topAnchor.constraint(equalTo: containerView.topAnchor),
            basicSubInsurancesSegmentView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            basicSubInsurancesSegmentView.widthAnchor.constraint(equalTo: additionalSubInsurancesSegmentView.widthAnchor),

            additionalSubInsurancesSegmentView.leadingAnchor.constraint(equalTo: basicSubInsurancesSegmentView.trailingAnchor, constant: 32),
            additionalSubInsurancesSegmentView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            additionalSubInsurancesSegmentView.topAnchor.constraint(equalTo: containerView.topAnchor),
            additionalSubInsurancesSegmentView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),

            containerView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 48),
            containerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            containerViewLeadingAnchor,
            containerViewTrailingAnchor,
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        basicSubInsurancesSegmentView.isSelected = true
        additionalSubInsurancesSegmentView.isSelected = false
    }

    func configure(_ insurance: Insurance) {
        titleLabel.text = "Dina skydd"
        descriptionLabel.text = insurance.kind.description

        basicSubInsurancesSegmentView.configure("Grundskydd", numberOfSubInsurances:  insurance.subInsurances.count)
        additionalSubInsurancesSegmentView.configure("Tilläggsskydd", numberOfSubInsurances:  insurance.addonInsurances.count)
    }
}

extension SubInsuranceHeaderView {
    @objc private func segmentSelected(_ sender: UIControl) {
        if sender === basicSubInsurancesSegmentView {
            basicSubInsurancesSegmentView.isSelected = true
            additionalSubInsurancesSegmentView.isSelected = false
            subInsurancesViewController?.updateSelection(.basic)
        } else {
            basicSubInsurancesSegmentView.isSelected = false
            additionalSubInsurancesSegmentView.isSelected = true
            subInsurancesViewController?.updateSelection(.addon)
        }
    }
}
