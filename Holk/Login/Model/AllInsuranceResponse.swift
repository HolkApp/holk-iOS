import Foundation

struct AllInsuranceResponse: Codable {
    let homeInsurances: [Insurance]
    let lastUpdated: Date?
    
    private enum CodingKeys: String, CodingKey {
        case homeInsurances = "homeInsuranceList"
        case lastUpdated = "lastScraped"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        homeInsurances = try container.decode([Insurance].self, forKey: .homeInsurances)
        let lastUpdatedString = try? container.decode(String.self, forKey: .lastUpdated)
        lastUpdated = lastUpdatedString.flatMap { DateFormatter.simpleDateFormatter.date(from: $0)
        }
    }
}
