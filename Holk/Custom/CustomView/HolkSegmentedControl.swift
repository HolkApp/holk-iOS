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
    private var imageLayerSize: CGSize {
        let validNumberOfSegments = max(numberOfSegments, 1)
        return CGSize(width: frame.width / CGFloat(validNumberOfSegments) - 10, height: 2)
    }
    
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
            forLeftSegmentState: .normal,
            rightSegmentState: .normal,
            barMetrics: .default
        )
        
        self.setBackgroundImage(UIImage(), for: UIControl.State.normal, barMetrics: .default)
        self.setBackgroundImage(UIImage(), for: UIControl.State.selected, barMetrics: .default)
        
        imageLayer.frame = CGRect(origin: CGPoint(x: 5, y: frame.height - 2), size: imageLayerSize)
        imageLayer.backgroundColor = Color.mainForegroundColor.cgColor
        layer.addSublayer(imageLayer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Update the frame of imageLayer, since there are some cases that the image size is not updated properly
        let imageLayerX = CGFloat(selectedSegmentIndex) * imageLayerSize.width + 5
        imageLayer.frame = CGRect(origin: CGPoint(x: imageLayerX, y: frame.height - 2),
                                  size: imageLayerSize)
    }
    
    override func sendActions(for controlEvents: UIControl.Event) {
        super.sendActions(for: controlEvents)
        
        setNeedsLayout()
    }
}
