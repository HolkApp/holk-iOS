//
//  HolkRingChartIconView.swift
//  Holk
//
//  Created by 张梦皓 on 2020-03-06.
//  Copyright © 2020 Holk. All rights reserved.
//

import UIKit

final class HolkRingChartIconView: UIView {
    private let imageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        setup()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        layer.cornerRadius = frame.width / 2.0
        imageView.frame = bounds
    }

    func setup() {
        imageView.contentMode = .scaleAspectFit
        addSubview(imageView)
    }

    func update(image: UIImage?, color: UIColor?) {
        imageView.image = image
        imageView.tintColor = color

        setNeedsLayout()
    }
}
