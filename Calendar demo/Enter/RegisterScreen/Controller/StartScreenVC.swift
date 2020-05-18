//
//  LoginVC.swift
//  Calendar demo
//
//  Created by Максим Окунеев on 4/21/20.
//  Copyright © 2020 Максим Окунеев. All rights reserved.
//
//
//import UIKit
//
//class StartScreenVC: UIViewController {
//
//    @IBOutlet weak var emailTF: UITextField!
//    @IBOutlet weak var passwordTF: UITextField!
//
//    private var email: String = "ok@mail.ru"
//    private var password: String = "Aa12345678"
//    private let networkManagerLogin = NetworkManagerLogin()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//    }
//
//    @IBAction func pressEnterButton(_ sender: Any) {
//        loginUser()
//    }
//
//}
//
////MARK: Network
//extension StartScreenVC {
//    private func loginUser() {
//        networkManagerLogin.loginUser(email: email, password: password) { [weak self] (message, error)  in
//            guard let message = message else {
//                print(error ?? "")
//                    DispatchQueue.main.async {
//                        self?.alertNetwork(message: error ?? "")
//                    }
//                    return
//                }
//            print(message)
//        }
//    }
//}
//
////MARK: Alert
//extension StartScreenVC  {
//    func alertNetwork(message: String) {
//        UIAlertController.alert(title:"Error", msg:"\(message)", target: self)
//    }
//}
