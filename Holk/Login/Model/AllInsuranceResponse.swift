import Foundation

extension AllInsuranceResponse {
    static let mockinsurance: Insurance = {
        let provider = InsuranceProvider(description: "mock provider", displayName: "Folksam", insuranceIssuerStatus: .available, internalName: "Folksam", logoUrl: "", symbolUrl: "", websiteUrl: "")
        return Insurance(id: "Mock", insuranceProvider: provider, insuranceType: "test", providerReference: "test", ssn: "199208253915", startDate: Date(), endDate: Date(), username: "Mock user name")
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

struct Insurance: Codable {
    struct Segment {
        let kind: Kind
        let description: String

        enum Kind: String {
            case travel
            case home
            case pets
        }
    }

    let id: String
    let insuranceProvider: InsuranceProvider
    let insuranceType: String
    let providerReference: String
    let ssn: String
    let startDate: Date
    let endDate: Date
    let username: String
    var address: String {
        "Sveavägen 140"
    }
    var segments: [Segment] {
        return [
            Segment(kind: .home, description: "Decription text for what a subinsurance is about, lore isbm"),
            Segment(kind: .travel, description: "This is travel segment of your home insurance."),
            Segment(kind: .pets, description: "This is pets segment of your home insurance.")
        ]
    }
    
    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case insuranceProvider = "insuranceProvider"
        case insuranceType = "insuranceType"
        case providerReference = "providerReference"
        case startDate = "startDate"
        case endDate = "endDate"
        case ssn = "ssn"
        case username = "taker"
    }
}

extension Insurance {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        insuranceProvider = try container.decode(InsuranceProvider.self, forKey: .insuranceProvider)
        insuranceType = try container.decode(String.self, forKey: .insuranceType)
        providerReference = try container.decode(String.self, forKey: .providerReference)
        let startDateString = try container.decode(String.self, forKey: .startDate)
        startDate = DateFormatter.simpleDateFormatter.date(from: startDateString) ?? Date()
        let endDateString = try container.decode(String.self, forKey: .endDate)
        endDate = DateFormatter.simpleDateFormatter.date(from: endDateString) ?? Date()
        ssn = try container.decode(String.self, forKey: .ssn)
        username = try container.decode(String.self, forKey: .username)
    }
}
