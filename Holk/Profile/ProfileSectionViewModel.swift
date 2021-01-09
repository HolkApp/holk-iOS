import Foundation

class ProfileSectionViewModel {
    let title: String
    let isActionAvailable: Bool
    let actionTitle: String?
    let sectionIndex: Int
    let isExpandable: Bool
    let items: [ProfileCellViewModel]

    var isExpanded = false

    init(title: String, actionTitle: String?, sectionIndex: Int, isExpandable: Bool, items: [ProfileCellViewModel], hasIcon: Bool = false) {
        self.title = title
        self.actionTitle = actionTitle
        self.sectionIndex = sectionIndex
        self.isExpandable = isExpandable
        self.items = items

        self.isActionAvailable = actionTitle != nil
    }
}
