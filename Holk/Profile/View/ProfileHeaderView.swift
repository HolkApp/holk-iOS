import UIKit

final class ProfileHeaderView: UIView {
    private let nameLabel = HolkLabel()
    private let emailLabel = HolkLabel()
    private let imageView = UIImageView()

    init() {
        super.init(frame: .zero)

        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        setup()
    }
}

private extension ProfileHeaderView {
    func setup() {
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.styleGuide = .cardHeader1
        nameLabel.textColor = Color.label
        nameLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)

        imageView.image = UIImage(systemName: "person.circle")
        imageView.contentMode = .center
        imageView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(nameLabel)
        addSubview(imageView)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: 60),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 40),
            imageView.heightAnchor.constraint(equalToConstant: 40),

            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
            nameLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])
    }

    func update(user: User) {
        nameLabel.text = user.userName
        emailLabel.text = user.email
    }
}
