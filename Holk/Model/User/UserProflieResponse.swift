import Foundation

struct UserProfile: Codable {
    let email: String?
    let fullName: String
    let givenName: String
    let surName: String
    let userId: String
    let personalNumber: String
}
