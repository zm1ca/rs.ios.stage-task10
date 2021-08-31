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

    //MARK: Loading state
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        var rootVC: UIViewController = NewGameVC()

        let data = UserDefaults.standard.data(forKey: "PlayerScores")
        if let data = data, let state = try? JSONDecoder().decode(GameState.self, from: data) {
            rootVC = GameVC()
            (rootVC as! GameVC).loadGame(from: state)
        }
        
        let navVC = UINavigationController(rootViewController: rootVC)
        navVC.isNavigationBarHidden = true
        
        window?.rootViewController = navVC
        window?.makeKeyAndVisible()
        
        return true
    }
    
    
    //MARK: Saving state
    func applicationWillResignActive(_ application: UIApplication) {
        NotificationCenter.default.post(Notification(name: .applicationWillResignActive))
    }
}

