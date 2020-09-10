//
//  ThinkOfSubInsuranceViewModel.swift
//  Holk
//
//  Created by 张梦皓 on 2020-07-10.
//  Copyright © 2020 Holk. All rights reserved.
//

import Foundation

struct ThinkOfSubInsuranceViewModel: Hashable {
    var subInsurance: Insurance.SubInsurance
    var kind: Insurance.SubInsurance.Kind
    var text: String

    init(subInsurance: Insurance.SubInsurance) {
        self.subInsurance = subInsurance
        kind = subInsurance.kind
        text = subInsurance.body
    }
}
