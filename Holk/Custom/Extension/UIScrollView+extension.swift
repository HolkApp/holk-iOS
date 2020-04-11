//
//  UIScrollView+extension.swift
//  Holk
//
//  Created by 张梦皓 on 2020-04-10.
//  Copyright © 2020 Holk. All rights reserved.
//

import UIKit

extension UIScrollView {
    /// The offset derived from the adjustments content insets and safe area of the scroll view. Is `CGPoint.zero` when scrolled to top.
    public var adjustedContentOffset: CGPoint {
        get {
            return CGPoint(x: contentOffset.x + adjustedContentInset.left, y: contentOffset.y + adjustedContentInset.top)
        }
        set {
            contentOffset = CGPoint(x: newValue.x - adjustedContentInset.left, y: newValue.y - adjustedContentInset.top)
        }
    }
}
import Foundation
