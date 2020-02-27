//
//  HolkRingChart.swift
//  Holk
//
//  Created by 张梦皓 on 2020-02-23.
//  Copyright © 2020 Holk. All rights reserved.
//

import UIKit

private enum Constants {
    static let maxNumberOfSegments = 10
    static let ringChartWidth: CGFloat = 24
}

final class HolkRingChart: UIView {
    var titleView = UIView()
    var containerView = UIView()
    var radius: CGFloat {
        min(bounds.width/2, bounds.height/2)
    }
    var contentOpacity: CGFloat = 1 {
        didSet {
            for segment in segments {
                segment.opacity = Float(contentOpacity)
            }
        }
    }
    
    var titleOpacity: CGFloat = 1 {
        didSet {
            titleView.alpha = titleOpacity
        }
    }
    
    var isReversed: Bool = false {
        didSet {
            if isReversed {
                containerView.transform = CGAffineTransform(scaleX: -1, y: 1)
            } else {
                containerView.transform = CGAffineTransform(scaleX: 1, y: 1)
            }
        }
    }
    
    var ringChartWidth: CGFloat = Constants.ringChartWidth {
        didSet {
            setNeedsLayout()
        }
    }
    
    weak var delegate: HolkRingChartDelegate?
    weak var dataSource: HolkRingChartDataSource?
    
    private var segments: [HolkRingChartLayer] = [] {
        didSet {
            for segment in oldValue {
                segment.removeFromSuperlayer()
            }
            for segment in segments {
                containerView.layer.addSublayer(segment)
            }
        }
    }
    
    private(set) var indexForSelectedSegment: Int?
    private(set) var indexForHighlightedSegment: Int?
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return super.point(inside: point, with: event)
    }
    
    override var tintColor: UIColor! {
        didSet {
            guard tintColor != nil else { return }
            
            reloadSegments()
        }
    }
    
    convenience init() {
        self.init(frame: .zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize { CGSize(width: radius * 2, height: radius * 2) }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        let baseColor = tintColor ?? .clear
        let numberOfSegments = dataSource?.numberOfSegments(self) ?? Constants.maxNumberOfSegments
        segments = (0..<numberOfSegments).map { _ in HolkRingChartLayer(ringChartWidth: Constants.ringChartWidth, baseColor: baseColor) }
        for segment in segments {
            containerView.layer.addSublayer(segment)
        }
    }
    
    func reloadSegments(animated: Bool = false) {
        reloadSegments(animationDuration: animated ? 0.3 : nil)
    }
    
    private var shouldAnimateMask = true
    private var latestAnimationDuration: TimeInterval = 0
    
    func reloadSegments(animationDuration: TimeInterval?) {
        shouldAnimateMask = animationDuration != nil
        latestAnimationDuration = animationDuration ?? 0
        let numberOfSegments = dataSource?.numberOfSegments(self) ?? 0
        assert(numberOfSegments <= Constants.maxNumberOfSegments, "Too many segments!")
        
        unhighlightAndDeselectSegmentIfNeeded(notifyDelegate: false)
        
        var previousValue: CGFloat = 0
        for (offset, segment) in segments.enumerated() {
            let value: CGFloat
            if offset < numberOfSegments, let dataSource = dataSource {
                value = dataSource.ringChart(self, sizeForSegmentAt: offset)
                segment.baseColor = dataSource.ringChart(self, colorForSegmentAt: offset) ?? tintColor
            } else {
                value = 0.0
            }
            segment.updateStartAngle(previousValue, distance: value, animationDuration: animationDuration)
            
            previousValue += value
        }
    }
    
    func selectSegment(at index: Int) {
        indexForSelectedSegment = index
        
        for (offset, segment) in segments.enumerated() {
            segment.opacity = index == offset ? 1.0 : 0.0
        }
    }
    
    func deselectSegment(at index: Int) {
        indexForSelectedSegment = nil
        
        for segment in segments {
            segment.opacity = 1.0
        }
    }
    
    func highlightSegment(at index: Int) {
        indexForHighlightedSegment = index
        
        for (offset, segment) in segments.enumerated() {
            segment.opacity = index == offset ? 1.0 : 0.5
        }
    }
    
    func unhighlightSegment(at index: Int) {
        indexForHighlightedSegment = nil
        
        for segment in segments {
            segment.opacity = 1.0
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let size = intrinsicContentSize
        containerView.frame = CGRect(x: (bounds.width - size.width) / 2,
                                     y: (bounds.height - size.height) / 2,
                                     width: size.width,
                                     height: size.height)
        
        for segment in segments {
            segment.frame = containerView.bounds
        }
        
        updateMaskLayer(animated: shouldAnimateMask)
    }
}

// MARK: - Input Handling
extension HolkRingChart {
    override  func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        guard let point = touches.first?.location(in: containerView) else { return }
        handleTouch(at: point, type: .began)
    }
    
    override  func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        
        guard let point = touches.first?.location(in: containerView) else { return }
        handleTouch(at: point, type: .moved)
    }
    
    override  func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        guard let point = touches.first?.location(in: containerView) else { return }
        handleTouch(at: point, type: .ended)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        
        guard let point = touches.first?.location(in: containerView) else { return }
        handleTouch(at: point, type: .cancelled)
    }
}

