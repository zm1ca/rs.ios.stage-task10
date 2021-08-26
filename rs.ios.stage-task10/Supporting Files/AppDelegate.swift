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
        configureAppearance()
        setupWindow()
        return true
    }

    private func configureAppearance() {
        UIApplication.shared.statusBarStyle = .lightContent //fix
        
        let states: [UIControl.State] = [.normal, .disabled, .highlighted]
        for buttonState in states {
            UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "Nunito-ExtraBold", size: 17)! ],
                                                                for: buttonState)
        }
        
        UINavigationBar.appearance().prefersLargeTitles = true
        UINavigationBar.appearance().barTintColor       = .RSBackground
        UINavigationBar.appearance().tintColor          = .RSGreen
        UINavigationBar.appearance().isTranslucent      = true
        UINavigationBar.appearance().shadowImage        = UIImage()
        UINavigationBar.appearance().largeTitleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont(name: "Nunito-ExtraBold", size: 36)!
        ]
    }
    
    private func setupWindow() {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.tintColor = .white
        let navVC = UINavigationController(rootViewController: NewGameVC())
        navVC.navigationItem.largeTitleDisplayMode = .always
        window?.rootViewController = navVC
        window?.makeKeyAndVisible()
    }
}

