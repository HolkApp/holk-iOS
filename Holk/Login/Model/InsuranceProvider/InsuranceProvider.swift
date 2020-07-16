import Foundation

struct InsuranceProvider: Codable, Hashable {
    enum InsuranceIssuerStatus: String, Codable {
        case available = "AVAILABLE"
        case underImplementation = "UNDER_IMPLEMENTATION"
        case notImplemented = "NOT_IMPLEMENTED"
    }

    let description: String?
    let displayName: String
    let status: InsuranceIssuerStatus?
    let internalName: String
    let logoUrl: URL
    let symbolUrl: URL
    let websiteUrl: URL
}
