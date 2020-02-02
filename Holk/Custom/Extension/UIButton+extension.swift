//
//  UIButton+extension.swift
//  Holk
//
//  Created by 张梦皓 on 2020-02-02.
//  Copyright © 2020 Holk. All rights reserved.
//

import UIKit

extension UIButton {
    func imageToTheRightOfText(padding: CGFloat = 20) {
        transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        titleLabel!.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        imageView!.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: padding)
    }
}

