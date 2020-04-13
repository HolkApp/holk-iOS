//
//  LandingPageViewController.swift
//  Holk
//
//  Created by 张梦皓 on 2020-01-29.
//  Copyright © 2020 Holk. All rights reserved.
//

import UIKit

final class LandingPageViewController: UIPageViewController {
    // MARK: - Private Variables
    private var loginButton = HolkButton()
    private var pageControl = UIPageControl()
    private var infoButton = HolkButton()
    private var pendingIndex: Int?
    
    // MARK: - Public Variables
    weak var coordinator: SessionCoordinator?
    var orderedViewControllers = [UIViewController]() {
        didSet {
            viewControllersColors = orderedViewControllers.compactMap { $0.view.backgroundColor }
            orderedViewControllers.forEach { $0.view.backgroundColor = .clear }
        }
    }
    var viewControllersColors = [UIColor]() {
        didSet {
            view.backgroundColor = viewControllersColors.first
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    private func setup() {
        loginButton.backgroundColor = Color.mainBackgroundColor
        loginButton.setTitle("Logga in", for: .normal)
        loginButton.titleLabel?.font = Font.semiBold(.subtitle)
        loginButton.set(color: Color.mainForegroundColor, image: UIImage(named: "BankID"))
        loginButton.imageToTheRightOfText()
        loginButton.addTarget(self, action: #selector(loginTapped(_:)), for: .touchUpInside)
        
        infoButton.backgroundColor = Color.mainBackgroundColor
        infoButton.titleLabel?.font = Font.semiBold(.description)
        infoButton.layer.cornerRadius = 18
        if #available(iOS 13.0, *) {
            infoButton.layer.cornerCurve = .continuous
        }
        infoButton.contentEdgeInsets = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
        infoButton.setTitle("Så här funkar det", for: .normal)
        infoButton.set(color: Color.mainForegroundColor)
        infoButton.addTarget(self, action: #selector(infoTapped(_:)), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: infoButton)
        
        dataSource = self
        delegate = self
        
        let firstViewController = LandingInfoViewController(text: "Hitta dina luckor")
        firstViewController.view.backgroundColor = Color.landingBackgroundColor
        let middleViewController = LandingInfoViewController(text: "Förstå din försäkring")
        middleViewController.view.backgroundColor = Color.landingSecondaryBackgroundColor
        let lastViewController = LandingInfoViewController(text: "Bli bättre skyddad", textColor: Color.mainForegroundColor)
        lastViewController.view.backgroundColor = Color.mainHighlightColor
        orderedViewControllers = [firstViewController, middleViewController, lastViewController]
        // First set only the next visible view controller
        setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
        
        pageControl.numberOfPages = orderedViewControllers.count
        pageControl.currentPageIndicatorTintColor = Color.mainForegroundColor
        pageControl.pageIndicatorTintColor = Color.mainBackgroundColor
        
        setupCosntraints()
    }
    
    private func setupCosntraints() {
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pageControl)
        view.addSubview(loginButton)
        NSLayoutConstraint.activate([
            loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            loginButton.heightAnchor.constraint(equalToConstant: 90),
            loginButton.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageControl.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100)
        ])
    }
    
    @objc private func loginTapped(_ sender: UIButton) {
        coordinator?.authenticate()
    }
    
    @objc private func infoTapped(_ sender: UIButton) {
        coordinator?.information()
    }
    
    private func setBackgroundColor(_ color: UIColor, animated: Bool) {
        if animated {
            UIView.animate(withDuration: 0.4) {
                self.view.backgroundColor = color
            }
        } else {
            view.backgroundColor = color
        }
    }
}

extension LandingPageViewController: UIPageViewControllerDataSource {
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

extension LandingPageViewController: UIPageViewControllerDelegate {
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
                let color = viewControllersColors[index]
                setBackgroundColor(color, animated: false)
                pageControl.currentPage = index
            }
        }
    }
}
