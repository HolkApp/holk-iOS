//
//  UIImage+extension.swift
//  Holk
//
//  Created by 张梦皓 on 2019-06-18.
//  Copyright © 2019 Holk. All rights reserved.
//

import UIKit

extension UIImage {
    convenience init?(layer: CALayer) {
        UIGraphicsBeginImageContextWithOptions(layer.bounds.size, layer.isOpaque, 0.0)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }

    convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }

    func withSymbolWeightConfiguration(_ weight: SymbolWeight, pointSize: CGFloat? = nil) -> UIImage {
        if let pointSize = pointSize {
            return self.withConfiguration(SymbolConfiguration(pointSize: pointSize, weight: weight))
        } else {
            return self.withConfiguration(SymbolConfiguration(weight: weight))
        }
    }
}

// MARK: - SubInsurance Image extension
extension UIImage {
    convenience init?(subInsuranceKind: Insurance.SubInsurance.Kind) {
        switch subInsuranceKind {
        case .movables: self.init(named: "movables")
        case .travel: self.init(named: "travel")
        case .liability: self.init(named: "liability")
        case .legal: self.init(named: "legal")
        case .assault: self.init(named: "assault")
        default: self.init(named: "travel")
        }
    }
}

// MARK: - Suggestion Image extension
extension UIImage {
    convenience init?(thinkOf: ThinkOfSuggestion) {
        guard let subInsuranceKind = thinkOf.tags.first(where: { $0.key == .subInsurance })?.value, let kind = Insurance.SubInsurance.Kind(rawValue: subInsuranceKind) else {
            return nil
        }
        self.init(subInsuranceKind: kind)
    }
}
