//
//  ProfileViewModel.swift
//  Holk
//
//  Created by 张梦皓 on 2021-01-06.
//  Copyright © 2021 Holk. All rights reserved.
//

import Foundation

enum ProfileCellAccessory {
    case none
    case chevron
    case expand
}

class ProfileCellViewModel {
    let title: String
    let subtitle: String?
    let accessory: ProfileCellAccessory
    let imageUrl: URL?
    var isExpanded: Bool = false

    convenience init(title: String, subtitle: String? = nil, description: String? = nil, accessory: ProfileCellAccessory = .chevron) {
        self.init(title: title, subtitle: subtitle, accessory: accessory, imageUrl: nil, isExpanded: false)
    }

    init(title: String, subtitle: String?, accessory: ProfileCellAccessory, imageUrl: URL?, isExpanded: Bool = false) {
        self.title = title
        self.subtitle = subtitle
        self.accessory = accessory
        self.imageUrl = imageUrl
        self.isExpanded = isExpanded
    }
}
