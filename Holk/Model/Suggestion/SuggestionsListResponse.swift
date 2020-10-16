import Foundation

struct SuggestionsListResponse: Codable {
    let gaps: [GapSuggestion]
    let thinkOfs: [ThinkOfSuggestion]
}
