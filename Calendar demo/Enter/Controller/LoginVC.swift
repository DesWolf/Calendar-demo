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
    
    var email: String?
    var password: String?
    
    var onRegisterButtonTap: (() -> (Void))?
    private let networkManagerLogin = NetworkManagerLogin()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScreen()
    }
    
    @IBAction func emailTFAction(_ sender: Any) {
        guard emailTF.text?.isValidEmail() == true  else {
            return simpleAlert(message: "Введите корректный email")
        }
        print("email - ok")
    }
    
    @IBAction func passwordTFAction(_ sender: Any) {
        guard passwordTF.text?.isValidPassword() == true  else {
            return simpleAlert(message: "Пароль должен быть не менее 8 символов с одной заглавной и одной прописной буквой")
        }
        print("password - ok")
    }
    
    
    
    @IBAction func loginButtonPress(_ sender: Any) {
        print("Sign in button tapped")
        
        let userEmail = emailTF.text
        let userPassword = passwordTF.text
        
        if (userEmail?.isEmpty)! || (userPassword?.isEmpty)! {
            simpleAlert(message: "Пожалуйста, заполните необходимые поля")
        } else {
            loginUser(email: userEmail!, password: userPassword!)
        }
    }
    
    @IBAction func onRegisterButtonTap(_ sender: Any) { onRegisterButtonTap?() }
    
}

//MARK: SetupScreen
extension LoginVC {
    private func setupScreen() {
        if email != nil, password != nil {
            emailTF.text = email
            passwordTF.text = password
        }
        
        
    }
}

//MARK: Network
extension LoginVC {
    private func loginUser(email: String, password: String) {
        networkManagerLogin.loginUser(email: email, password: password) { [weak self] (message, error)  in
            
            if message?.token == nil {
                print(error ?? "")
                DispatchQueue.main.async {
                    self?.simpleAlert(message: "Ошибка токена")
                }
            } else {
                
                let token = message?.token
                let id = message?.teacherId
                guard let token2 = token else { return }
                guard let id2 = id else { return }
                
                self?.saveDataToKeychein(accessToken: token2, teacherId: "\(id2)" )
                DispatchQueue.main.async {
                    
                    let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let homePage = mainStoryboard.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
                    let appDelegate = UIApplication.shared.delegate
                    appDelegate?.window??.rootViewController = homePage
                }
            }
        }
    }
}

//MARK: KeyChain
extension LoginVC {
    func saveDataToKeychein(accessToken: String, teacherId: String) {
        let _ = KeychainWrapper.standard.set(accessToken, forKey: "accessToken")
        let _ = KeychainWrapper.standard.set(teacherId, forKey: "teacherId")
    }
}

//MARK: Alert
extension LoginVC  {
    func simpleAlert(message: String) {
        UIAlertController.simpleAlert(title:"Error", msg:"\(message)", target: self)
    }
}
