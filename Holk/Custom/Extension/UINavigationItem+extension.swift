//
//  UINavigationItem+extension.swift
//  Holk
//
//  Created by 张梦皓 on 2020-07-16.
//  Copyright © 2020 Holk. All rights reserved.
//

import UIKit

extension UINavigationItem {
    func setAppearance(backgroundColor: UIColor = .clear, foregroundColor: UIColor = Color.mainForeground) {
        let standard = UINavigationBarAppearance()

        standard.configureWithOpaqueBackground()

        standard.backgroundColor = backgroundColor
        standard.shadowImage = UIImage()
        standard.shadowColor = .clear

        let backIndicatorImage = UIImage(systemName: "chevron.left")?.withSymbolWeightConfiguration(.regular, pointSize: 30).withAlignmentRectInsets(.init(top: 0, left: -16, bottom: 0, right: 0))

        standard.setBackIndicatorImage(backIndicatorImage, transitionMaskImage: backIndicatorImage)

        let largeTitleFont = FontStyleGuide.header4.font
        let style = NSMutableParagraphStyle()
            style.alignment = .justified
            style.firstLineHeadIndent = 8
        standard.largeTitleTextAttributes = [
            .font: largeTitleFont,
            .foregroundColor: foregroundColor,
            .paragraphStyle: style
        ]
        let titleFont = FontStyleGuide.titleHeader2.font
        standard.titleTextAttributes = [
            .font: titleFont,
            .foregroundColor: foregroundColor
        ]

        let button = UIBarButtonItemAppearance(style: .plain)

        button.normal.titleTextAttributes = [.foregroundColor: UIColor.clear]
        button.normal.titlePositionAdjustment = .init(horizontal: 0, vertical: -4)
        standard.backButtonAppearance = button

        standardAppearance = standard
    }

    var hasTransparentAppearance: Bool { (standardAppearance?.titleTextAttributes[.foregroundColor] as? UIColor) == UIColor.clear }
}
