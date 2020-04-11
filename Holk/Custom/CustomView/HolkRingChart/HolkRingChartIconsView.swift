//
//  HolkRingChartIconsView.swift
//  Holk
//
//  Created by 张梦皓 on 2020-03-06.
//  Copyright © 2020 Holk. All rights reserved.
//

import UIKit

private enum Constants {
    static let defaultPadding: CGFloat = 36
    static let iconSize: CGFloat = 12
    static let minimumDistance: CGFloat = 60
    static let startOffset: CGFloat = -0.25
}

final class HolkRingChartIconsView: UIView {

    /// Angles is the mid point angle for each segment,
    /// this is where the line starts to the icon
    private var angles: [CGFloat] = []

    /// Adjusted angles are the angles for each icon which
    /// is corrected through adjustAngles(_, _) suppress icons
    /// from over lapping
    private var adjustedAngles: [CGFloat] = []

    private var icons: [HolkRingChartIconView] = []

    var connectionLength = Constants.defaultPadding {
        didSet {
            update()
        }
    }

   var contentSize: CGSize {
        let size = bounds.width + (connectionLength * 2) + (Constants.iconSize * 2) * 2
        return CGSize(width: size, height: size)
    }

    weak var ringChart: HolkRingChart? {
        didSet {
            update()
        }
    }

    convenience init() {
        self.init(frame: .zero)
    }

    func layout() {
        update()
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        if #available(iOS 13.0, *) {
            guard traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) else {
                return
            }

            update()
        }
    }
}

private extension HolkRingChartIconsView {
    func update() {
        guard let ringChart = ringChart,
            let dataSource = ringChart.dataSource else { return }

        let radius = (ringChart.containerView.bounds.width / 2.0)
        let radiusWithPadding = radius + Constants.iconSize + (connectionLength)
        let center = CGPoint(x: radius, y: radius)
        var previousValue: CGFloat = Constants.startOffset

        let numberOfSegments = dataSource.numberOfSegments(ringChart)

        icons.forEach({ $0.removeFromSuperview() })
        icons.removeAll()

        adjustedAngles.removeAll()

        self.angles = stride(from: 0, to: numberOfSegments, by: 1).compactMap { index in

            let value = dataSource.ringChart(ringChart, sizeForSegmentAt: index)
            defer { previousValue += value }
            let newValue = (previousValue + value)

            // Get the mid point for segment

            let angle = CGFloat(0.5).lerped(a: previousValue, b: newValue)
            adjustedAngles.append(angle * .pi * 2)
            return angle * .pi * 2
        }

        adjustAngles(center, radiusWithPadding)

        // Add icons
        adjustedAngles.enumerated().forEach { offset, angle in
            let point = iconPoint(center, radius: radiusWithPadding, angle: angle)

            let image = dataSource.ringChart(ringChart, iconForSegmentAt: offset)
            let imageColor = dataSource.ringChart(ringChart, colorForSegmentAt: offset)
            let iconSize = CGSize(width: Constants.iconSize, height: Constants.iconSize)

            let iconView = HolkRingChartIconView(frame: CGRect(x: 0, y: 0, width: iconSize.width * 2 + 2, height: iconSize.height * 2 + 2))
            iconView.frame.origin = point

            iconView.update(image: image, color: imageColor)
            addSubview(iconView)
            icons.append(iconView)
        }
    }

    /// Adjusting angles for icon positions.
    /// This method iterates at most 50 times to find over lapping icons and
    /// adjustes the icon position with 2 degrees for clock wise items and
    /// 1 degree for counter clock wise items. This is because the last item
    /// usually has more space to the right of it.
    ///
    /// - Parameters:
    ///   - center: center point of the pie chart
    ///   - radius: the radius of the pie chart
    func adjustAngles(_ center: CGPoint, _ radius: CGFloat) {
        let minimumDistance = Constants.minimumDistance

        if angles.count > 2 {
            // Adjust circles up to 50 times
            for i in 1 ... 50 {
                var adjusted = false

                for jx in 0 ..< angles.count {
                    // Get index reversed every other iteration to favor CW movement
                    let j = (i % 2 != 0) ? angles.count - jx - 1 : jx
                    let currentAngle = adjustedAngles[j]

                    // Get previous or last adjusted angle
                    let previousAngle = j == 0 ? adjustedAngles[angles.count - 1] : adjustedAngles[j - 1]
                    // Get next or first adjusted angle
                    let nextAngle = j == angles.count - 1 ? adjustedAngles[0] : adjustedAngles[j + 1]

                    let currentRadialOffset = radialOffset(currentAngle)
                    let currentPoint = iconPoint(center, radius: radius + currentRadialOffset, angle: currentAngle)
                    let previousRadialOffset = radialOffset(previousAngle)
                    let previousPoint = iconPoint(center, radius: radius + previousRadialOffset, angle: previousAngle)
                    let nextRadialOffset = radialOffset(nextAngle)
                    let nextPoint = iconPoint(center, radius: radius + nextRadialOffset, angle: nextAngle)

                    let previousDistance = currentPoint.distance(to: previousPoint)
                    let nextDistance = currentPoint.distance(to: nextPoint)

                    if previousDistance < minimumDistance || nextDistance < minimumDistance {
                        adjusted = true

                        var currentAdjustedAngle = adjustedAngles[j]

                        if nextDistance > previousDistance {

                            // Nudge a bit to the right
                            currentAdjustedAngle += (2.0 as CGFloat).degreesToRadians()
                        } else {

                            // Nudge a bit to the left
                            currentAdjustedAngle -= (1.0 as CGFloat).degreesToRadians()
                        }

                        adjustedAngles[j] = currentAdjustedAngle
                    }
                }

                if !adjusted {
                    break
                }
            }
        }
    }

    func iconPoint(_ center: CGPoint, radius: CGFloat, angle: CGFloat) -> CGPoint {
        return CGPoint(x: (cos(angle) * radius + center.x - Constants.iconSize),
                       y: (sin(angle) * radius + center.y - Constants.iconSize))
    }

    func radialOffset(_ angle: CGFloat) -> CGFloat {
        // Module by .pi
        var offset = angle.truncatingRemainder(dividingBy: .pi)

        // Normalize
        if offset > .pi / 2 {
            offset = .pi - offset
        }

        offset /= .pi
        offset *= Constants.iconSize

        return offset
    }
}

