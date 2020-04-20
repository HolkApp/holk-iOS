//
//  HolkFloatingCardView.swift
//  Holk
//
//  Created by 张梦皓 on 2020-04-19.
//  Copyright © 2020 Holk. All rights reserved.
//

import UIKit

final class HolkFloatingCardView: UIControl {
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
            let scaleTransform = isHighlighted ? CGAffineTransform(scaleX: 0.95, y: 0.95) : .identity
            let animator = UIViewPropertyAnimator(duration: 0.1, curve: .easeInOut) {
                self.transform = scaleTransform
            }
            animator.startAnimation()
        }
    }
}
