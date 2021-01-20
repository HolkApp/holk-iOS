import UIKit

struct ProfileSectionHeaderViewModel: Equatable {
    let headlineTitle: String?
    let actionTitle: String?
    let section: ProfileSectionViewModel.ProfileSection
    let showIcon: Bool
    let image: UIImage?

    init(headlineTitle: String?, actionTitle: String?, section: ProfileSectionViewModel.ProfileSection, showIcon: Bool = true, image: UIImage? = nil) {
        self.headlineTitle = headlineTitle
        self.actionTitle = actionTitle
        self.section = section
        self.image = image
        self.showIcon = showIcon
    }
}
