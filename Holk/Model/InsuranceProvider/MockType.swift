import Foundation

enum InsuranceProviderType: String, CaseIterable {
    case home = "Home"
    case car = "Car"
    case life = "Life"
    case kids = "Kids"
}

extension InsuranceProviderType {
    static var mockTypeResults: [InsuranceProviderType] {
        [.home, .car, .life, .kids]
    }
    
    var isUpcoming: Bool {
        guard let index = InsuranceProviderType.allCases.firstIndex(of: self) else {
            return true
        }
        return index != 0
    }
}

