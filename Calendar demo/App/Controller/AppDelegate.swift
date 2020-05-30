//
//  AppDelegate.swift
//  Calendar demo
//
//  Created by Максим Окунеев on 4/20/20.
//  Copyright © 2020 Максим Окунеев. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
       
        let accessToken: String? = KeychainWrapper.standard.string(forKey: "accessToken")
        if accessToken != nil {
            let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let homePage = mainStoryboard.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
            self.window?.rootViewController = homePage
        } else {
            let mainStoryboard:UIStoryboard = UIStoryboard(name: "LoginStoryboard", bundle: nil)
            let loginPage = mainStoryboard.instantiateViewController(withIdentifier: "EnterScreenVC") as! EnterScreenVC
            self.window?.rootViewController = loginPage
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    func applicationWillTerminate(_ application: UIApplication) {
    }
}

