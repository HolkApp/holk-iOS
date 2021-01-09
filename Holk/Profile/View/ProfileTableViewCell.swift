import UIKit

class ProfileTableViewCell: UITableViewCell {
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

    var leftLabelLeadingConstraint: NSLayoutConstraint?
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
        separatorLeadingConstraint?.constant = 20
        rightLabelTrailingConstraint?.constant = -20
        leftLabelLeadingConstraint?.constant = 20
        subtitleLabel.text = nil
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

        contentView.addSubview(separatorLineView)
        contentView.addSubview(leftImageView)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(chevronView)

        let separatorLeadingConstraint = separatorLineView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20)
        self.separatorLeadingConstraint = separatorLeadingConstraint

        let rightLabelTrailingConstraint = subtitleLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20)
        self.rightLabelTrailingConstraint = rightLabelTrailingConstraint

        NSLayoutConstraint.activate([
            separatorLeadingConstraint,
            separatorLineView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -19),
            separatorLineView.heightAnchor.constraint(equalToConstant: 1),
            separatorLineView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            leftImageView.heightAnchor.constraint(equalToConstant: 40),
            leftImageView.widthAnchor.constraint(equalTo: leftImageView.heightAnchor),
            leftImageView.rightAnchor.constraint(equalTo: titleLabel.leftAnchor, constant: -20),
            leftImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            rightLabelTrailingConstraint,
            subtitleLabel.leftAnchor.constraint(equalTo: titleLabel.rightAnchor, constant: 16),
            subtitleLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            subtitleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            chevronView.widthAnchor.constraint(equalToConstant: 15),
            chevronView.topAnchor.constraint(equalTo: contentView.topAnchor),
            chevronView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            chevronView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20)
        ])
    }

    func update() {
        guard let viewModel = viewModel else { return }

        subtitleLabel.text = viewModel.subtitle
        rightLabelTrailingConstraint?.constant = viewModel.accessory == .none ? -20 : -50

        setImage(imageUrl: viewModel.imageUrl)

        chevronView.isHidden = viewModel.accessory == .none
        if viewModel.accessory == .expand {
            showChevron(direction: .down, color: Color.label)
        } else {
            showChevron(direction: .right, color: Color.placeholder)
        }
    }

    private func setImage(imageUrl: URL?) {
        if let imageUrl = imageUrl {
            leftImageView.setImage(with: imageUrl)
            leftLabelLeadingConstraint?.constant = 80
            separatorLeadingConstraint?.constant = 80
        } else {
            leftImageView.image = nil
            separatorLeadingConstraint?.constant = 20
            leftLabelLeadingConstraint?.constant = 20
        }
    }
}
