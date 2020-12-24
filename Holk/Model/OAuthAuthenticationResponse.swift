import Foundation

struct OAuthAuthenticationResponse: Codable {
    let accessToken: String
    let refreshToken: String
    let tokenType: String
    let scope: String
    let jti: String
    let newUser: Bool
    let expiresInSeconds: Int
    
    private enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
        case tokenType = "token_type"
        case scope = "scope"
        case jti = "jti"
        case newUser = "newUser"
        case expiresInSeconds = "expires_in"
    }
}

extension OAuthAuthenticationResponse {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        accessToken = try container.decode(String.self, forKey: .accessToken)
        refreshToken = try container.decode(String.self, forKey: .refreshToken)
        tokenType = try container.decode(String.self, forKey: .tokenType)
        scope = try container.decode(String.self, forKey: .scope)
        jti = try container.decode(String.self, forKey: .jti)
        newUser = (try? container.decode(Bool.self, forKey: .newUser)) ?? false
        expiresInSeconds = try container.decode(Int.self, forKey: .expiresInSeconds)
    }
}
