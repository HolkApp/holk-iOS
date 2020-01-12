import UIKit

final class OnboardingInfoPageViewController: UIPageViewController {
    // MARK: - Private Variables
    private var pageControl = UIPageControl()
    private var pendingIndex: Int?
    
    // MARK: - Public Variables
    var orderedViewControllers = [UIViewController]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    private func setup() {
        dataSource = self
        delegate = self
        
        let infoViewController = StoryboardScene.Onboarding.onboardingInfoViewController.instantiate()
        let secondViewController = UIViewController()
        secondViewController.view.backgroundColor = .systemPink
        let thirdViewController = UIViewController()
        thirdViewController.view.backgroundColor = .systemGreen
        orderedViewControllers = [infoViewController, secondViewController, thirdViewController]
        setViewControllers([infoViewController], direction: .forward, animated: true, completion: nil)
        
        view.addSubview(pageControl)
        pageControl.numberOfPages = orderedViewControllers.count
        pageControl.frame = CGRect(origin: .zero, size: pageControl.size(forNumberOfPages: orderedViewControllers.count))
        pageControl.currentPageIndicatorTintColor = Color.mainHighlightColor
        pageControl.pageIndicatorTintColor = Color.mainForegroundColor
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageControl.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -166)
        ])
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
}

extension OnboardingInfoPageViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = orderedViewControllers.firstIndex(of: viewController) else {
            return nil
        }
        if currentIndex == 0 {
            return nil
        }
        let previousIndex = abs((currentIndex - 1) % orderedViewControllers.count)
        return orderedViewControllers[previousIndex]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = orderedViewControllers.firstIndex(of: viewController) else {
            return nil
        }
        if currentIndex == orderedViewControllers.count-1 {
            return nil
        }
        let nextIndex = abs((currentIndex + 1) % orderedViewControllers.count)
        return orderedViewControllers[nextIndex]
    }

    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        pendingIndex = orderedViewControllers.firstIndex(of: pendingViewControllers.first!)
    }

    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            if let index = pendingIndex {
                pageControl.currentPage = index
            }
        }
    }
    
}
