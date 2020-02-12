//
//  LandingInfoViewController.swift
//  Holk
//
//  Created by 张梦皓 on 2020-02-02.
//  Copyright © 2020 Holk. All rights reserved.
//

import UIKit

final class LandingInfoViewController: UIViewController {
    // MARK: - Private Variables
    private let textLabel = UILabel()
    
    // MARK: - Public Variables
    var text: String {
        didSet {
            textLabel.text = text
        }
    }
    
    var textColor: UIColor {
        didSet {
            textLabel.textColor = textColor
        }
    }
    
    // MARK: - Init
    init(text: String = String(), textColor: UIColor = Color.mainBackgroundColor) {
        self.text = text
        self.textColor = textColor
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Overridden methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    private func setup() {
        textLabel.text = text
        textLabel.font = Font.extraBold(.hugeHeader)
        textLabel.textColor = textColor
        textLabel.numberOfLines = 0
        
        view.addSubview(textLabel)
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            textLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            textLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 120)
        ])
    }
}
