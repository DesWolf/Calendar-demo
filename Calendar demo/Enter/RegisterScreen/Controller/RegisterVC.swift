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
    
//    private var email: String = ""
//    private var password: String = ""
//    private var confirmPassword: String = ""
    
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
    
    @IBAction func confirmPasswordTFAction(_ sender: Any) {
        guard confirmPasswordTF.text?.isValidPassword() == true &&
                confirmPasswordTF.text == passwordTF.text  else{
            return alert(message: "Пароль должен быть не менее 8 символов с одной заглавной и одной прописной буквой")
        }
        print("confirmPassword - ok")
    }
    
    @IBAction func pressRegisterButton(_ sender: Any) {
        let userEmail = emailTF.text
        let userPassword = passwordTF.text
        let userConfirmPassword = confirmPasswordTF.text
        
        if (userEmail?.isEmpty)! || (userPassword?.isEmpty)! || (userConfirmPassword?.isEmpty)! {
            alert(message: "Пожалуйста, заполните необходимые поля")
        } else {
            registerUser(email: userEmail!, password: userPassword!, confirmPassword: userConfirmPassword!)
    }
    }
}



//MARK: Network
extension RegisterVC {
    private func registerUser(email: String, password: String, confirmPassword: String) {
        networkManagerLogin.registerUser(email: emailTF.text!, password: passwordTF.text!, confirmPassword: confirmPasswordTF.text!) { [weak self] (message, error)  in
            guard let message = message else {
                print(error ?? "")
                DispatchQueue.main.async {
                    self?.alert(message: error ?? "")
                }
                return
            }
            print(message)
        }
    }
}

//MARK: Alert
extension RegisterVC  {
    func alert(message: String) {
        UIAlertController.alert(title:"Error", msg:"\(message)", target: self)
    }
}
