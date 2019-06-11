//
//  Then.swift
//  Holk
//
//  Created by 张梦皓 on 2019-06-04.
//  Copyright © 2019 Holk. All rights reserved.
//

import UIKit

protocol Then {}

extension Then where Self: AnyObject {
    
    func then(_ block: (Self) -> Void) -> Self {
        block(self)
        return self
    }
}

extension NSObject: Then { }
