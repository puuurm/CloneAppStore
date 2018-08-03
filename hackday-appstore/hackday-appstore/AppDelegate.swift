//
//  AppDelegate.swift
//  hackday-appstore
//
//  Created by yangpc on 2018. 5. 15..
//  Copyright © 2018년 yang hee jung. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?
        ) -> Bool {
        initController()
        return true
    }

    private func initController() {
        let appTapViewController = AppViewController(style: .grouped)
        let appTapNaviController = UINavigationController(rootViewController: appTapViewController)
        appTapNaviController.tabBarItem = UITabBarItem(tabBarSystemItem: .contacts, tag: 0)

        let tabBar = UITabBarController()
        tabBar.viewControllers = [appTapNaviController]

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .white
        window?.makeKeyAndVisible()
        window?.rootViewController = tabBar

    }

}

