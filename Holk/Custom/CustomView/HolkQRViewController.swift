//
//  HolkQRViewController.swift
//  Holk
//
//  Created by 张梦皓 on 2020-06-21.
//  Copyright © 2020 Holk. All rights reserved.
//

import UIKit

final class HolkQRCodeViewController: UIViewController {
    private let qrImage: UIImage
    private var imageView = UIImageView()

    init(qrImage: UIImage) {
        self.qrImage = qrImage

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "QR Code"
        imageView.contentMode = .scaleAspectFit
        imageView.image = qrImage
        imageView.translatesAutoresizingMaskIntoConstraints = false

        view.backgroundColor = .systemBackground
        view.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