// MARK: - Private implementations
extension HolkRingChart {
    private func setup() {
        titleView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleView)
        addSubview(containerView)
        
        NSLayoutConstraint.activate([
            titleView.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        setupMaskLayer()
    }
    
    private func setupMaskLayer() {
        let maskLayer = CAShapeLayer()
        maskLayer.fillRule = CAShapeLayerFillRule.evenOdd
        containerView.layer.mask = maskLayer
    }
    
    private func updateMaskLayer(animated: Bool = false) {
        guard let maskLayer = containerView.layer.mask as? CAShapeLayer else { return }
        
        let path = UIBezierPath(ovalIn: CGRect(origin: .zero, size: intrinsicContentSize))
        let mid = CGPoint(x: intrinsicContentSize.width / 2, y: intrinsicContentSize.height / 2)
        let circleWidth = intrinsicContentSize.width / 2 - ringChartWidth
        path.addArc(withCenter: mid, radius: circleWidth, startAngle: 0, endAngle: .pi * 2, clockwise: true)
        if animated {
            let animation = CABasicAnimation(keyPath: "path")
            animation.duration = latestAnimationDuration
            animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
            animation.fromValue = maskLayer.path
            animation.toValue = path.cgPath
            maskLayer.path = path.cgPath
            maskLayer.add(animation, forKey: "Path")
        } else {
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            maskLayer.path = path.cgPath
            CATransaction.commit()
        }
    }
    
    private func isPoint(_ pts: CGPoint, within radius: CGFloat) -> Bool {
        return pts.x * pts.x + pts.y * pts.y <= radius * radius
    }
    
    private func indexForSegment(at angle: CGFloat) -> Int? {
        let offset: CGFloat = (.pi / 2.0)
        return segments.firstIndex(where: {
            angle > ($0.startAngle + offset) && angle < ($0.endAngle + offset)
        })
    }
    
    private func angleForPoint(_ point: CGPoint) -> CGFloat {
        let offset: CGFloat = (.pi / 2.0)
        let angle = atan2(point.y, point.x) + offset
        
        // Normalize
        return (angle > 0 ? angle : angle + .pi * 2)
    }
    
    private enum TouchKind {
        case began
        case moved
        case ended
        case cancelled
    }
    
    private func handleTouch(at point: CGPoint, type: TouchKind) {
        let radius = intrinsicContentSize.width / 2
        let relativePoint = CGPoint(x: point.x - radius, y: point.y - radius)
        
        let angle = angleForPoint(relativePoint)
        
        guard isPoint(relativePoint, within: radius), let index = indexForSegment(at: angle) else {
            unhighlightAndDeselectSegmentIfNeeded(notifyDelegate: true)
            return
        }
        
        let shouldHighlight = delegate?.ringChart(self, shouldHighlightRowAt: index) ?? false
        guard shouldHighlight else {
            unhighlightAndDeselectSegmentIfNeeded(notifyDelegate: true)
            return
        }
        
        switch type {
        case .began:
            unhighlightAndDeselectSegmentIfNeeded(notifyDelegate: true)
            highlightSegment(at: index)
            delegate?.ringChart(self, didHighlightSegmentAt: index)
        case .moved:
            if index != indexForHighlightedSegment {
                unhighlightAndDeselectSegmentIfNeeded(notifyDelegate: true)
                highlightSegment(at: index)
                delegate?.ringChart(self, didHighlightSegmentAt: index)
            }
        case .ended:
            if let highlightedIndex = indexForHighlightedSegment {
                unhighlightSegment(at: highlightedIndex)
                delegate?.ringChart(self, didUnhighlightSegmentAt: highlightedIndex)
            }
            selectSegment(at: index)
            delegate?.ringChart(self, didSelectSegmentAt: index)
        case .cancelled:
            unhighlightAndDeselectSegmentIfNeeded(notifyDelegate: true)
        }
    }
    
    func unhighlightAndDeselectSegmentIfNeeded(notifyDelegate: Bool) {
        if let highlightedIndex = indexForHighlightedSegment {
            unhighlightSegment(at: highlightedIndex)
            if notifyDelegate {
                delegate?.ringChart(self, didUnhighlightSegmentAt: highlightedIndex)
            }
        }
        if let selectedIndex = indexForSelectedSegment {
            deselectSegment(at: selectedIndex)
            if notifyDelegate {
                delegate?.ringChart(self, didDeselectSegmentAt: selectedIndex)
            }
        }
    }
}
