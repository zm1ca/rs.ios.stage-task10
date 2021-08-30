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
        
        let data = UserDefaults.standard.data(forKey: "PlayerScores")
        if let data = data, let state = try? JSONDecoder().decode(GameState.self, from: data) {
            configureWindow(with: state)
            return true
        }
    
        configureWindowWithNewGame()
        return true
    }
    
    private func configureWindow(with state: GameState) {
        let gameVC = GameVC()
        gameVC.loadGame(from: state)
        
        let navVC = UINavigationController(rootViewController: gameVC)
        navVC.isNavigationBarHidden = true
        
        window?.rootViewController = navVC
        window?.makeKeyAndVisible()
    }
    
    private func configureWindowWithNewGame() {
        let navVC = UINavigationController(rootViewController: NewGameVC())
        navVC.isNavigationBarHidden = true
        
        window?.rootViewController = navVC
        window?.makeKeyAndVisible()
    }
    
    
    //MARK: Saving state
    func applicationWillResignActive(_ application: UIApplication) {
        let navVC = window?.rootViewController as! UINavigationController
        
        if let gameVC = navVC.topViewController as? GameVC {
            gameVC.timerView.pause()

            if let data = try? JSONEncoder().encode(gameVC.state) {
                UserDefaults.standard.set(data, forKey: "PlayerScores")
            }
        }
    }
    
    private func persistState(from gameVC: GameVC) {
        
    }
}

