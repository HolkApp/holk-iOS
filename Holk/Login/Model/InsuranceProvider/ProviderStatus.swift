import Foundation

struct InsuranceProvider: Codable {
    enum InsuranceIssuerStatus: String, Codable {
        case available = "AVAILABLE"
        case underImplementation = "UNDER_IMPLEMENTATION"
        case notImplemented = "NOT_IMPLEMENTED"
    }

    let description: String?
    let displayName: String
    let status: InsuranceIssuerStatus?
    let internalName: String
    let logoUrl: String
    let symbolUrl: String
    let websiteUrl: String
}
