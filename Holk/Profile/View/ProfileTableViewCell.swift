import UIKit

class ProfileTableViewCell: UITableViewCell {
    static let height: CGFloat = 64
    
    var viewModel: ProfileCellViewModel? {
        didSet {
            update()
        }
    }

    private let separatorLineView = UIView()
    private let leftImageView = UIImageView()
    let titleLabel = HolkLabel()

    private let subtitleLabel = HolkLabel()
    private let chevronView = ChevronView()
    let stackView = UIStackView()

    var leftLabelLeadingConstraint: NSLayoutConstraint?
    var stackViewHeightConstraint: NSLayoutConstraint?
    private var separatorLeadingConstraint: NSLayoutConstraint?
    private var rightLabelTrailingConstraint: NSLayoutConstraint?

    var shouldShowSeparator: Bool {
        get {
            return !separatorLineView.isHidden
        }
        set {
            separatorLineView.isHidden = !newValue
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        chevronView.image = nil
        chevronView.transform = .identity
        leftImageView.backgroundColor = UIColor.clear
        separatorLeadingConstraint?.constant = 18
        rightLabelTrailingConstraint?.constant = -20
        leftLabelLeadingConstraint?.constant = 20
        subtitleLabel.text = nil
        titleLabel.textColor = Color.label
        titleLabel.text = nil
        leftImageView.isHidden = false

        selectionStyle = .default
    }

    func showChevron(direction: ChevronDirection, color: UIColor) {
        chevronView.direction = direction
        chevronView.tintColor = color
    }

    func setup() {
        clipsToBounds = true

        backgroundColor = Color.mainBackground

        separatorLineView.backgroundColor = Color.separator
        separatorLineView.translatesAutoresizingMaskIntoConstraints = false

        leftImageView.contentMode = .scaleAspectFit
        leftImageView.translatesAutoresizingMaskIntoConstraints = false

        titleLabel.styleGuide = .body2
        titleLabel.textColor = Color.label
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        subtitleLabel.styleGuide = .body1
        subtitleLabel.textColor = Color.secondaryLabel
        subtitleLabel.textAlignment = .right
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false

        chevronView.translatesAutoresizingMaskIntoConstraints = false

        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(separatorLineView)
        contentView.addSubview(leftImageView)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(chevronView)
        contentView.addSubview(stackView)

        let separatorLeadingConstraint = separatorLineView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 18)
        self.separatorLeadingConstraint = separatorLeadingConstraint

        let rightLabelTrailingConstraint = subtitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        self.rightLabelTrailingConstraint = rightLabelTrailingConstraint

        let leftLabelLeadingConstraint = titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20)
        self.leftLabelLeadingConstraint = leftLabelLeadingConstraint

        let stackViewHeightConstraint = stackView.heightAnchor.constraint(equalToConstant: 0)
        self.stackViewHeightConstraint = stackViewHeightConstraint

        NSLayoutConstraint.activate([
            separatorLeadingConstraint,
            separatorLineView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -18),
            separatorLineView.heightAnchor.constraint(equalToConstant: 1),
            separatorLineView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            leftLabelLeadingConstraint,

            leftImageView.heightAnchor.constraint(equalToConstant: 40),
            leftImageView.widthAnchor.constraint(equalTo: leftImageView.heightAnchor),
            leftImageView.trailingAnchor.constraint(equalTo: titleLabel.leadingAnchor, constant: -4),
            leftImageView.centerYAnchor.constraint(equalTo: subtitleLabel.centerYAnchor),

            rightLabelTrailingConstraint,
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 12),
            subtitleLabel.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),

            chevronView.widthAnchor.constraint(equalToConstant: 20),
            chevronView.heightAnchor.constraint(equalToConstant: 20),
            chevronView.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            chevronView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            stackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            stackViewHeightConstraint,
        ])
    }

    func update() {
        guard let viewModel = viewModel else { return }

        titleLabel.text = viewModel.title

        subtitleLabel.text = viewModel.subtitle
        rightLabelTrailingConstraint?.constant = viewModel.accessory == .none ? -20 : -50

        setImage(imageUrl: viewModel.imageUrl)

        chevronView.isHidden = viewModel.accessory == .none
        if viewModel.accessory == .expand {
            if viewModel.isExpanded {
                showChevron(direction: .up, color: Color.label)
            } else {
                showChevron(direction: .down, color: Color.label)
            }
        } else {
            showChevron(direction: .right, color: Color.placeholder)
        }
    }

    private func setImage(imageUrl: URL?) {
        if let imageUrl = imageUrl {
            leftImageView.setImage(with: imageUrl)
            leftLabelLeadingConstraint?.constant = 60
            separatorLeadingConstraint?.constant = 60
        } else {
            leftImageView.image = nil
            separatorLeadingConstraint?.constant = 18
            leftLabelLeadingConstraint?.constant = 20
        }
    }
}
