//
//  SubInsuranceDetailsHeaderView.swift
//  Holk
//
//  Created by 张梦皓 on 2020-10-11.
//  Copyright © 2020 Holk. All rights reserved.
//

import UIKit

protocol SubInsuranceDetailsHeaderViewDelegate: AnyObject {
    func subInsuranceDetailsHeaderView(_ subInsuranceDetailsHeaderView: SubInsuranceDetailsHeaderView, updatedSelection: SubInsuranceDetailViewModel.SelectedSubInsuranceDetails)
}

final class SubInsuranceDetailsHeaderView: UICollectionReusableView {
    weak var delegate: SubInsuranceDetailsHeaderViewDelegate?

    private let titleLabel = HolkLabel()
    private let subtitle = HolkLabel()
    private let descriptionLabel = HolkLabel()

    private let selectionsContainerView = UIView()
    private let coverSelection = HolkIconSelectionView()
    private let gapSelection = HolkIconSelectionView()
    private let thinkOfSelection = HolkIconSelectionView()

    var selectedSubInsuranceDetails: SubInsuranceDetailViewModel.SelectedSubInsuranceDetails = .cover {
        didSet {
            delegate?.subInsuranceDetailsHeaderView(self, updatedSelection: selectedSubInsuranceDetails)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(subInsurance: Insurance.SubInsurance, selectedSubInsuranceDetails: SubInsuranceDetailViewModel.SelectedSubInsuranceDetails = .cover) {
        titleLabel.text = subInsurance.title
        subtitle.text = LocalizedString.Insurance.homeInsurance
        self.selectedSubInsuranceDetails = selectedSubInsuranceDetails

        backgroundColor = Color.subInsuranceBackgroundColor(subInsurance.kind)
    }

    private func setup() {
        layoutMargins = .init(top: 20, left: 40, bottom: 28, right: 40)

        titleLabel.styleGuide = .cardHeader1
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        subtitle.styleGuide = .header6
        subtitle.translatesAutoresizingMaskIntoConstraints = false

        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false

        selectionsContainerView.translatesAutoresizingMaskIntoConstraints = false

        coverSelection.addTarget(self, action: #selector(iconViewSelected(_:)), for: .touchUpInside)
        coverSelection.configure(image: UIImage.cover)
        coverSelection.isSelected = true
        coverSelection.translatesAutoresizingMaskIntoConstraints = false

        gapSelection.addTarget(self, action: #selector(iconViewSelected(_:)), for: .touchUpInside)
        gapSelection.configure(image: UIImage.gap)
        gapSelection.isSelected = false
        gapSelection.translatesAutoresizingMaskIntoConstraints = false

        thinkOfSelection.addTarget(self, action: #selector(iconViewSelected(_:)), for: .touchUpInside)
        thinkOfSelection.configure(image: UIImage.thinkOf)
        thinkOfSelection.isSelected = false
        thinkOfSelection.translatesAutoresizingMaskIntoConstraints = false

        addSubview(titleLabel)
        addSubview(subtitle)
        addSubview(descriptionLabel)
        addSubview(selectionsContainerView)

        selectionsContainerView.addSubview(coverSelection)
        selectionsContainerView.addSubview(gapSelection)
        selectionsContainerView.addSubview(thinkOfSelection)

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            titleLabel.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor, constant: 80),
            titleLabel.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),

            subtitle.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            subtitle.topAnchor.constraint(equalTo: titleLabel.lastBaselineAnchor, constant: 16),
            subtitle.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),

            descriptionLabel.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: subtitle.lastBaselineAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),

            selectionsContainerView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            selectionsContainerView.topAnchor.constraint(equalTo: descriptionLabel.lastBaselineAnchor, constant: 36),
            selectionsContainerView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            selectionsContainerView.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor),

            coverSelection.leadingAnchor.constraint(equalTo: selectionsContainerView.leadingAnchor),
            coverSelection.topAnchor.constraint(equalTo: selectionsContainerView.topAnchor),
            coverSelection.bottomAnchor.constraint(equalTo: selectionsContainerView.bottomAnchor),
            coverSelection.widthAnchor.constraint(equalToConstant: 60),
            coverSelection.heightAnchor.constraint(equalToConstant: 60),

            gapSelection.leadingAnchor.constraint(greaterThanOrEqualTo: coverSelection.trailingAnchor, constant: 20),
            gapSelection.widthAnchor.constraint(equalToConstant: 60),
            gapSelection.heightAnchor.constraint(equalToConstant: 60),
            gapSelection.centerXAnchor.constraint(equalTo: selectionsContainerView.centerXAnchor),
            gapSelection.centerYAnchor.constraint(equalTo: coverSelection.centerYAnchor),

            thinkOfSelection.leadingAnchor.constraint(greaterThanOrEqualTo: gapSelection.trailingAnchor, constant: 20),
            thinkOfSelection.widthAnchor.constraint(equalToConstant: 60),
            thinkOfSelection.heightAnchor.constraint(equalToConstant: 60),
            thinkOfSelection.centerYAnchor.constraint(equalTo: coverSelection.centerYAnchor),
            thinkOfSelection.trailingAnchor.constraint(equalTo: selectionsContainerView.trailingAnchor)
        ])
    }
}

extension SubInsuranceDetailsHeaderView {
    @objc private func iconViewSelected(_ sender: UIControl) {
        coverSelection.isSelected = sender === coverSelection
        gapSelection.isSelected = sender === gapSelection
        thinkOfSelection.isSelected = sender === thinkOfSelection

        switch sender {
        case coverSelection:
            selectedSubInsuranceDetails = .cover
        case gapSelection:
            selectedSubInsuranceDetails = .gaps
        case thinkOfSelection:
            selectedSubInsuranceDetails = .thinkOfs
        default: break
        }
    }
}
