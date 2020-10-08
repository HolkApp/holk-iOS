//
//  HolkRoundBackgroundLabel.swift
//  Holk
//
//  Created by 张梦皓 on 2020-04-10.
//  Copyright © 2020 Holk. All rights reserved.
//

import UIKit

final class HolkRoundBackgroundLabel: HolkLabel {
    var cornerRadius: CGFloat?

    override init(frame: CGRect) {
        super.init(frame: frame)

        clipsToBounds = true
        layoutMargins = .init(top: 0, left: 12, bottom: 0, right: 12)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let radius = cornerRadius ?? min(frame.height, frame.width) / 2
        layer.cornerRadius = radius

        invalidateIntrinsicContentSize()
    }

    override var intrinsicContentSize: CGSize {
        var originalIntrinsicContentSize = super.intrinsicContentSize
        originalIntrinsicContentSize.width = originalIntrinsicContentSize.width + layoutMargins.left + layoutMargins.right
        return originalIntrinsicContentSize
    }
}
