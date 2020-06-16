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
    let scrapedInsurances: [Insurance]?
}
