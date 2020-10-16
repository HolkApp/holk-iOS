import Foundation

struct UserInfoResponse: Codable {
    let email: String?
    let fullName: String
    let givenName: String
    let surName: String
    let userId: String
    let personalNumber: String
}
