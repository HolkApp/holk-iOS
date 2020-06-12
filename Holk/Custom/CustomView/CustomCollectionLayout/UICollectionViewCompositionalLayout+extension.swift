//
//  UICollectionViewCompositionalLayout+extension.swift
//  Holk
//
//  Created by 张梦皓 on 2020-04-20.
//  Copyright © 2020 Holk. All rights reserved.
//

import UIKit

extension UICollectionViewCompositionalLayout {
    static func makeInsuranceListLayout() -> UICollectionViewLayout {
        let sections = [makeSuggestionSection(), makeInsuranceListSection()]

        let layout = UICollectionViewCompositionalLayout { (sectionIndex, environment) in
            return sections[sectionIndex]
        }
        return layout
    }

    static func makeInsuranceLayout() -> UICollectionViewLayout {
        let sections = [makeInsurnaceSection(), makeInsuranceBeneficiarySection(), makeInsuranceCostSection()]

        let layout = UICollectionViewCompositionalLayout { (sectionIndex, environment) in
            return sections[sectionIndex]
        }
        return layout
    }

    static func makeOnboardingViewSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let suggestionSection = NSCollectionLayoutSection(group: group)
        suggestionSection.orthogonalScrollingBehavior = .groupPaging
        return suggestionSection
    }

    static func makeSuggestionSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(80))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let suggestionSection = NSCollectionLayoutSection(group: group)
        suggestionSection.contentInsets = .init(top: 0, leading: 16, bottom: 0, trailing: 16)
        return suggestionSection
    }

    static func makeInsuranceListSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(366))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let cardSection = NSCollectionLayoutSection(group: group)
        cardSection.interGroupSpacing = 24
        cardSection.contentInsets = .init(top: 12, leading: 16, bottom: 0, trailing: 16)
        return cardSection
    }

    static func makeInsurnaceSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(420))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let cardSection = NSCollectionLayoutSection(group: group)
        cardSection.interGroupSpacing = 24
        cardSection.contentInsets = .init(top: 12, leading: 16, bottom: 0, trailing: 16)
        return cardSection
    }

    static func makeInsuranceBeneficiarySection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(128))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let beneficiarySection = NSCollectionLayoutSection(group: group)
        beneficiarySection.contentInsets = .init(top: 48, leading: 16, bottom: 0, trailing: 16)
        return beneficiarySection
    }

    static func makeInsuranceCostSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(100))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let costSection = NSCollectionLayoutSection(group: group)
        costSection.contentInsets = .init(top: 0, leading: 16, bottom: 0, trailing: 16)
        return costSection
    }
}

