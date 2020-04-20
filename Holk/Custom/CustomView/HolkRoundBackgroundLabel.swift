//
//  HolkRoundBackgroundLabel.swift
//  Holk
//
//  Created by 张梦皓 on 2020-04-10.
//  Copyright © 2020 Holk. All rights reserved.
//

import UIKit

class HolkRoundBackgroundLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)

        clipsToBounds = true
        layoutMargins = .init(top: 8, left: 16, bottom: 8, right: 16)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let radius = min(frame.height, frame.width) / 2
        layer.cornerRadius = radius

        invalidateIntrinsicContentSize()
    }

    override var intrinsicContentSize: CGSize {
        var originalIntrinsicContentSize = super.intrinsicContentSize
        originalIntrinsicContentSize.width = originalIntrinsicContentSize.width + layoutMargins.left + layoutMargins.right
        return originalIntrinsicContentSize
    }
}
