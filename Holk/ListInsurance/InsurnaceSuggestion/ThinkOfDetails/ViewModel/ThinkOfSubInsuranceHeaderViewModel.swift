//
//  ThinkOfSubInsuranceHeaderViewModel.swift
//  Holk
//
//  Created by 张梦皓 on 2020-07-11.
//  Copyright © 2020 Holk. All rights reserved.
//

import Foundation

struct ThinkOfSubInsuranceHeaderViewModel: Hashable {
    private var insurance: Insurance

    var insuranceName: String?
    var insuranceImageURL: URL?
    var endDate: Date
    var endDateString: String { DateFormatter.yyyyMMddDateFormatter.string(from: endDate) }

    init(insurance: Insurance, provider: InsuranceProvider?) {
        self.insurance = insurance
        insuranceImageURL = provider?.logoUrl
        insuranceName = provider?.displayName
        endDate = insurance.endDate
    }
}
