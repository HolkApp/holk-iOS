//
//  UIImage+extension.swift
//  Holk
//
//  Created by 张梦皓 on 2019-06-18.
//  Copyright © 2019 Holk. All rights reserved.
//

import UIKit

extension UIImage {
    func withSymbolWeightConfiguration(_ weight: SymbolWeight) -> UIImage {
        return self.withConfiguration(SymbolConfiguration(weight: weight))
    }
    
    class func imageWith(_ layer: CALayer) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(layer.bounds.size, layer.isOpaque, 0.0)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img
    }
}

extension UIImage {
    convenience init?(insuranceSegment: Insurance.Segment) {
        switch insuranceSegment.kind {
        case .travel: self.init(named: "Plane")
        case .home:  self.init(named: "Heart")
        case .pets: self.init(named: "Shoe")
        }
    }
}
