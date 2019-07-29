import UIKit

final class InsuranceDetailTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if let insuranceOverviewViewController = transitionContext.viewController(forKey: .from) as? InsuranceOverviewViewController,
            let fromViewController = insuranceOverviewViewController.currentChildSegmentViewController as? InsuranceCostViewController,
            let toViewController = transitionContext.viewController(forKey: .to) as? InsuranceDetailViewController {
            push(transitionContext, fromViewController: fromViewController, toViewController: toViewController)
        }
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.4
    }
    
    private func push(_ transitionContext: UIViewControllerContextTransitioning, fromViewController: InsuranceCostViewController, toViewController: InsuranceDetailViewController) {
        if let selectedIndexPath = fromViewController.tableView.indexPathForSelectedRow, let fromCell = fromViewController.tableView.cellForRow(at: selectedIndexPath) as? InsuranceCostTableViewCell {
            let toView = toViewController.view!
            
            let containerView = transitionContext.containerView
            containerView.backgroundColor = .white
            containerView.addSubview(toViewController.view)
            toViewController.view.alpha = 0
            toViewController.view.layoutIfNeeded()
            
            let temporaryView = UIView()
            if let fromParentView = fromViewController.parent?.view {
                let fromRect = fromCell.convert(fromCell.frame, to: fromParentView)
                temporaryView.frame = fromRect
            } else {
                temporaryView.frame = fromCell.frame.offsetBy(dx: 25, dy: 210)
            }
            
            temporaryView.backgroundColor = .white
            containerView.addSubview(temporaryView)
            
            let scaleX = toView.frame.width / temporaryView.frame.width
            let scaleY = toView.frame.height / temporaryView.frame.height
            
            let duration = transitionDuration(using: transitionContext)

            UIView.animate(withDuration: duration / 2,
                           delay: 0,
                           options: UIView.AnimationOptions.curveEaseInOut,
                           animations: {
                            fromViewController.view.alpha = 0
            })
            
            UIView.animate(withDuration: duration / 2,
                           delay: 0,
                           options: UIView.AnimationOptions.curveEaseInOut,
                           animations: {
                            temporaryView.transform = CGAffineTransform(scaleX: scaleX, y: scaleY)
            })
            
            UIView.animate(withDuration: duration / 2,
                           delay: duration / 2,
                           options: UIView.AnimationOptions.curveEaseInOut,
                           animations: {
                            toViewController.view.alpha = 1.0
            }, completion: { success in
                transitionContext.completeTransition(success)
                fromViewController.view.alpha = 1
                temporaryView.removeFromSuperview()
                fromCell.alpha = 1.0
            })
        }
//
//        let containerView = transitionContext.containerView
//        let pieChartView = fromViewController.currentPieChart!
//        let amountLabel = pieChartView.titlesView.amountLabel
//        amountLabel.alpha = 0
//
//        containerView.addSubview(toViewController.view)
//        containerView.backgroundColor = Color.viewBackground
//        toViewController.view.alpha = 0
//        toViewController.view.layoutIfNeeded()
//
//        let temporaryLabel = UILabel()
//        temporaryLabel.layer.anchorPoint = CGPoint(x: 0, y: 0.5)
//        temporaryLabel.attributedText = amountLabel.attributedText
//        temporaryLabel.frame = toLabet.frame
//        temporaryLabel.frame.origin = amountLabel.globalOrigin
//        containerView.addSubview(temporaryLabel)
//
//        let toLabel = toViewController.totalAverageView.totalLabel
//        let toPosition = toLabel.globalOrigin
//
//        guard let amountString = temporaryLabel.attributedText?.string,
//            let toString = toLabel.attributedText?.string else { return }
//
//        let scale = toLabel.frame.height / temporaryLabel.frame.height
//        let range = (toString as NSString).range(of: amountString)
//        var toRect = toLabel.convert(toLabel.boundingBox(for: range), to: containerView)
//        toRect.origin.x -= 0.5
//        let duration = transitionDuration(using: transitionContext)
//
//        UIView.animate(withDuration: duration / 2,
//                       delay: 0,
//                       options: UIView.AnimationOptions.curveEaseInOut,
//                       animations: {
//                        fromViewController.view.alpha = 0
//        })
//
//        UIView.animate(withDuration: duration / 1.5,
//                       delay: 0,
//                       options: UIView.AnimationOptions.curveEaseInOut,
//                       animations: {
//                        temporaryLabel.frame.origin = CGPoint(x: toRect.origin.x, y: toPosition.y)
//                        temporaryLabel.frame.size.height = toLabel.frame.height
//                        temporaryLabel.transform = CGAffineTransform(scaleX: scale, y: scale)
//        })
//        UIView.animate(withDuration: duration / 2,
//                       delay: duration / 2,
//                       options: UIView.AnimationOptions.curveEaseInOut,
//                       animations: {
//                        toViewController.view.alpha = 1.0
//        }, completion: { success in
//            transitionContext.completeTransition(success)
//            fromViewController.view.alpha = 1
//            temporaryLabel.removeFromSuperview()
//            amountLabel.alpha = 1.0
//        })
    }
}
