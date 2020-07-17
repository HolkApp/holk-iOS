//
//  AppDelegate.swift
//  Holk
//
//  Created by 张梦皓 on 2019-04-24.
//  Copyright © 2019 Holk. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var coordinator: ShellCoordinator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        coordinator = ShellCoordinator()
        coordinator?.start()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = coordinator?.rootViewController
        window?.makeKeyAndVisible()
        
        // TODO: Add something for register the appearance
        let pageControlAppearance = UIPageControl.appearance(whenContainedInInstancesOf: [UIPageViewController.self])
        pageControlAppearance.pageIndicatorTintColor = Color.mainBackground
        pageControlAppearance.currentPageIndicatorTintColor = Color.mainForeground

        UINavigationBar.appearance().tintColor = Color.mainForeground

        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        // TODO: Should check, only centerain screens should be able to redirect
        return true
    }
}

