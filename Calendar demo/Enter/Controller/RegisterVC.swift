//
//  RegisterVC.swift
//  Calendar demo
//
//  Created by Максим Окунеев on 4/20/20.
//  Copyright © 2020 Максим Окунеев. All rights reserved.
//

import UIKit

class RegisterVC: UIViewController {
    
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var confirmPasswordTF: UITextField!
    
    var onEnterButtonTap: (() -> (Void))?
    
    private let networkManagerLogin = NetworkManagerLogin()
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    @IBAction func confirmPasswordTFAction(_ sender: Any) {
        guard confirmPasswordTF.text?.isValidPassword() == true &&
                confirmPasswordTF.text == passwordTF.text  else{
            return simpleAlert(message: "Пароль должен быть не менее 8 символов с одной заглавной и одной прописной буквой")
        }
        print("confirmPassword - ok")
    }
    
    @IBAction func pressRegisterButton(_ sender: Any) {
        let userEmail = emailTF.text
        let userPassword = passwordTF.text
        let userConfirmPassword = confirmPasswordTF.text
        
        if (userEmail?.isEmpty)! || (userPassword?.isEmpty)! || (userConfirmPassword?.isEmpty)! {
            simpleAlert(message: "Пожалуйста, заполните необходимые поля")
        } else {
            registerUser(email: userEmail!, password: userPassword!, confirmPassword: userConfirmPassword!)
//            onEnterButtonTap?()
        }
    }
    
    @IBAction func onEnterButtonTap(_ sender: Any) { onEnterButtonTap?() }
}



//MARK: Network
extension RegisterVC {
    private func registerUser(email: String, password: String, confirmPassword: String) {
        networkManagerLogin.registerUser(email: email, password: password, confirmPassword: confirmPassword) { [weak self] (message, error)  in
            guard let message = message else {
                print(error ?? "")
                DispatchQueue.main.async {
                    self?.simpleAlert(message: error ?? "")
                }
                return
            }
            if message.error != nil {
                var mes = ""
                
//                if message.error?.email != nil               { mes = String(describing: message.error?.email ?? "") }
//                if message.error?.password != nil            { mes = String(describing: message.error?.password ?? "") }
//                if message.error?.confirmPassword != nil     { mes = String(describing: message.error?.confirmPassword ?? "") }
                
                DispatchQueue.main.async {
                    self?.simpleAlert(message: mes )
                }
            }
            print(message)
        }
    }
}

//MARK: Alert
extension RegisterVC  {
    func simpleAlert(message: String) {
        UIAlertController.simpleAlert(title:"Error", msg:"\(message)", target: self)
    }
}
