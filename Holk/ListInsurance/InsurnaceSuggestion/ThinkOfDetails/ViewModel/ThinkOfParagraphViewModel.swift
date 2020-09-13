//
//  ThinkOfParagraphViewModel.swift
//  Holk
//
//  Created by 张梦皓 on 2020-07-10.
//  Copyright © 2020 Holk. All rights reserved.
//

import Foundation

struct ThinkOfParagraphViewModel: Hashable {
    private var paragraph: Paragraph
    var icon: String
    var text: String

    init(paragraph: Paragraph) {
        self.paragraph = paragraph
        self.icon = paragraph.icon
        self.text = paragraph.text
    }
}
