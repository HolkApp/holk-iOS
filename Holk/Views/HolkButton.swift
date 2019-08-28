//
//  HolkButton.swift
//  Holk
//
//  Created by 张梦皓 on 2019-08-20.
//  Copyright © 2019 Holk. All rights reserved.
//

import UIKit

class HolkButton: UIButton {
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
}

