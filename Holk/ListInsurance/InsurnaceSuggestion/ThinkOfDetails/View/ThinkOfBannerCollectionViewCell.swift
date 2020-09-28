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
        super.init(frame: frame)

        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError()
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
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 190)
        ])
    }
}

extension ThinkOfBannerCollectionViewCell {
    func configure(_ imageURL: URL?) {
        UIImage.makeImage(with: imageURL) { [weak self] image in
            if let image = image {
                self?.imageView.image = image
            } else {
                self?.imageView.image = UIImage(named: "thinkOfPlaceholder")
            }
        }
    }
}
