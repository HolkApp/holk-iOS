import UIKit

final class OnboardingInfoPageViewController: UIPageViewController {
    var orderedViewControllers = [UIViewController]()
    
    override func viewDidLoad() {
        dataSource = self
        
        let infoViewController = StoryboardScene.Onboarding.onboardingInfoViewController.instantiate()
        let secondViewController = UIViewController()
        secondViewController.view.backgroundColor = .systemPink
        let thirdViewController = UIViewController()
        thirdViewController.view.backgroundColor = .systemGreen
        orderedViewControllers = [infoViewController, secondViewController, thirdViewController]
        
        setViewControllers([infoViewController], direction: .forward, animated: true, completion: nil)
    }
}

extension OnboardingInfoPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.firstIndex(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return nil
        }
        
        guard orderedViewControllers.count > previousIndex else {
            return nil
        }
        
        return orderedViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.firstIndex(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = orderedViewControllers.count

        guard orderedViewControllersCount != nextIndex else {
            return nil
        }
        
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        
        return orderedViewControllers[nextIndex]
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        orderedViewControllers.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        let firstViewControllerIndex = viewControllers?.first.flatMap(orderedViewControllers.firstIndex(of: ))
        
        return firstViewControllerIndex ?? 0
    }
    
}
