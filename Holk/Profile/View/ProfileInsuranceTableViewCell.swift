import UIKit

protocol ProfileInsuranceTableViewCellDelegate: AnyObject {
    func refresh(_ profileInsuranceTableViewCell: ProfileInsuranceTableViewCell, insurance: Insurance)
    func delete(_ profileInsuranceTableViewCell: ProfileInsuranceTableViewCell, insurance: Insurance)
}

fileprivate extension ProfileCellType {
    var insurance: Insurance? {
        if case let .insurance(insurance) = self {
            return insurance
        }
        return nil
    }
}

final class ProfileInsuranceTableViewCell: ProfileTableViewCell {
    weak var delegate: ProfileInsuranceTableViewCellDelegate?

    private let refreshButton = HolkButton()
    private let deleteButton = HolkButton()

    private var isExpanded: Bool {
        viewModel?.isExpanded ?? false
    }

    override func setup() {
        super.setup()

        refreshButton.styleGuide = .button1
        refreshButton.setTitle(LocalizedString.Account.refresh, for: .normal)
        refreshButton.set(color: Color.secondaryHighlight, image: UIImage(systemName: "arrow.clockwise")?.withSymbolWeightConfiguration(.semibold))
        refreshButton.addTarget(self, action: #selector(refresh(_:)), for: .touchUpInside)

        deleteButton.styleGuide = .button1
        deleteButton.setTitle(LocalizedString.Account.delete, for: .normal)
        deleteButton.set(color: Color.secondaryHighlight, image: UIImage(systemName: "minus.circle")?.withSymbolWeightConfiguration(.semibold))
        deleteButton.addTarget(self, action: #selector(deleteInsurance(_:)), for: .touchUpInside)

        stackView.addArrangedSubview(refreshButton)
        stackView.addArrangedSubview(deleteButton)

        stackView.isHidden = !isExpanded
        stackViewHeightConstraint?.constant = isExpanded ? 36 : 0
    }

    override func update() {
        super.update()

        stackView.isHidden = !isExpanded
        stackViewHeightConstraint?.constant = isExpanded ? 36 : 0
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        stackView.isHidden = true
        stackViewHeightConstraint?.constant = 0
    }

    @objc private func refresh(_ sender: UIButton) {
        if let insurance = viewModel?.cellType.insurance {
            delegate?.refresh(self, insurance: insurance)
        }
    }

    @objc private func deleteInsurance(_ sender: UIButton) {
        if let insurance = viewModel?.cellType.insurance {
            delegate?.delete(self, insurance: insurance)
        }
    }
}

