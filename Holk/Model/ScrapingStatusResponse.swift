import Foundation

struct ScrapingStatusResponse: Codable {

    enum ScrapingStatus: String, Codable {
        case uninitiated = "UNINITIATED"
        case initiated = "INITIATED"
        case loggedIn = "LOGGED_IN"
        case completed = "COMPLETED"
        case failed = "FAILED"
    }

    let scrapingStatus: ScrapingStatus
    let aggregatedInsurances: [Insurance.ID]?

    private enum CodingKeys: String, CodingKey {
        case scrapingStatus = "scrapingStatus"
        case aggregatedInsurances = "scrapedInsurances"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        scrapingStatus = try container.decode(ScrapingStatus.self, forKey: .scrapingStatus)
        let insuranceIDs = try? container.decode([String].self, forKey: .aggregatedInsurances)
        aggregatedInsurances = insuranceIDs?.compactMap({ Insurance.ID($0) })
    }
}
