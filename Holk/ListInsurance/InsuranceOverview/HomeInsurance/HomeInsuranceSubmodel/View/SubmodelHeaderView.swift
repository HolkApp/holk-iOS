//
//  SubmodelHeaderView.swift
//  Holk
//
//  Created by 张梦皓 on 2020-07-02.
//  Copyright © 2020 Holk. All rights reserved.
//

import UIKit

final class SubmodelHeaderView: UICollectionReusableView {
    weak var submodelsViewController: HomeinsuranceSubmodelsViewController?
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let imageView = UIImageView()
    private let basicSubmodelsSegmentView = SubmodelSegmentView()
    private let additionalSubmodelsSegmentView = SubmodelSegmentView()

    override init(frame: CGRect) {
        super.init(frame: .zero)

        clipsToBounds = true
        backgroundColor = Color.secondaryBackground

        titleLabel.setStyleGuide(.header4)
        titleLabel.textAlignment = .center
        titleLabel.textColor = Color.mainForeground
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        descriptionLabel.setStyleGuide(.subHeaders3)
        descriptionLabel.textAlignment = .center
        descriptionLabel.textColor = Color.mainForeground
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false

        imageView.image = UIImage(named: "house")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false

        basicSubmodelsSegmentView.addTarget(self, action: #selector(segmentSelected(_:)), for: .touchUpInside)
        basicSubmodelsSegmentView.isSelected = true
        basicSubmodelsSegmentView.translatesAutoresizingMaskIntoConstraints = false

        additionalSubmodelsSegmentView.addTarget(self, action: #selector(segmentSelected(_:)), for: .touchUpInside)
        additionalSubmodelsSegmentView.isSelected = false
        additionalSubmodelsSegmentView.translatesAutoresizingMaskIntoConstraints = false

        let stackView = UIStackView()
        stackView.spacing = 32
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(basicSubmodelsSegmentView)
        stackView.addArrangedSubview(additionalSubmodelsSegmentView)

        addSubview(titleLabel)
        addSubview(descriptionLabel)
        addSubview(imageView)
        addSubview(stackView)

        let stackViewLeadingAnchor = stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 48)
        let stackViewTrailingAnchor = stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -48)
        stackViewLeadingAnchor.priority = .defaultHigh
        stackViewTrailingAnchor.priority = .defaultHigh

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
            imageView.bottomAnchor.constraint(equalTo: stackView.topAnchor, constant: -48),

            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackViewLeadingAnchor,
            stackViewTrailingAnchor,
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        titleLabel.text = nil
        descriptionLabel.text = nil
        basicSubmodelsSegmentView.isSelected = true
        additionalSubmodelsSegmentView.isSelected = false
    }

    func configure(_ insurance: Insurance) {
        titleLabel.text = "Dina skydd"
        descriptionLabel.text = insurance.insuranceType.description

        basicSubmodelsSegmentView.configure("Grundskydd", numberOfSubmodels:  insurance.segments.count)
        // TODO: Put addon here
        additionalSubmodelsSegmentView.configure("Tilläggsskydd", numberOfSubmodels:  0)
    }
}

extension SubmodelHeaderView {
    @objc private func segmentSelected(_ sender: UIControl) {
        if sender === basicSubmodelsSegmentView {
            basicSubmodelsSegmentView.isSelected = true
            additionalSubmodelsSegmentView.isSelected = false
            submodelsViewController?.updateSelection(.basic)
        } else {
            basicSubmodelsSegmentView.isSelected = false
            additionalSubmodelsSegmentView.isSelected = true
            submodelsViewController?.updateSelection(.additional)
        }
    }
}
