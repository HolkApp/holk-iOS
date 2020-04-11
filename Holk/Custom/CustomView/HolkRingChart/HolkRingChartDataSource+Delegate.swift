//
//  HolkRingChartDataSource+Delegate.swift
//  Holk
//
//  Created by 张梦皓 on 2020-02-23.
//  Copyright © 2020 Holk. All rights reserved.
//

import UIKit

protocol HolkRingChartDataSource: AnyObject {
    func numberOfSegments(_ ringChart: HolkRingChart) -> Int
    func ringChart(_ ringChart: HolkRingChart, sizeForSegmentAt index: Int) -> CGFloat
    func ringChart(_ ringChart: HolkRingChart, ringChartWidthAt index: Int) -> CGFloat?
    func ringChart(_ ringChart: HolkRingChart, colorForSegmentAt index: Int) -> UIColor?
    func ringChart(_ ringChart: HolkRingChart, iconForSegmentAt index: Int) -> UIImage?
}

extension HolkRingChartDataSource {
    func ringChart(_ ringChart: HolkRingChart, ringChartWidthAt index: Int) -> CGFloat? {
        return nil
    }

    func ringChart(_ ringChart: HolkRingChart, colorForSegmentAt index: Int) -> UIColor? {
        return nil
    }

    func ringChart(_ ringChart: HolkRingChart, iconForSegmentAt index: Int) -> UIImage? {
        return nil
    }
}

protocol HolkRingChartDelegate: AnyObject {
    func ringChart(_ ringChart: HolkRingChart, didSelectSegmentAt index: Int)
    func ringChart(_ ringChart: HolkRingChart, didDeselectSegmentAt index: Int)
    func ringChart(_ ringChart: HolkRingChart, didHighlightSegmentAt index: Int)
    func ringChart(_ ringChart: HolkRingChart, didUnhighlightSegmentAt index: Int)
    func ringChart(_ ringChart: HolkRingChart, shouldHighlightRowAt index: Int) -> Bool
}

// MARK: - Default implementations
extension HolkRingChartDelegate {
    func ringChart(_ ringChart: HolkRingChart, didSelectSegmentAt index: Int) { }
    func ringChart(_ ringChart: HolkRingChart, didDeselectSegmentAt index: Int) { }
    func ringChart(_ ringChart: HolkRingChart, didHighlightSegmentAt index: Int) { }
    func ringChart(_ ringChart: HolkRingChart, didUnhighlightSegmentAt index: Int) { }
    func ringChart(_ ringChart: HolkRingChart, shouldHighlightRowAt index: Int) -> Bool {
        return false
    }
}
