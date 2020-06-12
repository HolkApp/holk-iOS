import Foundation

struct SuggestionsListResponse: Codable {
    let gaps: [Suggestion]
    let thinkOfs: [Suggestion]
}
