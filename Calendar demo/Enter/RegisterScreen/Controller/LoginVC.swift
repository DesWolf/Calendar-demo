//
//  LoginVC.swift
//  Calendar demo
//
//  Created by Максим Окунеев on 5/17/20.
//  Copyright © 2020 Максим Окунеев. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {
    
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    private var email: String = "ossqqk@mail.ru"
    private var password: String = "Aa12345678"
    private let networkManagerLogin = NetworkManagerLogin()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    
    @IBAction func loginButtonPress(_ sender: Any) {
        loginUser()
    }
    
    
}

//MARK: Network
extension LoginVC {
    private func loginUser() {
        networkManagerLogin.loginUser(email: email, password: password) { [weak self] (message, error)  in
            guard let message = message else {
                print(error ?? "")
                DispatchQueue.main.async {
                    self?.alertNetwork(message: error ?? "")
                }
                return
            }
            print(message)
        }
    }
}

//MARK: Alert
extension LoginVC  {
    func alertNetwork(message: String) {
        UIAlertController.alert(title:"Error", msg:"\(message)", target: self)
    }
}
