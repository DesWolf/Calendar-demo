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
//    let notificationCenter = UNUserNotificationCenter.current()

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
        
        notifications.requestAutorization()
        notifications.notificationCenter.delegate = notifications
        
//        notificationCenter.delegate = self
//        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
//        
//        notificationCenter.requestAuthorization(options: options) { (didAllow, error) in
//            if !didAllow {
//                print("User has declined notifications")
//            }
//        }
        
        return true
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        UIApplication.shared.applicationIconBadgeNumber = 0
    }

}

//extension AppDelegate: UNUserNotificationCenterDelegate {
//
//    func userNotificationCenter(_ center: UNUserNotificationCenter,
//                                willPresent notification: UNNotification,
//                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//
//        completionHandler([.alert, .sound])
//    }
//
//    func userNotificationCenter(_ center: UNUserNotificationCenter,
//                                didReceive response: UNNotificationResponse,
//                                withCompletionHandler completionHandler: @escaping () -> Void) {
//
//        if response.notification.request.identifier == "Local Notification" {
//            print("Handling notifications with the Local Notification Identifier")
//        }
//
//        completionHandler()
//    }
//
//    func scheduleNotification(date: Date, title: String, message: String) {
//
//        let content = UNMutableNotificationContent() // Содержимое уведомления
//        let categoryIdentifire = "Delete Notification Type"
//
//        content.title = title
//        content.body = message
//        content.sound = UNNotificationSound.default
//        content.badge = 1
//        content.categoryIdentifier = categoryIdentifire
//
//        let comps = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
//        let trigger = UNCalendarNotificationTrigger(dateMatching: comps, repeats: false)
//
////        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
//
//        let identifier = ""
//        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
//
//        notificationCenter.add(request) { (error) in
//            if let error = error {
//                print("Error \(error.localizedDescription)")
//            }
//        }
//
//
////        let center = UNUserNotificationCenter.current()
////        center.removeDeliveredNotifications(withIdentifiers: ["notification-identifier-here"])
//
//
//        let snoozeAction = UNNotificationAction(identifier: "Snooze", title: "Snooze", options: [])
//        let deleteAction = UNNotificationAction(identifier: "DeleteAction", title: "Delete", options: [.destructive])
//        let category = UNNotificationCategory(identifier: categoryIdentifire,
//                                              actions: [snoozeAction, deleteAction],
//                                              intentIdentifiers: [],
//                                              options: [])
//
//        notificationCenter.setNotificationCategories([category])
//    }
//}
