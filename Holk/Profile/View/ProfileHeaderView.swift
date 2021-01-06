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

extension ProfileHeaderView {
    private func setup() {
        layoutMargins = .init(top: 0, left: 20, bottom: 0, right: 20)

        nameLabel.styleGuide = .cardHeader2
        nameLabel.textColor = Color.label
        nameLabel.textAlignment = .center
        nameLabel.translatesAutoresizingMaskIntoConstraints = false

        emailLabel.styleGuide = .body2
        emailLabel.textColor = Color.label
        emailLabel.textAlignment = .center
        emailLabel.translatesAutoresizingMaskIntoConstraints = false

        imageView.image = UIImage(systemName: "person.circle")
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(imageView)
        addSubview(nameLabel)
        addSubview(emailLabel)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor, constant: 60),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 60),
            imageView.heightAnchor.constraint(equalToConstant: 60),

            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
            nameLabel.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),

            emailLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            emailLabel.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            emailLabel.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            emailLabel.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor)
        ])
    }

    func update(user: User) {
        nameLabel.text = user.userName
        emailLabel.text = user.email
    }
}
