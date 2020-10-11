//
//  HolkIconView.swift
//  Holk
//
//  Created by 张梦皓 on 2020-06-28.
//  Copyright © 2020 Holk. All rights reserved.
//

import UIKit
import Kingfisher

class HolkIconView: UIView {
    private let imageView = UIImageView()

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
        contentMode = .scaleAspectFit
        clipsToBounds = true

        imageView.image = image
        imageView.contentMode = contentMode
        imageView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(imageView)

        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 12),
            imageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 12),
            imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -12),
            imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -12),
        ])
    }

    override var tintColor: UIColor! {
        didSet {
            imageView.tintColor = tintColor
        }
    }

    var kf: KingfisherWrapper<UIImageView> {
        return imageView.kf
    }

    var image: UIImage? {
        didSet {
            imageView.image = image
        }
    }

    override var contentMode: UIView.ContentMode {
        didSet {
            imageView.contentMode = contentMode
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        layer.cornerRadius = min(frame.width, frame.height) / 2
    }
}
