//
//  UICollectionViewCompositionalLayout+extension.swift
//  Holk
//
//  Created by 张梦皓 on 2020-04-20.
//  Copyright © 2020 Holk. All rights reserved.
//

import UIKit

extension UICollectionViewCompositionalLayout {
    static func generateInsuranceLayout() -> UICollectionViewLayout {
        let sections = [generateHintSection(), generateCardSection()]

        let layout = UICollectionViewCompositionalLayout { (sectionIndex, environment) in
            return sections[sectionIndex]
        }
        return layout
    }

    private static func generateHintSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(90))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let hintSection = NSCollectionLayoutSection(group: group)
        hintSection.contentInsets = .init(top: 0, leading: 18, bottom: 0, trailing: 18)
        return hintSection
    }

    private static func generateCardSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(420))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let cardSection = NSCollectionLayoutSection(group: group)
        cardSection.interGroupSpacing = 24
        cardSection.contentInsets = .init(top: 40, leading: 18, bottom: 0, trailing: 18)
        return cardSection
    }
}

