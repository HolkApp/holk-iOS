import Foundation

extension AllInsuranceResponse {
    static let mockinsurance: Insurance = {
        return Insurance(
            id: "Mock",
            insuranceProviderName: "testforsakringar",
            kind: .homeInsurance,
            providerReference: "test",
            ssn: "199208253915",
            startDate: Date(),
            endDate: Date(),
            userName: "Mock user name",
            address: "test",
            cost: .init(paymentFrequency: .annual, price: 6000),
            subInsurances: [
                .init(
                    body: "test body",
                    header: "test header",
                    iconUrl: URL(string: "https://storage.googleapis.com/holk_static_content/subinsurance_content/icon/placeholder.png")!,
                    kind: .child)
            ]
        )
    }()
}

struct AllInsuranceResponse: Codable {
    let insuranceList: [Insurance]
    let lastUpdated: Date?
    
    private enum CodingKeys: String, CodingKey {
        case insuranceList = "insuranceList"
        case lastUpdated = "lastScraped"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        insuranceList = try container.decode([Insurance].self, forKey: .insuranceList)
        let lastUpdatedString = try? container.decode(String.self, forKey: .lastUpdated)
        lastUpdated = lastUpdatedString.flatMap { DateFormatter.simpleDateFormatter.date(from: $0)
        }
    }
}
