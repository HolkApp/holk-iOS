//
//  HolkIconView.swift
//  Holk
//
//  Created by 张梦皓 on 2020-06-28.
//  Copyright © 2020 Holk. All rights reserved.
//

import UIKit

final class HolkIconView: UIView {
    let imageView = UIImageView()

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
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 4),
            imageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 4),
            imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -4),
            imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 4),
        ])
    }
}
