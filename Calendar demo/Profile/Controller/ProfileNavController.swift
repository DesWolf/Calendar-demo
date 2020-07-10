//
//  ProfileNavController.swift
//  Calendar demo
//
//  Created by Максим Окунеев on 7/10/20.
//  Copyright © 2020 Максим Окунеев. All rights reserved.
//

import UIKit

class ProfileNavController: UINavigationController {

    private let stStoryboard = UIStoryboard(name: "Profile", bundle: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()

      openSettings()
    }
    

    func openSettings() {
        let profile = stStoryboard.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
        
        
        
         pushViewController(profile, animated: false)
    }
}
