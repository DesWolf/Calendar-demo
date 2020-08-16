//
//  TabBarConroller.swift
//  Calendar demo
//
//  Created by Максим Окунеев on 6/2/20.
//  Copyright © 2020 Максим Окунеев. All rights reserved.
//

import UIKit

class TabBarConroller: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.barTintColor = .appBackGray
        tabBar.isTranslucent = false
        
        tabBar.tintColor = .appBlue
        tabBar.unselectedItemTintColor = .appTabIconGray
        
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        
////        let profile = ProfileVC()
////        let profileImage = UITabBarItem(title: "Профилььь", image: UIImage(named: "User"), selectedImage: UIImage(named: "User"))
////        profile.tabBarItem = profileImage
//        
//        
//        let students = StudentsNavController()
//        let studentImage = UITabBarItem(title: "Контактыыы", image: UIImage(named: "Contacts"), selectedImage: UIImage(named: "Contacts"))
//        students.tabBarItem = studentImage
//        
//        let calendar = CalendarNavController()
//        let calendarImage = UITabBarItem(title: "Календарььь", image: UIImage(named: "Calendar"), selectedImage: UIImage(named: "Calendar"))
//        calendar.tabBarItem = calendarImage
//        
//        let statistic = StatisticTVC()
//        let statisticImage = UITabBarItem(title: "Статистикааа", image: UIImage(named: "Statistic"), selectedImage: UIImage(named: "Statistic"))
//        statistic.tabBarItem = statisticImage
//        
//        let finance = FinanceTVC()
//        let financeImage = UITabBarItem(title: "Финансыыы", image: UIImage(named: "Wallet"), selectedImage: UIImage(named: "Wallet"))
//        finance.tabBarItem = financeImage
//        
//        
//        
//        
//        
//        self.viewControllers = [students, calendar, statistic, finance]
//    }
//    
//    //Delegate methods
//    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
//        print("Should select viewController: \(viewController.title ?? "") ?")
//        return true;
//    }
//    
    
    
}


