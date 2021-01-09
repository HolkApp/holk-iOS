import UIKit

class ProfileButtonTableViewCell: UITableViewCell {
    enum Style {
        case primary
        case secondary
    }

    var style: Style = .primary {
        didSet {

        }
    }
    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    private let containerView = UIView()
    private let titleLabel = HolkLabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        titleLabel.text = nil
        selectionStyle = .default
    }

    private func setup() {
        layoutMargins = .init(top: 4, left: 40, bottom: 4, right: 40)

        titleLabel.styleGuide = .button1
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        containerView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(containerView)
        containerView.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            containerView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            containerView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor)
        ])

        update()
    }

    private func update() {
        switch style {
        case .primary:
            titleLabel.textColor = Color.lightLabel
            containerView.backgroundColor = Color.label
        case .secondary:
            titleLabel.textColor = Color.label
            containerView.backgroundColor = .clear
        }
    }

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        switch style {
        case .primary:
            containerView.backgroundColor = highlighted ? Color.label.withAlphaComponent(0.6) : Color.label.withAlphaComponent(1)
        case .secondary:
            titleLabel.textColor = highlighted ? Color.label.withAlphaComponent(0.6) : Color.label.withAlphaComponent(1)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        switch style {
        case .primary:
            containerView.backgroundColor = selected ? Color.label.withAlphaComponent(0.6) : Color.label.withAlphaComponent(1)
        case .secondary:
            titleLabel.textColor = selected ? Color.label.withAlphaComponent(0.6) : Color.label.withAlphaComponent(1)
        }
    }
}


