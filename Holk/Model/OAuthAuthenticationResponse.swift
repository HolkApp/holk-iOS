import Foundation

struct OAuthAuthenticationResponse: Codable {
    let accessToken: String
    let refreshToken: String
    let newUser: Bool?
    let expires: Date
}
