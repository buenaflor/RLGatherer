//
//  AppDelegate.swift
//  SteamGatherer
//
//  Created by Giancarlo on 07.05.18.
//  Copyright © 2018 Giancarlo. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    lazy var mainTabBarController: TabBarPageViewController = {
        return TabBarPageViewController()
    }()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = mainTabBarController
        window?.makeKeyAndVisible()
        showLoginIfNeeded(animated: true)
        
        SessionManager.shared.setNewUser(false)
//        SessionManager.shared.signOut()
        
        let navigationBarAppearance = UINavigationBar.appearance()
        
        navigationBarAppearance.barTintColor = UIColor.RL.mainDarkComplementary
        navigationBarAppearance.isTranslucent = false
        navigationBarAppearance.tintColor = .white
        
        return true
    }
    
    func showLoginIfNeeded(animated: Bool, completion: (()->())?=nil) {
        guard !SessionManager.shared.isLoggedIn else {
            completion?()
            return
        }
        
        let loginVC = LoginViewController()
        present(loginVC, animated: animated, completion: completion)
    }
    
    func present(_ viewController: UIViewController, animated: Bool, completion: (()->())?) {
        mainTabBarController.present(viewController, animated: animated, completion: completion)
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        SessionManager.shared.start(call: RLClient.GetTiers(tag: "data/tiers", query: ["apikey": BaseConfig.shared.apiKey])) { (result) in
            result.onSuccess { value in
                SessionManager.shared.tiers = value.tiers
                self.mainTabBarController.mainVC.loadData()
                }.onError { err in
                    print(err)
            }
        }
    }

}

