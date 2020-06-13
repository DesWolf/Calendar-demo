//
//  DetailedDayVC.swift
//  Calendar demo
//
//  Created by Максим Окунеев on 4/21/20.
//  Copyright © 2020 Максим Окунеев. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

class ProfileVC: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func signOut(_ sender: Any) {
        KeychainWrapper.standard.removeObject(forKey: "accessToken")
        KeychainWrapper.standard.removeObject(forKey: "userId")
        
        
        let mainStoryboard:UIStoryboard = UIStoryboard(name: "LoginStoryboard", bundle: nil)
        let loginPage = mainStoryboard.instantiateViewController(withIdentifier: "EnterScreenVC") as! EnterScreenVC
        let appDelegate = UIApplication.shared.delegate
        appDelegate?.window??.rootViewController = loginPage
        
    }
}



