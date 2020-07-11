//
//  ThinkOfSubInsuranceViewModel.swift
//  Holk
//
//  Created by 张梦皓 on 2020-07-10.
//  Copyright © 2020 Holk. All rights reserved.
//

import Foundation

struct ThinkOfSubInsuranceViewModel: Hashable {
    private var subInsurance: Insurance.Segment
    var kind: Insurance.Segment.Kind
    var text: String

    init(subInsurance: Insurance.Segment) {
        self.subInsurance = subInsurance
        kind = subInsurance.kind
        text = subInsurance.description
    }
}
