//
//  AppDelegate.swift
//  Calendar demo
//
//  Created by Максим Окунеев on 4/20/20.
//  Copyright © 2020 Максим Окунеев. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    let notifications = Notifications()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let accessToken: String? = KeychainWrapper.standard.string(forKey: "accessToken")
        if accessToken != nil {
            let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let homePage = mainStoryboard.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
            self.window?.rootViewController = homePage
        } else {
            let mainStoryboard:UIStoryboard = UIStoryboard(name: "Login", bundle: nil)
            let loginPage = mainStoryboard.instantiateViewController(withIdentifier: "LoginNavController") as! UINavigationController
            self.window?.rootViewController = loginPage
            
            
//            let mainStoryboard:UIStoryboard = UIStoryboard(name: "Login", bundle: nil)
//            let loginPage = mainStoryboard.instantiateViewController(withIdentifier: "EnterScreenVC") as! EnterScreenVC
//            self.window?.rootViewController = loginPage
        }
        
        notifications.requestAutorization()
        notifications.notificationCenter.delegate = notifications
        
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
}
