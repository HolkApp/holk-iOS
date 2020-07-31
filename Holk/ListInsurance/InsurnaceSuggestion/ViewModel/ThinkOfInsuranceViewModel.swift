//
//  ThinkOfInsuranceViewModel.swift
//  Holk
//
//  Created by 张梦皓 on 2020-07-11.
//  Copyright © 2020 Holk. All rights reserved.
//

import Foundation

struct ThinkOfInsuranceViewModel: Hashable {
    private var insurance: Insurance

    var insuranceKind: Insurance.Kind
    var insuranceName: String?
    var insuranceImageURL: URL?
    var endDate: Date
    var endDateString: String { DateFormatter.yyyyMMddDateFormatter.string(from: endDate) }

    init(insurance: Insurance, provider: InsuranceProvider?) {
        self.insurance = insurance
        insuranceKind = insurance.kind
        insuranceImageURL = provider?.logoUrl
        insuranceName = provider?.displayName
        endDate = insurance.endDate
    }
}
