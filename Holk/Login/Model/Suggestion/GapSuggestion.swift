import Foundation

struct GapSuggestion: Codable {
    let title: String
    let tag: String
    let details: GapSuggestionDetails
}

struct GapSuggestionDetails: Codable {
    let subHeader: String
    let description: String
    let paragraphs: [GapSuggestionParagraph]
}

struct GapSuggestionParagraph: Codable {
    let icon: String
    let text: String
}
