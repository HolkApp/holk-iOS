import Foundation

struct ThinkOfSuggestion: Codable {
    struct Details: Codable, Hashable {
        let subHeader: String
        let description: String
        let insuranceInfo: String
        let paragraphs: [Paragraph]
    }

    let title: String
    let insuranceIcon: String
    let insuranceTitle: String
    let details: Details
}
