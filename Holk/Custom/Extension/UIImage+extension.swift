//
//  UIImage+extension.swift
//  Holk
//
//  Created by 张梦皓 on 2019-06-18.
//  Copyright © 2019 Holk. All rights reserved.
//

import UIKit
import Alamofire

extension UIImage {
    static func imageWith(_ layer: CALayer) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(layer.bounds.size, layer.isOpaque, 0.0)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img
    }

    @discardableResult
    static func imageWithUrl(imageUrlString: String, completion: ((UIImage?) -> Void)? = nil) -> DownloadRequest? {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0] as NSURL
        let newPath = path.appendingPathComponent(imageUrlString)

        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            return (newPath!, [.removePreviousFile, .createIntermediateDirectories])
        }

        do { //Use saved file, if possible
            let data = try Data(contentsOf: newPath!)
            let image = UIImage(data: data)
            completion?(image)
        } catch {
            return Alamofire.download(imageUrlString, to: destination).validate().responseData { response in
                if let data = response.result.value {
                    let image = UIImage(data: data)
                    completion?(image)
                }
            }
        }
        return nil
    }

    func withSymbolWeightConfiguration(_ weight: SymbolWeight, pointSize: CGFloat? = nil) -> UIImage {
        if let pointSize = pointSize {
            return self.withConfiguration(SymbolConfiguration(pointSize: pointSize, weight: weight))
        } else {
            return self.withConfiguration(SymbolConfiguration(weight: weight))
        }
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
