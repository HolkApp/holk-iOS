//
//  GapParagraphViewModel.swift
//  Holk
//
//  Created by 张梦皓 on 2020-09-10.
//  Copyright © 2020 Holk. All rights reserved.
//

import UIKit

struct GapParagraphViewModel: Hashable {
    let icon: String
    let title: String
    let text: String

    init(paragraph: Paragraph) {
        self.icon = paragraph.icon
        self.text = paragraph.text
        self.title = paragraph.title ?? ""
    }
}
