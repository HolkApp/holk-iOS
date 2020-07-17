//
//  UINavigationItem+extension.swift
//  Holk
//
//  Created by 张梦皓 on 2020-07-16.
//  Copyright © 2020 Holk. All rights reserved.
//

import UIKit

extension UINavigationItem {
    func setAppearance(backgroundColor: UIColor) {
        let standard = UINavigationBarAppearance()

        standard.configureWithOpaqueBackground()

        standard.backgroundColor = backgroundColor
        standard.shadowImage = UIImage()
        standard.shadowColor = .clear

        standard.setBackIndicatorImage(UIImage(systemName: "chevron.left")?.withSymbolWeightConfiguration(.regular, pointSize: 30), transitionMaskImage: UIImage(systemName: "chevron.left")?.withSymbolWeightConfiguration(.regular, pointSize: 30))

        let largeTitleFont = Font.font(name: .poppins, weight: .semiBold, size: 30)
        standard.largeTitleTextAttributes = [
            .font: largeTitleFont,
            .foregroundColor: Color.mainForeground
        ]
        let titleFont = Font.font(name: .poppins, weight: .semiBold, size: 20)
        standard.titleTextAttributes = [
            .font: titleFont,
            .foregroundColor: Color.mainForeground
        ]

        let button = UIBarButtonItemAppearance(style: .plain)

        button.normal.titleTextAttributes = [.foregroundColor: backgroundColor]
        button.normal.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -10)
        standard.backButtonAppearance = button

        standardAppearance = standard
    }
}
