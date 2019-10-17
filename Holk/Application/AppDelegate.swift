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
    var coordinator: SessionCoordinator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // TODO: Use main coordinator to check the token first
        coordinator = SessionCoordinator(navController: UINavigationController())
        coordinator?.start()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = coordinator?.navController
        window?.makeKeyAndVisible()
        
        // TODO: Add something for register the appearance
        let appearance = UIPageControl.appearance(whenContainedInInstancesOf: [UIPageViewController.self])
        appearance.pageIndicatorTintColor = Color.secondaryForegroundColor
        appearance.currentPageIndicatorTintColor = Color.mainHighlightColor
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        // TODO: Should check, only centerain screens should be able to redirect
        return true
    }
}

