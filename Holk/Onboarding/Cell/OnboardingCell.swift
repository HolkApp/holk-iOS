//
//  OnboardingCell.swift
//  Holk
//
//  Created by 张梦皓 on 2020-02-11.
//  Copyright © 2020 Holk. All rights reserved.
//

import UIKit

final class OnboardingCell: UICollectionViewCell {
    private var hostedView: UIView? {
        didSet {
            guard let hostedView = hostedView else {
                return
            }

            hostedView.frame = contentView.bounds
            contentView.addSubview(hostedView)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        if hostedView?.superview == contentView {
            hostedView?.removeFromSuperview()
        }

        hostedView = nil
    }

    private func setup() {
        backgroundColor = Color.mainBackground
        contentView.backgroundColor = .clear
    }

    func configure(onboardingView view: UIView) {
        hostedView = view
    }
}
