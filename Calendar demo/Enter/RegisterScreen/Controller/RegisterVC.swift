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
    
    private var email: String = ""
    private var password: String = ""
    private var confirmPassword: String = ""
    
    private let networkManagerLogin = NetworkManagerLogin()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        let textFields = [emailTF, passwordTF, confirmPasswordTF]
        //        for textField in textFields {
        //            textField!.addTarget(self, action: #selector(LoginTVController.textFieldDidChange(textField:)),
        //                                 for: UIControl.Event.editingDidEnd)
        //        }
        //
        //        emailTF.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        //        passwordTF.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        //        confirmPasswordTF.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        
        
    }
    @IBAction func emailTFAction(_ sender: Any) {
        if emailTF.text?.isValidEmail() == true {
            email = emailTF.text!
        } else {
            alertNetwork(message: "Введите корректный email")
        }
    }
    @IBAction func PasswordTFAction(_ sender: Any) {
        if passwordTF.text!.count < 8 {
            alertNetwork(message: "Пароль должен быть не менее 8 символов с одной заглавной и одной прописной буквой")
        }
    }
    
    @IBAction func confirmPasswordTFAction(_ sender: Any) {
        if passwordTF.text!.count < 8 {
            alertNetwork(message: "Пароль должен быть не менее 8 символов с одной заглавной и одной прописной буквой")
        }
    }
    
    @IBAction func pressRegisterButton(_ sender: Any) {
        if emailTF.text! != nil && passwordTF.text! != nil && confirmPasswordTF.text! != nil {
            reigisterUser()
        }else {
            alertNetwork(message: "Пожалуста, заполните поля выше")}
    }
    
}

//MARK: Check Input
extension RegisterVC {
    //    private func checkValidity(email: String, password: String, confirmPassword: String) -> Bool  {
    //        guard let email = email, let password = password, let confirmPassword = confirmPassword  else {
    //            return false
    //        }
    //
    //        if email.isValidEmail() == true && password.isValidPassword(password) == true && password.isValidPassword(password) == true {
    //            return(true)
    //        }
    //    }
    //    @objc func textFieldDidChange(textField: UITextField) {
    //    }
    //
    //    @objc func editingChanged(_ textField: UITextField) {
    //        if textField.text?.count == 1 {
    //            if textField.text?.first == " " {
    //                textField.text = ""
    //                return
    //            }
    //        }
    //    }
}

//MARK: Network
extension RegisterVC {
    private func reigisterUser() {
        networkManagerLogin.registerUser(email: emailTF.text!, password: passwordTF.text!, confirmPassword: confirmPasswordTF.text!) { [weak self] (message, error)  in
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
extension RegisterVC  {
    func alertNetwork(message: String) {
        UIAlertController.alert(title:"Error", msg:"\(message)", target: self)
    }
}
