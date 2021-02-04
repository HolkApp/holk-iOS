import Foundation

struct InsuranceProvider: Codable, Hashable {
    enum Status: String, Codable {
        case available = "AVAILABLE"
        case underImplementation = "UNDER_IMPLEMENTATION"
        case notImplemented = "NOT_IMPLEMENTED"
    }

    let displayName: String
    let status: Status?
    let internalName: String
    let logoUrl: URL
    let symbolUrl: URL
    let websiteUrl: URL
}
