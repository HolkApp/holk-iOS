import Foundation

class ProfileSectionViewModel {

    enum ProfileSection {
        case insurance
        case account
    }

    let title: String
    let isActionAvailable: Bool
    let actionTitle: String?
    let section: ProfileSection
    let isExpandable: Bool
    let items: [ProfileCellViewModel]
    let headerViewModel: ProfileSectionHeaderViewModel

    var isExpanded = false

    init(title: String, actionTitle: String? = nil, section: ProfileSection, isExpandable: Bool, items: [ProfileCellViewModel], hasIcon: Bool = false) {
        self.title = title
        self.actionTitle = actionTitle
        self.section = section
        self.isExpandable = isExpandable
        self.items = items
        headerViewModel = ProfileSectionHeaderViewModel(headlineTitle: title, actionTitle: actionTitle, section: section)

        self.isActionAvailable = actionTitle != nil
    }
}
