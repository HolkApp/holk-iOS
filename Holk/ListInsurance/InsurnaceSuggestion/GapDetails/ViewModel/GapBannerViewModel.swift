//
//  GapBannerViewModel.swift
//  Holk
//
//  Created by 张梦皓 on 2020-09-10.
//  Copyright © 2020 Holk. All rights reserved.
//

import UIKit

struct GapBannerViewModel: Hashable {
    let icon: UIImage?
    let type: String
    let title: String

    init(gapSuggestion: GapSuggestion) {
        title = gapSuggestion.title
        type = gapSuggestion.type
        icon = UIImage.gap
    }
}
