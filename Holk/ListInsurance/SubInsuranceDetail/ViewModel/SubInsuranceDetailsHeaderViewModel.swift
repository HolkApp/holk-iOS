//
//  SubInsuranceDetailsHeaderViewModel.swift
//  Holk
//
//  Created by 张梦皓 on 2020-11-06.
//  Copyright © 2020 Holk. All rights reserved.
//

import Foundation

final class SubInsuranceDetailsHeaderViewModel {
    let subInsurance: Insurance.SubInsurance
    let title: String
    let subtitle: String
    var selectedSubInsuranceDetails: SubInsuranceDetailViewModel.SelectedSubInsuranceDetails = .cover

    init(subInsurance: Insurance.SubInsurance) {
        self.subInsurance = subInsurance
        title = subInsurance.title
        subtitle = LocalizedString.Insurance.homeInsurance
    }
}
