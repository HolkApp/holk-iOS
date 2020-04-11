//
//  FloatingPoint+extension.swift
//  Holk
//
//  Created by 张梦皓 on 2020-03-07.
//  Copyright © 2020 Holk. All rights reserved.
//

import UIKit

extension FloatingPoint {
    /// Linear interpolation
    /// 0.5.lerped(a: 10, b: 20) // 15
    ///
    /// - Parameters:
    ///   - a: lower value
    ///   - b: upper value
    /// - Returns: lerped floating point
    func lerped(a: Self, b: Self) -> Self {
        return (a + (b - a) * self)
    }

    /// Degress to radians
    ///
    /// - Returns: Radian floating value
    func degreesToRadians() -> Self {
        return self / Self(180) * .pi
    }

    /// Radians to degrees
    ///
    /// - Returns: Degrees floating point
    func radiansToDegress() -> Self {
        return self * Self(180) / .pi
    }
}

extension Comparable {
    func clamped(min lower: Self, max upper: Self) -> Self {
        return min(max(self, lower), upper)
    }
}

extension CGPoint {
    func distance(to point: CGPoint) -> CGFloat {
        return sqrt(pow(self.x - point.x, 2) + pow(self.y - point.y, 2))
    }
}
