import Foundation

struct ThinkOfSuggestion: Codable {
    struct Details: Codable, Hashable {
        let subHeader: String
        let description: String
    }

    let title: String
    let tag: String
    let details: Details
}
