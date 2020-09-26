//
//  ThinkOfDetailsViewModel.swift
//  Holk
//
//  Created by 张梦皓 on 2020-07-10.
//  Copyright © 2020 Holk. All rights reserved.
//

import UIKit

final class ThinkOfDetailsViewModel {
    private var storeController: StoreController
    private var thinkOfSuggestion: ThinkOfSuggestion

    let title: String
    let subInsuranceText: String
    // TODO: fix
    private let detailParagraphs: [Paragraph]
    private let mappedInsurance: Insurance?
    private let mappedSubInsurances: [Insurance.SubInsurance]

    // TODO: fix
    var iconImage: UIImage?
    var iconImageBackgroundColor: UIColor?
    var headerBackgroundViewColor: UIColor?

    init(_ storeController: StoreController, thinkOfSuggestion: ThinkOfSuggestion, insurances: [Insurance]) {
        self.storeController = storeController
        self.thinkOfSuggestion = thinkOfSuggestion

        title = thinkOfSuggestion.title
        detailParagraphs = thinkOfSuggestion.details.paragraphs
        subInsuranceText = thinkOfSuggestion.type

        // TOOD: Remove the mock
        mappedInsurance = insurances.first { insurance in
            insurance.subInsurances.contains { segment in segment.kind == .child }
        }
        mappedSubInsurances = mappedInsurance?.subInsurances.filter { subInsurance in
            subInsurance.kind == .child
        } ?? []

        if let subInsurance = mappedSubInsurances.first {
            iconImage = UIImage.init(subInsurance: subInsurance)?.withRenderingMode(.alwaysTemplate)
            iconImageBackgroundColor = Color.iconBackgroundColor(subInsurance)
            headerBackgroundViewColor = Color.backgroundColor(subInsurance)
        }
    }

    func makeThinkOfParagraphHeaderViewModel() -> ThinkOfParagraphHeaderViewModel {
        return ThinkOfParagraphHeaderViewModel(thinkOfSuggestion: thinkOfSuggestion)
    }

    func makeAllThinkOfParagraphViewModel() -> [ThinkOfParagraphViewModel] {
        return detailParagraphs.map(ThinkOfParagraphViewModel.init(paragraph: ))
    }

    func makeThinkOfSubInsuranceHeaderViewModel() -> ThinkOfSubInsuranceHeaderViewModel? {
        guard let mappedInsurance = mappedInsurance else { return nil }
        let providerName = mappedInsurance.insuranceProviderName
        let provider = storeController.providerStore[providerName]
        return ThinkOfSubInsuranceHeaderViewModel(insurance: mappedInsurance, provider: provider)
    }

    func makeAllThinkOfSubInsuranceViewModel() -> [ThinkOfSubInsuranceViewModel] {
        return mappedSubInsurances.map(ThinkOfSubInsuranceViewModel.init(subInsurance: ))
    }
}
