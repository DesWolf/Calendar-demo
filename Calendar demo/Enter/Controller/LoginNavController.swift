//
//  LoginNavController.swift
//  Calendar demo
//
//  Created by Максим Окунеев on 7/9/20.
//  Copyright © 2020 Максим Окунеев. All rights reserved.
//

import UIKit

class LoginNavController: UINavigationController {
    
    private let stStoryboard = UIStoryboard(name: "Login", bundle:nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        openStartScreen()
    }
    
    func openStartScreen() {
        let startScreen = stStoryboard.instantiateViewController(withIdentifier: "EnterScreenVC") as! EnterScreenVC
        
        startScreen.onEnterButtonTap = { [weak self] in
            guard let self = self else { return }
            self.openLogin(email: nil, password: nil)
        }
        
        startScreen.onRegisterButtonTap = { [weak self] in
            guard let self = self else { return }
            self.openRegister()
        }
        
        
        pushViewController(startScreen, animated: false)
    }
    
    func openLogin(email: String?, password: String?) {
        let login = stStoryboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        
        login.onRegisterButtonTap = { [weak self] in
            guard let self = self else { return }
            self.popToRootViewController(animated: true)
            self.openRegister()
            
        }
        
        
        
        if let email = email, let password = password {
            login.email = email
            login.password = password
        }
        
        pushViewController(login, animated: true)
        
    }
    
    func openRegister() {
        let register = stStoryboard.instantiateViewController(withIdentifier: "RegisterVC") as! RegisterVC
        
        register.onEnterButtonTap = { [weak self] in
            guard let self = self,
                let email = register.emailTF.text,
                let password = register.passwordTF.text  else { return }
            self.popToRootViewController(animated: false)
            self.openLogin(email: email, password: password)
            
        }
        
        pushViewController(register, animated: true)
    }
}


