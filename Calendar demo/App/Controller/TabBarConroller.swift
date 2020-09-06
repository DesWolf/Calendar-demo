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
}
