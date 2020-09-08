//
//  FeatureFlags.swift
//  Holk
//
//  Created by 张梦皓 on 2020-09-05.
//  Copyright © 2020 Holk. All rights reserved.
//

import Foundation

// TODO: Use ProcessInfo.processInfo.environment to get flag

var demoMode: Bool {
    #if DEBUG || STAGING
    return true
    #else
    return false
    #endif
}
