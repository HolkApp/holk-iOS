import UIKit

final class ProfileTitleTableViewCell: ProfileTableViewCell {
    override func setup() {
        super.setup()

        let leftLabelLeadingConstraint = titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20)
        self.leftLabelLeadingConstraint = leftLabelLeadingConstraint

        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            leftLabelLeadingConstraint
            ])
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        
        titleLabel.textColor = Color.label
        titleLabel.text = nil
    }

    override func update() {
        super.update()

        guard let viewModel = viewModel else { return }

        titleLabel.text = viewModel.title
    }
}
