//
//  UITableViewCell+extension.swift
//  Holk
//
//  Created by 张梦皓 on 2019-06-15.
//  Copyright © 2019 Holk. All rights reserved.
//

import UIKit

extension UITableViewCell {
    /// Static variable to return the string represantion of the current class
    static var identifier: String {
        return String(describing: self)
    }
}

extension UICollectionViewCell {
    /// Static variable to return the string represantion of the current class
    static var identifier: String {
        return String(describing: self)
    }
}

extension UITableViewHeaderFooterView {
    /// Static variable to return the string represantion of the current class
    static var identifier: String {
        return String(describing: self)
    }
}
