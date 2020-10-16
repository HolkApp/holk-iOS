import Foundation

struct BankIDAuthenticationResponse: Codable {
    let autoStartToken: String
    let orderRef: String
}
