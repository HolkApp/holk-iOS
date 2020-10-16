//
//  SubInsuranceDetailHeaderView.swift
//  Holk
//
//  Created by 张梦皓 on 2020-10-11.
//  Copyright © 2020 Holk. All rights reserved.
//

import UIKit

final class SubInsuranceDetailHeaderView: UICollectionReusableView {
    weak var subInsuranceDetailViewController: HomeSubInsuranceDetailViewController?

    private let titleLabel = HolkLabel()
    private let subtitle = HolkLabel()
    private let descriptionLabel = HolkLabel()

    private let coverIcon = HolkIconSelectionView()
    private let gapsIcon = HolkIconSelectionView()
    private let thinkOfsIcon = HolkIconSelectionView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
    }
}
