//
//  HolkillustrationLabel.swift
//  Holk
//
//  Created by 张梦皓 on 2019-09-17.
//  Copyright © 2019 Holk. All rights reserved.
//

import UIKit

class HolkillustrationLabel: UILabel {
    lazy var suffixLabel = UILabel()
    var suffixColor: UIColor? {
        didSet {
            suffixLabel.textColor = suffixColor ?? self.textColor
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
        suffixLabel.font = Font.fontAwesome(style: .light, size: .subtitle)
        suffixLabel.text = String.fontAwesomeIcon(name: .lightbulbOn)
        suffixLabel.textColor = Color.mainHighlightColor
        suffixLabel.sizeToFit()
        
        suffixLabel.frame.origin = CGPoint(x: self.bounds.width - suffixLabel.frame.width, y: 0)
        self.addSubview(suffixLabel)
    }
}
