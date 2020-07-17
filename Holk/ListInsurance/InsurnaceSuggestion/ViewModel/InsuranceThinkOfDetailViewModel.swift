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

    var title: String
    var subInsuranceText: String
    var imageURL: URL?
    var detailHeader: String
    var detailDescription: String
    var detailParagraphs: [Paragraph]
    var mappedInsurance: Insurance?
    var mappedSubInsurances: [Insurance.Segment]

    init(thinkOfSuggestion: ThinkOfSuggestion, insurances: [Insurance]) {
        self.thinkOfSuggestion = thinkOfSuggestion

        title = thinkOfSuggestion.title
        detailHeader = thinkOfSuggestion.details.header
        detailDescription = thinkOfSuggestion.details.description
        detailParagraphs = thinkOfSuggestion.details.paragraphs
        subInsuranceText = thinkOfSuggestion.subInsurance

        // TOOD: Remove the mock
        mappedInsurance = insurances.first { insurnace in
            insurnace.segments.contains { segment in segment.kind == .travel }
        }
        mappedSubInsurances = insurances.flatMap { insurance in
            insurance.segments.filter { segment in segment.kind == .travel }
        }
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

    func makeThinkOfSubInsuranceViewModel(at indexPath: IndexPath) -> ThinkOfSubInsuranceViewModel {
        let subInsurance = mappedSubInsurances[indexPath.item]
        return ThinkOfSubInsuranceViewModel(subInsurance: subInsurance)
    }
}
