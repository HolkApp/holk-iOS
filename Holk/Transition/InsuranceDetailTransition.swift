//
//  InsuranceDetailTransition.swift
//  Holk
//
//  Created by 张梦皓 on 2020-03-30.
//  Copyright © 2020 Holk. All rights reserved.
//

import UIKit

final class InsuranceDetailTransition: NSObject, UIViewControllerAnimatedTransitioning {
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if let insurancesViewController = transitionContext.viewController(forKey: .from) as? InsurancesViewController, let toViewController = transitionContext.viewController(forKey: .to) as? InsuranceDetailViewController {
            let fromViewController = insurancesViewController
            push(transitionContext, fromViewController: fromViewController, toViewController: toViewController)
        } else if let fromViewController = transitionContext.viewController(forKey: .from) as? InsuranceDetailViewController,
            let insurancesViewController = transitionContext.viewController(forKey: .to) as? InsurancesViewController {
            pop(transitionContext, fromViewController: fromViewController, toViewController: insurancesViewController)
        } else {
            // fallBack
        }
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.4
    }

    private func push(_ transitionContext: UIViewControllerContextTransitioning, fromViewController: InsurancesViewController, toViewController: InsuranceDetailViewController) {
        if let selectedIndexPath = fromViewController.selectedIndexPath, let fromCell = fromViewController.collectionView.cellForItem(at: selectedIndexPath) as? InsuranceCollectionViewCell, let toView = toViewController.view {

            let containerView = transitionContext.containerView
            containerView.addSubview(toViewController.view)
            toViewController.view.alpha = 0
            toViewController.view.layoutIfNeeded()

            let temporaryView = UIView()

            temporaryView.frame = fromCell.containerView.convert(fromCell.containerView.bounds, to: containerView)
            var a = UIView()
            if let ringChart = fromCell.ringChart.snapshotView(afterScreenUpdates: false) {
                a = ringChart
                ringChart.frame = fromCell.ringChart.convert(ringChart.bounds, to: temporaryView)
                temporaryView.addSubview(ringChart)
            }
            temporaryView.backgroundColor = fromCell.containerView.backgroundColor
            containerView.addSubview(temporaryView)

            let duration = transitionDuration(using: transitionContext)

            UIView.animate(
                withDuration: duration / 2,
                delay: 0,
                options: UIView.AnimationOptions.curveEaseInOut,
                animations: {
                    fromViewController.view.alpha = 0
                    temporaryView.frame = toView.frame
                    a.frame = toViewController.ringChart.frame
                    toViewController.view.alpha = 1.0
                },
                completion: { success in
                    transitionContext.completeTransition(success)
                    fromViewController.view.alpha = 1
                    fromCell.alpha = 1.0
                    temporaryView.removeFromSuperview()
                })

            UIView.animate(
            withDuration: duration / 4,
            delay: duration / 2,
            options: UIView.AnimationOptions.curveEaseInOut,
            animations: {
                temporaryView.alpha = 0
            })
        }
    }

    private func pop(_ transitionContext: UIViewControllerContextTransitioning, fromViewController: InsuranceDetailViewController, toViewController: InsurancesViewController) {
        if let fromView = fromViewController.view,
            let selectedIndexPath = toViewController.selectedIndexPath,
            let toCell = toViewController.collectionView.cellForItem(at: selectedIndexPath) as? InsuranceCollectionViewCell {
            let containerView = transitionContext.containerView
            containerView.addSubview(toViewController.view)
            toViewController.view.alpha = 0
            toViewController.view.layoutIfNeeded()

            let temporaryView = UIView()

            temporaryView.frame = fromView.convert(fromView.bounds, to: containerView)
            var chartView = UIView()
            if let ringChart = fromViewController.ringChart.snapshotView(afterScreenUpdates: false) {
                chartView = ringChart
                ringChart.frame = fromViewController.ringChart.convert(ringChart.frame, to: temporaryView)
                temporaryView.addSubview(ringChart)
            }
            temporaryView.backgroundColor = fromViewController.view.backgroundColor
            containerView.addSubview(temporaryView)

            let duration = transitionDuration(using: transitionContext)

            UIView.animate(
                withDuration: duration / 2,
                delay: 0,
                options: UIView.AnimationOptions.curveEaseInOut,
                animations: {
                    fromViewController.view.alpha = 0
                    temporaryView.frame = toCell.containerView.convert(toCell.containerView.bounds, to: toViewController.view)
                    chartView.frame = toCell.ringChart.convert(toCell.ringChart.bounds, to: temporaryView)
                    toViewController.view.alpha = 1.0
                },
                completion: { success in
                    transitionContext.completeTransition(success)
                    fromViewController.view.alpha = 1
                    fromView.alpha = 1.0
                    temporaryView.removeFromSuperview()
                })

            UIView.animate(
            withDuration: duration / 4,
            delay: duration / 2,
            options: UIView.AnimationOptions.curveEaseInOut,
            animations: {
                temporaryView.alpha = 0
            })
        }
    }
}

