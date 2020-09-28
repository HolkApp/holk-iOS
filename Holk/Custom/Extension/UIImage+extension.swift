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

    @discardableResult
    static func makeImage(with imageUrl: URL?, completion: ((UIImage?) -> Void)? = nil) -> DownloadRequest? {
        guard let imageUrl = imageUrl else {
            completion?(nil)
            return nil
        }
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
                throw CocoaError(.fileNoSuchFile)
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
    convenience init?(subInsurance: Insurance.SubInsurance) {
        switch subInsurance.kind {
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
    
}
