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
        if let selectedIndexPath = fromViewController.tableView.indexPathForSelectedRow, let fromCell = fromViewController.tableView.cellForRow(at: selectedIndexPath) as? InsuranceCostTableViewCell, let toView = toViewController.view {
            
            let containerView = transitionContext.containerView
            containerView.backgroundColor = .white
            containerView.addSubview(toViewController.view)
            toViewController.view.alpha = 0
            toViewController.view.layoutIfNeeded()
            
            let temporaryView = UIView()
            temporaryView.frame = fromCell.frame.offsetBy(dx: 25, dy: 210)
            temporaryView.backgroundColor = .white
            containerView.addSubview(temporaryView)
            
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
                            temporaryView.frame = toView.frame
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
    }
}
