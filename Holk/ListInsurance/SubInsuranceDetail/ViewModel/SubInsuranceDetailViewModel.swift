//
//  SubInsuranceDetailViewModel.swift
//  Holk
//
//  Created by 张梦皓 on 2020-11-06.
//  Copyright © 2020 Holk. All rights reserved.
//

import Foundation

final class SubInsuranceDetailViewModel {
    enum SelectedSubInsuranceDetails {
        case cover
        case gaps
        case thinkOfs
    }

    let subInsurance: Insurance.SubInsurance
    let storeController: StoreController
    var selectedSubInsuranceDetails: SelectedSubInsuranceDetails {
        get {
            subInsuranceDetailsHeaderViewModel.selectedSubInsuranceDetails
        }
        set {
            subInsuranceDetailsHeaderViewModel.selectedSubInsuranceDetails = newValue
        }
    }
    lazy var groupedItems: [Insurance.SubInsurance.Item.Segment: [Insurance.SubInsurance.Item]] = {
        return Dictionary(grouping: self.subInsurance.items, by: \.segment)
    }()

    let thinkOfs: [ThinkOfSuggestion]

    let subInsuranceDetailsHeaderViewModel: SubInsuranceDetailsHeaderViewModel
    let subInsuranceDetailsItemViewModels: [SubInsuranceDetailsItemViewModel]

    var segments: [Insurance.SubInsurance.Item.Segment] {
        groupedItems.map(\.key).sorted()
    }

    init(storeController: StoreController, subInsurance: Insurance.SubInsurance) {
        self.subInsurance = subInsurance
        self.storeController = storeController
        thinkOfs = storeController.suggestionStore.thinkOfs(subInsurance)
        subInsuranceDetailsHeaderViewModel = SubInsuranceDetailsHeaderViewModel(subInsurance: subInsurance)
        subInsuranceDetailsItemViewModels = subInsurance.items.map(SubInsuranceDetailsItemViewModel.init(item: ))
    }
}
