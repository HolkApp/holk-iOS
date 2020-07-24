import Foundation

struct GapSuggestion: Codable, Hashable {
    struct Details: Codable, Hashable {
        let header: String
        let description: String
        let paragraphs: [Paragraph]
    }

    let title: String
    let type: String
    let details: Details
}
