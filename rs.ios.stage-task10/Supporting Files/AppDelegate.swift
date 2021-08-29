//
//  AppDelegate.swift
//  rs.ios.stage-task10
//
//  Created by Źmicier Fiedčanka on 25.08.21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setupWindow()
        return true
    }

    private func setupWindow() {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.tintColor = .RSBackground
        
        let navVC = UINavigationController(rootViewController: NewGameVC()) //!
        navVC.isNavigationBarHidden = true
        
        window?.rootViewController = navVC
        window?.makeKeyAndVisible()
    }
}

