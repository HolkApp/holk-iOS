//
//  UICollectionViewCompositionalLayout+extension.swift
//  Holk
//
//  Created by 张梦皓 on 2020-04-20.
//  Copyright © 2020 Holk. All rights reserved.
//

import UIKit

// MARK: - UICollectionViewLayout
extension UICollectionViewCompositionalLayout {
    static func makeInsuranceListLayout() -> UICollectionViewLayout {
        let sections = [makeSuggestionSection(), makeInsuranceListSection()]

        let layout = UICollectionViewCompositionalLayout { (sectionIndex, environment) in
            return sections[sectionIndex]
        }
        return layout
    }

    static func makeInsuranceLayout() -> UICollectionViewLayout {
        let sections = [makeinsuranceSection(), makeInsuranceBeneficiarySection(), makeInsuranceCostSection()]

        let layout = UICollectionViewCompositionalLayout { (sectionIndex, environment) in
            return sections[sectionIndex]
        }
        return layout
    }

    static func makeInsuranceGapsSuggestionLayout() -> UICollectionViewLayout {
        let sections = [makeInsuranceGapsSuggestionSection()]

        let layout = UICollectionViewCompositionalLayout { (sectionIndex, environment) in
            return sections[sectionIndex]
        }
        return layout
    }
}

// MARK: - NSCollectionLayoutSection
extension UICollectionViewCompositionalLayout {
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

    static func makeinsuranceSection() -> NSCollectionLayoutSection {
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

    static func makeInsuranceGapsSuggestionSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 12, leading: 0, bottom: 12, trailing: 0)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(230))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let gapsSection = NSCollectionLayoutSection(group: group)
        gapsSection.boundarySupplementaryItems = [makeinsuranceSuggestionSectionHeaderElement()]
        gapsSection.contentInsets = .init(top: 0, leading: 16, bottom: 0, trailing: 16)
        return gapsSection
    }
}

// MARK: - NSCollectionLayoutBoundarySupplementaryItem
extension UICollectionViewCompositionalLayout {
    static func makeinsuranceSuggestionSectionHeaderElement() -> NSCollectionLayoutBoundarySupplementaryItem {
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(56))
        let headerElement = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: "header", alignment: .top)
        headerElement.contentInsets = .init(top: 0, leading: 16, bottom: 0, trailing: 16)
        return headerElement
    }
}

