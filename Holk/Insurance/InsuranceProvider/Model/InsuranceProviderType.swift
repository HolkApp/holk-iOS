//
//  InsuranceProviderType.swift
//  Holk
//
//  Created by 张梦皓 on 2019-09-29.
//  Copyright © 2019 Holk. All rights reserved.
//

import Foundation

enum InsuranceProviderType: String, CaseIterable {
    case home = "Home"
    case car = "Car"
    case life = "Life"
    case kids = "Kids"
}

extension InsuranceProviderType {
    static var mockTypeResults: [InsuranceProviderType] {
        [.home, .car, .life, .kids]
    }
}
