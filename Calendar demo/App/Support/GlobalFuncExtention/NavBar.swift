//
//  NavBarExtention.swift
//  Calendar demo
//
//  Created by Максим Окунеев on 7/5/20.
//  Copyright © 2020 Максим Окунеев. All rights reserved.
//

import UIKit

extension UINavigationBar {
    
    public func set(controller: UIViewController) {
        let navBar = controller.navigationController?.navigationBar

        navBar?.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        navBar?.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        navBar?.backgroundColor = .appBackGray
    }
}
