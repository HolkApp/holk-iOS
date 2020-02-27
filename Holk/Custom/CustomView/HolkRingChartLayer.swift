//
//  HolkRingChartLayer.swift
//  Holk
//
//  Created by 张梦皓 on 2020-02-23.
//  Copyright © 2020 Holk. All rights reserved.
//

import UIKit

final class HolkRingChartLayer: CAShapeLayer {
    private(set) var startAngle: CGFloat = 0
    private(set) var endAngle: CGFloat = 0
    
    var ringChartWidth: CGFloat = 24 {
        didSet {
            setNeedsLayout()
        }
    }
    
    var baseColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1) {
        didSet {
            guard baseColor != oldValue else { return }
            strokeColor = baseColor.cgColor
        }
    }
    
    override init(layer: Any) {
        super.init(layer: layer)
        
        setup()
    }
    
    init(ringChartWidth: CGFloat, baseColor: UIColor) {
        super.init()
        
        self.baseColor = baseColor
        self.ringChartWidth = ringChartWidth
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSublayers() {
        super.layoutSublayers()
        
        lineWidth = ringChartWidth
        
        let oval = UIBezierPath(
            arcCenter: CGPoint(x: bounds.width / 2, y: bounds.height / 2),
            radius: (bounds.width - lineWidth) / 2,
            startAngle: -.pi / 2.0,
            endAngle: -.pi / 2.0 + 2 * .pi,
            clockwise: true
        )
        path = oval.cgPath
    }
    
    func updateStartAngle(_ offset: CGFloat, distance: CGFloat, animationDuration: TimeInterval? = nil) {
        startAngle = (.pi * 2 * offset) + (-.pi / 2.0)
        endAngle = startAngle + (.pi * 2 * distance)
        
        if let animationDuration = animationDuration {
            let strokeStartAnimation = CABasicAnimation(keyPath: "strokeStart")
            strokeStartAnimation.duration = animationDuration
            strokeStartAnimation.fromValue = strokeStart
            strokeStartAnimation.toValue = offset
            strokeStartAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            add(strokeStartAnimation, forKey: "strokeStart")
            
            let strokeEndAnimation = CABasicAnimation(keyPath: "strokeEnd")
            strokeEndAnimation.duration = animationDuration
            strokeEndAnimation.fromValue = strokeEnd
            strokeEndAnimation.toValue = offset + distance
            strokeEndAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            add(strokeEndAnimation, forKey: "strokeEnd")
        }
        
        strokeStart = offset
        strokeEnd = offset + distance
    }
    
    private func setup() {
        actions = [
            "path": NSNull(),
            "fillColor": NSNull(),
            "strokeColor": NSNull(),
            "lineWidth": NSNull(),
            "strokeStart": NSNull(),
            "strokeEnd": NSNull(),
            "opacity": NSNull()
        ]
        
        lineCap = .round
        fillColor = UIColor.clear.cgColor
        backgroundColor = UIColor.clear.cgColor
        strokeColor = baseColor.cgColor
    }
}
