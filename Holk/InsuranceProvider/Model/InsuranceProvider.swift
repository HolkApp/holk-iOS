//
//  InsuranceProvider.swift
//  Holk
//
//  Created by 张梦皓 on 2019-09-29.
//  Copyright © 2019 Holk. All rights reserved.
//

import Foundation

struct InsuranceProvider {
    let name: String
    let displayName: String
    let id: String
    let types: [InsuranceProviderType]
}

extension InsuranceProvider {
    static var mockInsuranceProviderResults: [InsuranceProvider] {
        [
            InsuranceProvider(name: "If", displayName: "If", id: "1", types: [.home, .car, .kids]),
            InsuranceProvider(name: "Folksam", displayName: "Folksam", id: "2", types: [.home, .car, .life]),
            InsuranceProvider(name: "TryggHansa", displayName: "Trygg Hansa", id: "3", types: [.home, .car, .life, .kids]),
            InsuranceProvider(name: "länsförsäkringar", displayName: "länsförsäkringar", id: "4", types: [.home, .car])
        ]
    }
}
