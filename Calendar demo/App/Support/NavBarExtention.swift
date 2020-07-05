//
//  NavBarExtention.swift
//  Calendar demo
//
//  Created by Максим Окунеев on 7/5/20.
//  Copyright © 2020 Максим Окунеев. All rights reserved.
//

import UIKit

extension UINavigationBar {
    
    public func setClearNavBar(controller: UITableViewController) {
        let navBar = controller.navigationController?.navigationBar
        
        navBar?.setBackgroundImage(UIImage(), for: .default)
        navBar?.shadowImage = UIImage()
        navBar?.isTranslucent = true

        navBar?.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navBar?.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        controller.navigationController?.hidesBarsOnSwipe = true
    }
}
