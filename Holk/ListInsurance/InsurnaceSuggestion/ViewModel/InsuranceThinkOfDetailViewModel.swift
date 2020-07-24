//
//  InsuranceThinkOfDetailViewModel.swift
//  Holk
//
//  Created by 张梦皓 on 2020-07-10.
//  Copyright © 2020 Holk. All rights reserved.
//

import UIKit

final class InsuranceThinkOfDetailViewModel {
    private var thinkOfSuggestion: ThinkOfSuggestion

    let title: String
    let subInsuranceText: String
    // TODO: fix
    private let detailParagraphs: [Paragraph]
    private let mappedInsurance: Insurance?
    private let mappedSubInsurances: [Insurance.Segment]

    // TODO: fix
    var iconImage: UIImage?
    var iconImageBackgroundColor: UIColor?
    var headerBackgroundViewColor: UIColor?

    init(thinkOfSuggestion: ThinkOfSuggestion, insurances: [Insurance]) {
        self.thinkOfSuggestion = thinkOfSuggestion

        title = thinkOfSuggestion.title
        detailParagraphs = thinkOfSuggestion.details.paragraphs
        subInsuranceText = thinkOfSuggestion.type

        // TOOD: Remove the mock
        mappedInsurance = insurances.first { insurnace in
            insurnace.segments.contains { segment in segment.kind == .travel }
        }
        mappedSubInsurances = insurances.flatMap { insurance in
            insurance.segments.filter { segment in segment.kind == .travel }
        }

        if let subInsurance = mappedSubInsurances.first {
            switch subInsurance.kind {
            case .home:
                iconImage = UIImage.init(insuranceSegment: subInsurance)
                iconImageBackgroundColor = Color.goodsInsuranceIconBackgroundColor
                headerBackgroundViewColor = Color.goodsInsuranceBackgroundColor
            case .travel:
                iconImage = UIImage.init(insuranceSegment: subInsurance)
                iconImageBackgroundColor = Color.travelInsuranceIconBackgroundColor
                headerBackgroundViewColor = Color.travelInsuranceBackgroundColor
            case .pets:
                iconImage = nil
                iconImageBackgroundColor = .systemPink
                headerBackgroundViewColor = Color.mainHighlight
            }
        }
    }

    func makeThinkOfSuggestionBannerViewModel() -> ThinkOfSuggestionBannerViewModel {
        return ThinkOfSuggestionBannerViewModel(thinkOfSuggestion: thinkOfSuggestion)
    }

    func makeAllThinkOfSuggestionParagraphViewModel() -> [ThinkOfSuggestionParagraphViewModel] {
        return detailParagraphs.map(ThinkOfSuggestionParagraphViewModel.init(paragraph: ))
    }

    private func makeThinkOfSuggestionParagraphViewModel(at index: IndexPath) -> ThinkOfSuggestionParagraphViewModel {
        let paragraph = detailParagraphs[index.item]
        return ThinkOfSuggestionParagraphViewModel(paragraph: paragraph)
    }

    func makeThinkOfInsuranceViewModel() -> ThinkOfInsuranceViewModel? {
        return mappedInsurance.map(ThinkOfInsuranceViewModel.init(insurance: ))
    }

    func makeAllThinkOfSubInsuranceViewModel() -> [ThinkOfSubInsuranceViewModel] {
        return mappedSubInsurances.map(ThinkOfSubInsuranceViewModel.init(subInsurance: ))
    }

    private func makeThinkOfSubInsuranceViewModel(at indexPath: IndexPath) -> ThinkOfSubInsuranceViewModel {
        let subInsurance = mappedSubInsurances[indexPath.item]
        return ThinkOfSubInsuranceViewModel(subInsurance: subInsurance)
    }
}
