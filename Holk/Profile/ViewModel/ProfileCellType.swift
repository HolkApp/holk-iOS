import Foundation

enum ProfileCellType {
    case expandable(title: String)
    case insurance(insurance: Insurance)
//    case theme
//    case language
    case deleteAccount
    case logout

    var title: String {
        switch self {
        case .expandable(let title):
            return title
        case .insurance(let insurance):
            return insurance.insuranceProviderName
        case .deleteAccount:
            return LocalizedString.Account.delete
        case .logout:
            return LocalizedString.Account.logout
        }
    }
}
