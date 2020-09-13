//
//  GapParagraphHeaderViewModel.swift
//  Holk
//
//  Created by 张梦皓 on 2020-09-10.
//  Copyright © 2020 Holk. All rights reserved.
//

import UIKit

struct GapParagraphHeaderViewModel: Hashable {
    let title: String
    let description: String
    let paragraphHeader: String

    init(gapSuggestion: GapSuggestion) {
        title = "Din Lucka"
        paragraphHeader = gapSuggestion.details.header
        description = "Om du skadar dig på väg till jobbet eller när du åker Voi eller ute med kompisar och råkar ut för en olycka, får du ingen ekonomisk ersättning. Skyddet kallas oftast för Olycksfallsförsäkring."
//        description = gapSuggestion.details.description
    }
}
