//
//  SubInsuranceDetailsEmptySuggestionCollectionView.swift
//  Holk
//
//  Created by 张梦皓 on 2020-12-06.
//  Copyright © 2020 Holk. All rights reserved.
//

import UIKit

final class SubInsuranceDetailsEmptySuggestionCollectionView: UICollectionViewCell {
    private let valueLabel = HolkIllustrationLabel()
    private let textLabel = HolkLabel()

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
