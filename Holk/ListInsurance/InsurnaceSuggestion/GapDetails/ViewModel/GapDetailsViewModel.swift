//
//  GapDetailsViewModel.swift
//  Holk
//
//  Created by 张梦皓 on 2020-09-10.
//  Copyright © 2020 Holk. All rights reserved.
//

import UIKit

struct GapDetailsViewModel: Hashable {
    private var gapSuggestion: GapSuggestion

    let title: String
    private let detailParagraphs: [Paragraph]

    // TODO: fix
    var iconImage: UIImage?
    var headerBackgroundViewColor: UIColor?

    init(_ gapSuggestion: GapSuggestion) {
        self.gapSuggestion = gapSuggestion

        title = gapSuggestion.title
        detailParagraphs = gapSuggestion.details.paragraphs
        headerBackgroundViewColor = Color.mainForeground
    }

    func makeGapBannerViewModel() -> GapBannerViewModel {
        return GapBannerViewModel(gapSuggestion: gapSuggestion)
    }

    func makeGapParagraphHeaderViewModel() -> GapParagraphHeaderViewModel {
        return GapParagraphHeaderViewModel(gapSuggestion: gapSuggestion)
    }

    func makeAllGapParagraphViewModel() -> [GapParagraphViewModel] {
        return detailParagraphs.map(GapParagraphViewModel.init(paragraph: ))
    }
}
