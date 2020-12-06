//
//  SubInsuranceDetailsSegmentCollectionViewCell.swift
//  Holk
//
//  Created by 张梦皓 on 2020-10-18.
//  Copyright © 2020 Holk. All rights reserved.
//

import UIKit

protocol SubInsuranceDetailsSegmentCollectionViewCellDelegate: AnyObject {
    func subInsuranceDetailsSegmentCollectionViewCell(_ headerView: SubInsuranceDetailsSegmentCollectionViewCell, updatedSegment: Insurance.SubInsurance.Item.Segment)
}

final class SubInsuranceDetailsSegmentCollectionViewCell: UICollectionViewCell {
    var delegate: SubInsuranceDetailsSegmentCollectionViewCellDelegate?

    private let segmentedControl = UISegmentedControl()
    private var segments: [Insurance.SubInsurance.Item.Segment] = []

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(_ subInsurance: Insurance.SubInsurance, segments: [Insurance.SubInsurance.Item.Segment]) {
        self.segments = segments
        segmentedControl.removeAllSegments()
        segments.enumerated().forEach { (index, segment) in
            segmentedControl.insertSegment(withTitle: segment.descriptionForSubInsurance(subInsurance), at: index, animated: false)
        }
        segmentedControl.selectedSegmentIndex = 0
    }

    private func setup() {
        contentView.layoutMargins = .init(top: 0, left: 20, bottom: 0, right: 20)

        segmentedControl.backgroundColor = Color.mainBackground
        segmentedControl.selectedSegmentTintColor = Color.label
        segmentedControl.layer.borderWidth = 1
        segmentedControl.layer.borderColor = Color.placeholder.cgColor
        segmentedControl.layer.cornerRadius = 22
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: Color.label], for: .normal)
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: Color.mainBackground], for: .selected)

        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.addTarget(self, action: #selector(segmentedSelected(_:)), for: .valueChanged)

        contentView.addSubview(segmentedControl)

        NSLayoutConstraint.activate([
//            segmentedControl.heightAnchor.constraint(equalToConstant: 44),
            segmentedControl.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            segmentedControl.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            segmentedControl.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            segmentedControl.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor)
        ])
    }

    @objc private func segmentedSelected(_ sender: UISegmentedControl) {
        delegate?.subInsuranceDetailsSegmentCollectionViewCell(self, updatedSegment: segments[sender.selectedSegmentIndex])
    }
}

extension Insurance.SubInsurance.Item.Segment {
    func descriptionForSubInsurance(_ subInsurance: Insurance.SubInsurance) -> String {
        switch self {
        case .home:
            switch subInsurance.kind {
            case .movables:
                return "I hemmet"
            default:
                return "I hemmet"
            }
        case .outdoor:
            switch subInsurance.kind {
            case .movables:
                return "Utanför hemmet"
            default:
                return "Utanför hemmet"
            }
        default:
            return "Övriga"
        }
    }
}
