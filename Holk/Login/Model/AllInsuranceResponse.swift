import Foundation

extension AllInsuranceResponse {
    static let mockinsurance: Insurance = {
        let provider = InsuranceProvider(description: "mock provider", displayName: "Folksam", status: .available, internalName: "Folksam", logoUrl: URL(string: "test://")!, symbolUrl: URL(string: "test://")!, websiteUrl: URL(string: "test://")!)
        return Insurance(id: "Mock", insuranceProvider: provider, kind: .homeInsurnace, providerReference: "test", ssn: "199208253915", startDate: Date(), endDate: Date(), username: "Mock user name")
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
        lastUpdated = try? container.decode(Date.self, forKey: .lastUpdated)
//        lastUpdated = lastUpdatedString.flatMap { DateFormatter.yyyyMMddDateFormatter.date(from: $0)
//        }
    }
}
