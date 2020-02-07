//
//  LandingPageViewController.swift
//  Holk
//
//  Created by 张梦皓 on 2020-01-29.
//  Copyright © 2020 Holk. All rights reserved.
//

import UIKit

class LandingPageViewController: UIPageViewController {
    // MARK: - Private Variables
    private var loginButton = UIButton()
    private var signupButton = UIButton()
    private var pageControl = UIPageControl()
    private var infoButton = UIButton()
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
        signupButton.setTitle("Bli kund", for: UIControl.State())
        signupButton.layer.borderWidth = 1
        signupButton.layer.borderColor = Color.landingMainColor.cgColor
        signupButton.layer.cornerRadius = 7
        signupButton.titleLabel?.font = Font.semibold(.subtitle)
        signupButton.setTitleColor(Color.landingMainColor.withAlphaComponent(0.3), for: UIControl.State())
        signupButton.setTitleColor(Color.landingMainColor, for: .normal)
        signupButton.addTarget(self, action: #selector(signUpTapped(_:)), for: .touchUpInside)
        signupButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(signupButton)
        
        loginButton.backgroundColor = Color.landingMainColor
        loginButton.titleLabel?.font = Font.semibold(.subtitle)
        loginButton.tintColor = Color.mainForegroundColor
        loginButton.setImage(UIImage(named: "BankID"), for: UIControl.State())
        loginButton.setTitle("Logga in", for: UIControl.State())
        loginButton.setTitleColor(Color.mainForegroundColor.withAlphaComponent(0.3), for: UIControl.State())
        loginButton.setTitleColor(Color.mainForegroundColor, for: .normal)
        loginButton.imageToTheRightOfText()
        loginButton.addTarget(self, action: #selector(loginTapped(_:)), for: .touchUpInside)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loginButton)
        
        infoButton.backgroundColor = Color.landingMainColor
        infoButton.titleLabel?.font = Font.semibold(.label)
        infoButton.layer.cornerRadius = 18
        infoButton.contentEdgeInsets = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
        infoButton.setTitle("Så här funkar det", for: UIControl.State())
        infoButton.setTitleColor(Color.mainForegroundColor.withAlphaComponent(0.3), for: UIControl.State())
        infoButton.setTitleColor(Color.mainForegroundColor, for: .normal)
        infoButton.addTarget(self, action: #selector(infoTapped(_:)), for: .touchUpInside)
        infoButton.translatesAutoresizingMaskIntoConstraints = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: infoButton)
        
        NSLayoutConstraint.activate([
            signupButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            signupButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            signupButton.heightAnchor.constraint(equalToConstant: 65),
            signupButton.bottomAnchor.constraint(equalTo: loginButton.topAnchor, constant: -25),
            
            loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            loginButton.heightAnchor.constraint(equalToConstant: 90),
            loginButton.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
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
        
        view.addSubview(pageControl)
        pageControl.numberOfPages = orderedViewControllers.count
        pageControl.frame = CGRect(origin: .zero, size: pageControl.size(forNumberOfPages: orderedViewControllers.count))
        pageControl.currentPageIndicatorTintColor = Color.mainForegroundColor
        pageControl.pageIndicatorTintColor = Color.landingMainColor
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageControl.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100)
        ])
    }
    
    @objc private func loginTapped(_ sender: UIButton) {
        coordinator?.showLogin()
    }
        
    @objc private func signUpTapped(_ sender: UIButton) {
        coordinator?.showSignup()
    }
    
    @objc private func infoTapped(_ sender: UIButton) {
        coordinator?.displayInfo()
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
                setBackgroundColor(color, animated: true)
                pageControl.currentPage = index
            }
        }
    }
    
}
