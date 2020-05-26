//
//  LoginVC.swift
//  Calendar demo
//
//  Created by Максим Окунеев on 5/17/20.
//  Copyright © 2020 Максим Окунеев. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper


class LoginVC: UIViewController {
    
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
//    private var email: String = "ossqqk@mail.ru"
//    private var password: String = "Aa12345678"
    private let networkManagerLogin = NetworkManagerLogin()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func emailTFAction(_ sender: Any) {
        guard emailTF.text?.isValidEmail() == true  else {
            return alert(message: "Введите корректный email")
        }
        print("email - ok")
    }
    
    @IBAction func passwordTFAction(_ sender: Any) {
        guard passwordTF.text?.isValidPassword() == true  else {
            return alert(message: "Пароль должен быть не менее 8 символов с одной заглавной и одной прописной буквой")
        }
        print("password - ok")
    }
    

    
    @IBAction func loginButtonPress(_ sender: Any) {
        print("Sign in button tapped")
        
        let userEmail = emailTF.text
        let userPassword = passwordTF.text
        
        if (userEmail?.isEmpty)! || (userPassword?.isEmpty)! {
            alert(message: "Пожалуйста, заполните необходимые поля")
        } else {
            loginUser(email: userEmail!, password: userPassword!)
        }
    }
    
    
}

//MARK: Network
extension LoginVC {
    private func loginUser(email: String, password: String) {
        networkManagerLogin.loginUser(email: email, password: password) { [weak self] (message, error)  in
            guard let message = message else {
                print(error ?? "")
                DispatchQueue.main.async {
                    self?.alert(message: error ?? "")
                }
                return
            }
            print(message)
            self?.saveDataToKeychein(accessToken: "\(message.id!)", userId: "\(message.id!)")
                        
            DispatchQueue.main.async {
                let homePage = self?.storyboard?.instantiateViewController(withIdentifier: "Main") as! UITabBarController
                    let appDelegate = UIApplication.shared.delegate
                    appDelegate?.window??.rootViewController = homePage
            }
        }
    }
}

//MARK: KeyChain
extension LoginVC {
    func saveDataToKeychein(accessToken: String, userId: String) {
        let saveAccesssToken: Bool = KeychainWrapper.standard.set(accessToken, forKey: "accessToken")
        let saveUserId: Bool = KeychainWrapper.standard.set(userId, forKey: "userId")
    }
}

//MARK: Alert
extension LoginVC  {
    func alert(message: String) {
        UIAlertController.alert(title:"Error", msg:"\(message)", target: self)
    }
}
