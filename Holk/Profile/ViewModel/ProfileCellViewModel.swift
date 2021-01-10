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
    let cellType: ProfileCellType
    var isExpanded: Bool = false

    convenience init(insurance: Insurance, storeController: StoreController) {
        self.init(
            cellType: .insurance(insurance: insurance),
            title: insurance.insuranceProviderName,
            subtitle: insurance.address,
            accessory: .chevron,
            imageUrl: storeController.providerStore[insurance]?.symbolUrl,
            isExpanded: false
        )
    }

    init(cellType: ProfileCellType, title: String? = nil, subtitle: String? = nil, accessory: ProfileCellAccessory = .none, imageUrl: URL? = nil, isExpanded: Bool = false) {
        self.title = title ?? cellType.title
        self.subtitle = subtitle
        self.accessory = accessory
        self.imageUrl = imageUrl
        self.isExpanded = isExpanded
        self.cellType = cellType
    }
}
