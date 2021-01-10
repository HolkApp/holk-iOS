import UIKit

protocol ProfileSectionHeaderViewDelegate: AnyObject {
    func profileSectionHeaderView(_ view: ProfileSectionHeaderView, didPressActionWithViewModel viewModel: ProfileSectionHeaderViewModel)
}

final class ProfileSectionHeaderView: UITableViewHeaderFooterView {

    let headlineLabel = HolkLabel()
    private let actionButton = HolkButton()
    private let imageView = UIImageView()

    private var labelLeadingConstraint: NSLayoutConstraint!

    static var height: CGFloat = 60

    var viewModel: ProfileSectionHeaderViewModel? {
        didSet {
            update()
        }
    }

    weak var delegate: ProfileSectionHeaderViewDelegate?

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)

        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        headlineLabel.text = nil
        actionButton.setTitle(nil, for: .normal)
    }
}

private extension ProfileSectionHeaderView {
    func setup() {
        contentView.backgroundColor = Color.mainBackground
        
        headlineLabel.translatesAutoresizingMaskIntoConstraints = false
        headlineLabel.styleGuide = .titleHeader2
        headlineLabel.textColor = Color.label
        headlineLabel.setContentHuggingPriority(UILayoutPriority(rawValue: 250), for: .horizontal)

        actionButton.translatesAutoresizingMaskIntoConstraints = false
        actionButton.styleGuide = .titleHeader2
        actionButton.set(color: Color.label)
        actionButton.setContentHuggingPriority(UILayoutPriority(rawValue: 251), for: .horizontal)
        actionButton.setContentCompressionResistancePriority(.required, for: .horizontal)
        actionButton.addTarget(self, action: #selector(didPressActionButton(_:)), for: .touchUpInside)

        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit

        contentView.addSubview(headlineLabel)
        contentView.addSubview(actionButton)
        contentView.addSubview(imageView)

        let labelLeadingConstraint = headlineLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: 38)
        self.labelLeadingConstraint = labelLeadingConstraint

        let constraints = [
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            imageView.firstBaselineAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -28),
            imageView.widthAnchor.constraint(equalToConstant: 28),
            imageView.heightAnchor.constraint(equalToConstant: 28),

            headlineLabel.firstBaselineAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            headlineLabel.trailingAnchor.constraint(equalTo: actionButton.leadingAnchor, constant: -20),

            actionButton.firstBaselineAnchor.constraint(equalTo: headlineLabel.firstBaselineAnchor),
            actionButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            labelLeadingConstraint
        ]
        constraints.forEach { $0.priority = .defaultHigh }
        NSLayoutConstraint.activate(constraints)
    }

    func update() {
        guard let viewModel = viewModel else { return }

        headlineLabel.text = viewModel.headlineTitle
        actionButton.setTitle(viewModel.actionTitle, for: .normal)
        imageView.isHidden = false

        if let image = viewModel.image {
            imageView.image = image
            labelLeadingConstraint.constant = 11 + 28
        } else {
            imageView.isHidden = true
            labelLeadingConstraint.constant = 0
        }
    }

    @objc
    func didPressActionButton(_ sender: Any) {
        guard let viewModel = viewModel else { return }
        delegate?.profileSectionHeaderView(self, didPressActionWithViewModel: viewModel)
    }
}
