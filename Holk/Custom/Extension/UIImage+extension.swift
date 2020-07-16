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
    static func makeImageWithLayer(_ layer: CALayer) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(layer.bounds.size, layer.isOpaque, 0.0)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img
    }

    @discardableResult
    static func makeImage(_ imageUrl: URL, completion: ((UIImage?) -> Void)? = nil) -> DownloadRequest? {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0] as NSURL
        let newPath = path.appendingPathComponent(imageUrl.absoluteString)

        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            return (newPath!, [.removePreviousFile, .createIntermediateDirectories])
        }

        do { //Use saved file, if possible
            let data = try Data(contentsOf: newPath!)
            if let image = UIImage(data: data) {
                completion?(image)
            } else {
                throw CocoaError(.coderInvalidValue)
            }
        } catch {
            return Alamofire.download(imageUrl, to: destination).validate().responseData { response in
                if let data = response.result.value {
                    let image = UIImage(data: data)
                    completion?(image)
                } else {
                    completion?(nil)
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

// MARK: - SubInsurance Image extension
extension UIImage {
    convenience init?(insuranceSegment: Insurance.Segment) {
        switch insuranceSegment.kind {
        case .travel: self.init(named: "travel")
        case .home:  self.init(named: "goods")
        case .pets: self.init(named: "Shoe")
        }
    }
}
