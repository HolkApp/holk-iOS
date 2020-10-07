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
    static let defaultRingChartWidth: CGFloat = 4
}

final class HolkRingChart: UIView {
    // TODO: Change how to set the title view
    var titleView = UIView() {
        didSet {
            NSLayoutConstraint.activate([
                titleView.leadingAnchor.constraint(equalTo: titleContainerView.leadingAnchor),
                titleView.topAnchor.constraint(equalTo: titleContainerView.topAnchor),
                titleView.trailingAnchor.constraint(equalTo: titleContainerView.trailingAnchor),
                titleView.bottomAnchor.constraint(equalTo: titleContainerView.bottomAnchor),
            ])
            setNeedsLayout()
        }
    }
    let containerView = UIView()
    private let titleContainerView = UIView()
    public let iconsView = HolkRingChartIconsView()

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
    
    private var ringChartWidth: CGFloat {
        maxRingChartWidth ?? Constants.defaultRingChartWidth
    }
    private var maxRingChartWidth: CGFloat?
    
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

        reloadSegments()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        iconsView.frame = containerView.frame

        for segment in segments {
            segment.frame = containerView.bounds
        }

        updateMaskLayer(animated: shouldAnimateMask)
        iconsView.layout()
    }
    
    private var shouldAnimateMask = true
    private var latestAnimationDuration: TimeInterval = 0

    func reloadSegments(animated: Bool = false) {
        reloadSegments(animationDuration: animated ? 0.3 : nil)
    }
    
    func reloadSegments(animationDuration: TimeInterval?) {
        shouldAnimateMask = animationDuration != nil
        latestAnimationDuration = animationDuration ?? 0

        let baseColor = tintColor ?? .clear
        let numberOfSegments = dataSource?.numberOfSegments(self) ?? Constants.maxNumberOfSegments
        assert(numberOfSegments <= Constants.maxNumberOfSegments, "Too many segments!")

        var previousValue: CGFloat = 0
        segments = (0..<numberOfSegments).map { index in
            let value: CGFloat

            let segmentChartWidth = dataSource?.ringChart(self, ringChartWidthAt: index) ?? Constants.defaultRingChartWidth
            maxRingChartWidth = (maxRingChartWidth?.isLess(than: segmentChartWidth) ?? true) ? segmentChartWidth : maxRingChartWidth
            let ringChartLayer = HolkRingChartLayer(ringChartWidth: segmentChartWidth, baseColor: baseColor)

            if index < numberOfSegments, let dataSource = dataSource {
                value = dataSource.ringChart(self, sizeForSegmentAt: index)
                ringChartLayer.baseColor = dataSource.ringChart(self, colorForSegmentAt: index) ?? tintColor
            } else {
                value = 0.0
            }
            ringChartLayer.updateStartAngle(previousValue, distance: value, animationDuration: animationDuration)
            previousValue += value

            return ringChartLayer
        }
    }

    func isPoint(_ pts: CGPoint, within radius: CGFloat) -> Bool {
        return pts.x * pts.x + pts.y * pts.y <= radius * radius
    }

    func indexForSegment(at angle: CGFloat) -> Int? {
        let offset: CGFloat = (.pi / 2.0)
        return segments.firstIndex(where: {
            angle > ($0.startAngle + offset) && angle < ($0.endAngle + offset)
        })
    }
}

// MARK: - Private implementations
extension HolkRingChart {
    private func setup() {
        titleView.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
        titleContainerView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(containerView)
        addSubview(titleView)
        addSubview(titleContainerView)

        iconsView.ringChart = self
        addSubview(iconsView)
        
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),

            titleContainerView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            titleContainerView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor, constant: -12),
            titleContainerView.heightAnchor.constraint(lessThanOrEqualTo: containerView.heightAnchor, constant: -ringChartWidth - 8),
            titleContainerView.widthAnchor.constraint(lessThanOrEqualTo: containerView.widthAnchor, constant: -ringChartWidth - 8)
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
}
