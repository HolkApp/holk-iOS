import Foundation

struct ThinkOfSuggestion: Codable, Hashable {
    struct Details: Codable, Hashable {
        let header: String
        let description: String
        let insuranceInfo: String
        let paragraphs: [Paragraph]
    }

    let title: String
    let subInsurance: String
    let details: Details
}
