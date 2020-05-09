import Foundation

struct IntegrateInsuranceResponse: Codable {

    let optionalAutoStartToken: String?
    let scrapeSessionId: UUID

    init(optionalAutoStartToken: String?, scrapeSessionId: UUID) {
        self.optionalAutoStartToken = optionalAutoStartToken
        self.scrapeSessionId = scrapeSessionId
    }
}

