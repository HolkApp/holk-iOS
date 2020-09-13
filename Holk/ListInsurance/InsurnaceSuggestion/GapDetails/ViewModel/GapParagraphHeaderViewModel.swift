//
//  GapParagraphHeaderViewModel.swift
//  Holk
//
//  Created by 张梦皓 on 2020-09-10.
//  Copyright © 2020 Holk. All rights reserved.
//

import UIKit

struct GapParagraphHeaderViewModel: Hashable {
    let header: String
    let description: String
    let paragraphHeader: String

    init(gapSuggestion: GapSuggestion) {
        header = gapSuggestion.details.header
        paragraphHeader = gapSuggestion.details.title
        description = gapSuggestion.details.description
    }
}
