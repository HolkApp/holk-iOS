//
//  HolkSegmentedControl.swift
//  Holk
//
//  Created by 张梦皓 on 2019-06-18.
//  Copyright © 2019 Holk. All rights reserved.
//

import UIKit

final class HolkSegmentedControl: UISegmentedControl {
    
    private var segmentedControlFrames: [CGRect] = []
    private var imageLayer: CAShapeLayer = CAShapeLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
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
        imageLayer.frame = CGRect(x: 0, y: 0, width: frame.width / CGFloat(numberOfSegments), height: frame.height)
        imageLayer.cornerRadius = 20
        imageLayer.backgroundColor = Color.secondaryBackgroundColor.cgColor
        imageLayer.borderWidth = 1
        imageLayer.borderColor = Color.lightBorderColor.cgColor
        layer.addSublayer(imageLayer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Update the frame of imageLayer, since there are some cases that the image size is not updated properly
        let imageLayerWidth = frame.width / CGFloat(numberOfSegments)
        let imageLayerX = CGFloat(selectedSegmentIndex) * imageLayerWidth
        
        imageLayer.frame = CGRect(x: imageLayerX, y: 0, width: imageLayerWidth, height: frame.height)
    }
    
    override func insertSegment(with image: UIImage?, at segment: Int, animated: Bool) {
        super.insertSegment(with: image, at: segment, animated: animated)
        segmentedControlFrames = []
        for index in 0..<numberOfSegments {
            let segmentFrame = CGRect(x: CGFloat(index) * frame.width / CGFloat(numberOfSegments), y: 0, width: frame.width / CGFloat(numberOfSegments), height: frame.height)
            segmentedControlFrames.append(segmentFrame)
        }
    }
    
    override func insertSegment(withTitle title: String?, at segment: Int, animated: Bool) {
        super.insertSegment(withTitle: title, at: segment, animated: animated)
        segmentedControlFrames = []
        for index in 0..<numberOfSegments {
            let segmentFrame = CGRect(x: CGFloat(index) * frame.width / CGFloat(numberOfSegments), y: 0, width: frame.width / CGFloat(numberOfSegments), height: frame.height)
            segmentedControlFrames.append(segmentFrame)
        }
    }
    
    override func sendActions(for controlEvents: UIControl.Event) {
        super.sendActions(for: controlEvents)
        
        if controlEvents == .valueChanged {
            for (offset, frame) in segmentedControlFrames.enumerated() {
                if offset == selectedSegmentIndex {
                    imageLayer.removeFromSuperlayer()
                    imageLayer.frame = frame
                    layer.insertSublayer(imageLayer, at: 0)
                }
            }
        }
    }
}
