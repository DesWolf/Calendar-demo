//
//  LoginTVController.swift
//  Calendar demo
//
//  Created by Максим Окунеев on 5/15/20.
//  Copyright © 2020 Максим Окунеев. All rights reserved.
//

import UIKit

class LoginTVController: UITableViewController {
    
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var confirmPasswordTF: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var navTitle: UINavigationItem!
    @IBOutlet weak var changeFormLabel: UILabel!
    @IBOutlet weak var changeFormButton: UIButton!
    
    private var email = ""
    private var password = ""
    private var confirmPassword = ""
    private let networkManagerLogin = NetworkManagerLogin()
    private var confirmPasswordField = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let textFields = [emailTF, passwordTF, confirmPasswordTF]
        for textField in textFields {
            textField!.addTarget(self, action: #selector(LoginTVController.textFieldDidChange(textField:)),
                                 for: UIControl.Event.editingDidEnd)
        }
        
        emailTF.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        passwordTF.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        confirmPasswordTF.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    @IBAction func loginButtonAction(_ sender: Any) {
        reigisterUser()
    }
    
//    @IBAction func changeRegistrationToLogin(_ sender: Any) {
//
//        if confirmPasswordField == false {
//            self.navTitle.title = "Регистрация"
//            self.loginButton.titleLabel?.text = "Войти"
//            self.changeFormLabel.text = "У вас уже есть учетная запись?"
//            self.changeFormButton.setTitle("Войти", for: .normal)
//            confirmPasswordField = true
//        } else {
//            self.navTitle.title = "Вход"
//            self.loginButton.titleLabel?.text = "Зарегистрироваться"
//            self.changeFormLabel.text = "Хотите зарегистрироваться?"
//            self.changeFormButton.setTitle("Зарегистрироваться", for: .normal)
//
//            confirmPasswordField = false
//        }
//        self.tableView.reloadData()
//    }
    
    @objc func textFieldDidChange(textField: UITextField) {
    }
    
    @objc func editingChanged(_ textField: UITextField) {
        if textField.text?.count == 1 {
            if textField.text?.first == " " {
                textField.text = ""
                return
            }
        }
    }
}

//MARK: TableViewDelegate, TableViewDataSource
extension LoginTVController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch  indexPath.row {
        case 2:
            return CGFloat(confirmPasswordField ? 100.0 : 0.0)
        default:
            return super.tableView(tableView, heightForRowAt: indexPath)
        }
    }
  
}


//MARK: Network
extension LoginTVController {
    private func reigisterUser() {
        networkManagerLogin.registerUser(email: email, password: password, confirmPassword: confirmPassword) { [weak self] (message, error)  in
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
extension LoginTVController  {
    func alertNetwork(message: String) {
        UIAlertController.alert(title:"Error", msg:"\(message)", target: self)
    }
}
