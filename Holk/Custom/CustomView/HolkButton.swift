//
//  HolkButton.swift
//  Holk
//
//  Created by 张梦皓 on 2019-08-20.
//  Copyright © 2019 Holk. All rights reserved.
//

import UIKit

final class HolkButton: UIButton {
    override var isEnabled: Bool {
        didSet {
            guard let backgroundColor = backgroundColor, isEnabled != oldValue else { return }
            if isEnabled {
                let alpha = min(backgroundColor.cgColor.alpha / 0.4, 1)
                self.backgroundColor = backgroundColor.withAlphaComponent(alpha)
            } else {
                self.backgroundColor = backgroundColor.withAlphaComponent(backgroundColor.cgColor.alpha * 0.4)
            }
        }
    }

    override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                tintColor = tintColor.withAlphaComponent(0.2)
            } else {
                tintColor = tintColor.withAlphaComponent(1)
            }
        }
    }
    
    func set(color: UIColor, image: UIImage? = nil) {
        setImage(image, for: .normal)
        tintColor = color

        setTitleColor(color, for: .normal)
        setTitleColor(color.withAlphaComponent(0.2), for: .highlighted)
    }
}

