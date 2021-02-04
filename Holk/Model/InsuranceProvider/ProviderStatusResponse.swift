import Foundation

struct ProviderStatusResponse: Codable {
    let providerStatusList: [InsuranceProvider]

    init(providerStatusList: [InsuranceProvider]) {
        self.providerStatusList = providerStatusList
    }

}
