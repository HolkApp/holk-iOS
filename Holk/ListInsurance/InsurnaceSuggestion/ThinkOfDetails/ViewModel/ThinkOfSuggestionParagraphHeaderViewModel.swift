//
//  ThinkOfSuggestionParagraphHeaderViewModel.swift
//  Holk
//
//  Created by 张梦皓 on 2020-07-19.
//  Copyright © 2020 Holk. All rights reserved.
//

import Foundation

struct ThinkOfSuggestionParagraphHeaderViewModel: Hashable {
    let detailHeader: String
    let detailDescription: String

    init(thinkOfSuggestion: ThinkOfSuggestion) {
        detailHeader = thinkOfSuggestion.details.header
        detailDescription = thinkOfSuggestion.details.description
    }
}
