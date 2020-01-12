//
//  HolkSegmentedControl.swift
//  Holk
//
//  Created by 张梦皓 on 2019-06-18.
//  Copyright © 2019 Holk. All rights reserved.
//

import UIKit

final class HolkSegmentedControl: UISegmentedControl {
    // MARK: - Private variables
    private var segmentedControlFrames: [CGRect] = []
    private var imageLayer: CAShapeLayer = CAShapeLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        removeAllSegments()
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }
    override init(items: [Any]?) {
        super.init(items: items)
        
        setup()
    }
    
    private func setup() {
        self.setDividerImage(
            UIImage(),
            forLeftSegmentState: UIControl.State(),
            rightSegmentState: UIControl.State(),
            barMetrics: .default
        )
        
        self.setBackgroundImage(UIImage(), for: UIControl.State.normal, barMetrics: .default)
        self.setBackgroundImage(UIImage(), for: UIControl.State.selected, barMetrics: .default)
        
        imageLayer.frame = CGRect(x: 0, y: 0, width: frame.width / CGFloat(numberOfSegments), height: frame.height)
        imageLayer.cornerRadius = 20
        imageLayer.backgroundColor = Color.secondaryBackgroundColor.cgColor
        layer.addSublayer(imageLayer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Update the frame of imageLayer, since there are some cases that the image size is not updated properly
        let imageLayerWidth = frame.width / CGFloat(numberOfSegments)
        let imageLayerX = CGFloat(selectedSegmentIndex) * imageLayerWidth
        
        imageLayer.frame = CGRect(x: imageLayerX, y: 0, width: imageLayerWidth, height: frame.height)
    }
    
    override func sendActions(for controlEvents: UIControl.Event) {
        super.sendActions(for: controlEvents)
        
        setNeedsLayout()
    }
}
