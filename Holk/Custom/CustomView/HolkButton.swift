//
//  HolkButton.swift
//  Holk
//
//  Created by 张梦皓 on 2019-08-20.
//  Copyright © 2019 Holk. All rights reserved.
//

import UIKit

final class HolkButton: UIButton {
    var styleGuide: FontStyleGuide = .body1 {
        didSet {
            titleLabel?.setStyleGuide(styleGuide)
        }
    }

    override func setTitle(_ title: String?, for state: UIControl.State) {
        super.setTitle(title, for: state)
        
        titleLabel?.setStyleGuide(styleGuide)
    }
    
    override var isEnabled: Bool {
        didSet {
            guard let backgroundColor = backgroundColor, isEnabled != oldValue else { return }
            if isEnabled {
                let alpha = min(backgroundColor.cgColor.alpha / 0.4, 1)
                self.backgroundColor = backgroundColor.withAlphaComponent(alpha)
            } else {
                self.backgroundColor = backgroundColor.withAlphaComponent(backgroundColor.cgColor.alpha * 0.4)
            }
        }
    }

    override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                tintColor = tintColor.withAlphaComponent(0.2)
            } else {
                tintColor = tintColor.withAlphaComponent(1)
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        titleLabel?.setStyleGuide(styleGuide)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(color: UIColor, image: UIImage? = nil) {
        setImage(image, for: .normal)
        tintColor = color

        setTitleColor(color, for: .normal)
        setTitleColor(color.withAlphaComponent(0.2), for: .highlighted)
    }
}

fileprivate extension UILabel {
    func setStyleGuide(_ styleGuide: FontStyleGuide) {
        font = styleGuide.font
        setLineHeight(styleGuide.lineHeight)
    }

    func setLineHeight(_ lineHeight: CGFloat) {
        guard let font = font else { return }

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineHeight - font.lineHeight
        paragraphStyle.alignment = textAlignment

        let attrString: NSMutableAttributedString
        if let attributedText = attributedText {
            attrString = NSMutableAttributedString(attributedString: attributedText)
        } else {
            attrString = NSMutableAttributedString(string: text ?? "")
            attrString.addAttribute(.font, value: font, range: NSRange(location: 0, length: attrString.length))
        }

        attrString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attrString.length))
        self.attributedText = attrString
    }
}
