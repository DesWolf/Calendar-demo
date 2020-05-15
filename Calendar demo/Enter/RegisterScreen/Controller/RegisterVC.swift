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
    
    private var email: String = "ossqqk@mail.ru"
    private var password: String = "Aa12345678"
    private var confirmPassword: String = "Aa12345678"
    
    private let networkManagerLogin = NetworkManagerLogin()
    override func viewDidLoad() {
        super.viewDidLoad()

      
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func pressRegisterButton(_ sender: Any) {
        reigisterUser()
    }
    
}

//MARK: Network
extension RegisterVC {
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
extension RegisterVC  {
    func alertNetwork(message: String) {
        UIAlertController.alert(title:"Error", msg:"\(message)", target: self)
    }
}
