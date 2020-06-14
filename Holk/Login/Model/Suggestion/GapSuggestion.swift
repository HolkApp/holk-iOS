import Foundation

struct GapSuggestion: Codable, Hashable {
    struct Details: Codable, Hashable {
        struct Paragraph: Codable, Hashable {
            let icon: String
            let text: String
        }

        let subHeader: String
        let description: String
        let paragraphs: [Paragraph]
    }

    let title: String
    let tag: String
    let details: Details
}
