import Foundation

struct UserProfile: Codable {
    let email: String?
    let name: String
    let givenName: String
    let surname: String
    let id: UUID
    let personalNumber: String
}
