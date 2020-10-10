//
//  HolkIllustrationLabel.swift
//  Holk
//
//  Created by 张梦皓 on 2019-09-17.
//  Copyright © 2019 Holk. All rights reserved.
//

import UIKit

class HolkIllustrationLabel: HolkLabel {
    // MARK: - Private variables
    private lazy var suffixLabel = UILabel()
    // MARK: - Public variables
    var suffixFont: UIFont? {
        didSet {
            guard let suffixFont = suffixFont else { return }
            suffixLabel.font = suffixFont
            updateLayout()
        }
    }
    var suffixText: String? {
        didSet {
            guard let suffixText = suffixText else { return }
            suffixLabel.text = suffixText
            updateLayout()
        }
    }
    var suffixColor: UIColor? {
        didSet {
            guard let suffixColor = suffixColor else { return }
            suffixLabel.textColor = suffixColor
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setup()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setup()
    }
    
    private func setup() {
        updateLayout()
        
        self.addSubview(suffixLabel)
    }
    
    private func updateLayout() {
        suffixLabel.sizeToFit()
        sizeToFit()
        suffixLabel.frame.origin = CGPoint(
            x: self.bounds.width + 2,
            y: 7        
        )
    }
}
