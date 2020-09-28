import Foundation

struct ThinkOfSuggestion: Codable, Hashable {
    struct Details: Codable, Hashable {
        let header: String
        let description: String
        let paragraphs: [Paragraph]
    }

    let coverPhoto: URL
    let title: String
    let header: String
    let details: Details
    let tags: [SuggestionTag]
}
