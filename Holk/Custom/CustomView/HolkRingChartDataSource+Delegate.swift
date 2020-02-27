//
//  HolkRingChartDataSource+Delegate.swift
//  Holk
//
//  Created by 张梦皓 on 2020-02-23.
//  Copyright © 2020 Holk. All rights reserved.
//

import UIKit

protocol HolkRingChartDataSource: AnyObject {
    func numberOfSegments(_ pieChart: HolkRingChart) -> Int
    func ringChart(_ pieChart: HolkRingChart, sizeForSegmentAt index: Int) -> CGFloat
    func ringChart(_ pieChart: HolkRingChart, colorForSegmentAt index: Int) -> UIColor?
}

extension HolkRingChartDataSource {
    func ringChart(_ pieChart: HolkRingChart, colorForSegmentAt index: Int) -> UIColor? {
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
    func ringChart(_ pieChart: HolkRingChart, didSelectSegmentAt index: Int) { }
    func ringChart(_ pieChart: HolkRingChart, didDeselectSegmentAt index: Int) { }
    func ringChart(_ pieChart: HolkRingChart, didHighlightSegmentAt index: Int) { }
    func ringChart(_ ringChart: HolkRingChart, didUnhighlightSegmentAt index: Int) { }
    func ringChart(_ ringChart: HolkRingChart, shouldHighlightRowAt index: Int) -> Bool {
        return true
    }
}
