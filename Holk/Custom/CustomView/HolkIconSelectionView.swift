//
//  HolkIconSelectionView.swift
//  Holk
//
//  Created by 张梦皓 on 2020-10-11.
//  Copyright © 2020 Holk. All rights reserved.
//

import UIKit

final class HolkIconSelectionView: UIControl {
    private let imageView = UIImageView()
    private let textLabel = HolkRoundBackgroundLabel()

    convenience init() {
        self.init(frame: .zero)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        layoutMargins = .init(top: 6, left: 6, bottom: 6, right: 6)

        imageView.clipsToBounds = true
        imageView.tintColor = Color.mainForeground
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false

        textLabel.cornerRadius = 10
        textLabel.styleGuide = .number1
        textLabel.backgroundColor = Color.selectedIconBackground
        textLabel.textAlignment = .center
        textLabel.translatesAutoresizingMaskIntoConstraints = false

        addSubview(imageView)
        addSubview(textLabel)

        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            imageView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            imageView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor),

            textLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 14),
            textLabel.topAnchor.constraint(equalTo: topAnchor, constant: -10),
        ])
    }

    func configure(image: UIImage?, text: String? = nil) {
        textLabel.text = text
        textLabel.isHidden = text == nil
        imageView.image = image
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        layer.cornerRadius = min(frame.width, frame.height) / 2
    }

    override var isSelected: Bool {
        didSet {
            backgroundColor = isSelected ? Color.selectedIconBackground : .clear
        }
    }
}
