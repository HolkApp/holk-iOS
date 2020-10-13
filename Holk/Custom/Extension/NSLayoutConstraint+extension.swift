//
//  NSLayoutConstraint+extension.swift
//  Holk
//
//  Created by 张梦皓 on 2020-10-13.
//  Copyright © 2020 Holk. All rights reserved.
//

import UIKit

extension NSLayoutConstraint {
    func withPriority(_ priority: UILayoutPriority) -> NSLayoutConstraint {
        self.priority = priority
        return self
    }
}
