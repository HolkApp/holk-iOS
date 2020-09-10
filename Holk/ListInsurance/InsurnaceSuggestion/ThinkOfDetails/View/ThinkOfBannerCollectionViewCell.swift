//
//  ThinkOfBannerCollectionViewCell.swift
//  Holk
//
//  Created by 张梦皓 on 2020-07-19.
//  Copyright © 2020 Holk. All rights reserved.
//

import UIKit

final class ThinkOfBannerCollectionViewCell: UICollectionViewCell {
    private let imageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: .zero)

        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    func configure(_ imageURL: URL?) {
        if let imageURL = imageURL {
            UIImage.makeImage(with: imageURL) { [weak self] image in
                self?.imageView.image = image
            }
        } else {
            imageView.image = UIImage(named: "thinkOfPlaceholder")
        }
    }

    private func setup() {
        backgroundColor = Color.secondaryBackground

        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false

        setupLayout()
    }

    private func setupLayout() {
        addSubview(imageView)

        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
