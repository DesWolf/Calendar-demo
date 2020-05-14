//
//  LoginVC.swift
//  Calendar demo
//
//  Created by Максим Окунеев on 4/20/20.
//  Copyright © 2020 Максим Окунеев. All rights reserved.
//

//import UIKit
//
//class LoginVCCode: UIViewController {
//    
//    @IBOutlet var mainView: UIView!
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        greetingsLabel()
//        greatingsImagePlace()
//        registrationButtonPlace()
//        loginButtonPlace()
//        infoLabelPlace()
//    }
//}
//
//extension LoginVC {
//    
//     func greetingsLabel() {
//        let greatingsLabel = UILabel()
//        greatingsLabel.frame = CGRect(x: 0, y: 0, width: 269, height: 66)
//        greatingsLabel.backgroundColor = .white
//        greatingsLabel.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
//        greatingsLabel.font = UIFont(name: "Helvetica Neue", size: 24)
//        
//        greatingsLabel.numberOfLines = 0
//        greatingsLabel.lineBreakMode = .byWordWrapping
//        greatingsLabel.textAlignment = .center
//        greatingsLabel.attributedText = NSMutableAttributedString(string: "Добро пожаловать\nв Teachorg", attributes: [NSAttributedString.Key.kern: 0.87])
//        
//        let parent = self.mainView!
//        parent.addSubview(greatingsLabel)
//        greatingsLabel.translatesAutoresizingMaskIntoConstraints = false
//        greatingsLabel.heightAnchor.constraint(equalToConstant: 60).isActive = true
//        greatingsLabel.centerXAnchor.constraint(equalTo: parent.centerXAnchor, constant: 0).isActive = true
//        greatingsLabel.topAnchor.constraint(equalTo: parent.topAnchor, constant: 120).isActive = true
//    }
//    
//    func greatingsImagePlace() {
//        let greetingsImage = UIImageView()
//        greetingsImage.image = #imageLiteral(resourceName: "greetingsImage")
//        greetingsImage.frame = CGRect(x: 0, y: 0, width: 338.6, height: 241.32)
//        greetingsImage.backgroundColor = .white
//        
//        var parent = self.mainView!
//        parent.addSubview(greetingsImage)
//        
//        greetingsImage.translatesAutoresizingMaskIntoConstraints = false
//        greetingsImage.widthAnchor.constraint(equalToConstant: 338.6).isActive = true
//        greetingsImage.heightAnchor.constraint(equalToConstant: 241.32).isActive = true
//        greetingsImage.centerXAnchor.constraint(equalTo: parent.centerXAnchor, constant: 0).isActive = true
//        greetingsImage.topAnchor.constraint(equalTo: parent.topAnchor, constant: 245).isActive = true
//    }
//    
//    private func registrationButtonPlace() {
//        let registrationButton = UIButton(frame: CGRect(x: 0, y: 0, width: 343, height: 57))
//        registrationButton.setImage(#imageLiteral(resourceName: "registerButton"), for: .normal)
//        registrationButton.addTarget(self, action: #selector(self.regButtonClicked), for: .touchUpInside)
//        
//        let parent = self.mainView!
//        parent.addSubview(registrationButton)
//        
//        registrationButton.translatesAutoresizingMaskIntoConstraints = false
//        registrationButton.widthAnchor.constraint(equalToConstant: 343).isActive = true
//        registrationButton.heightAnchor.constraint(equalToConstant: 57).isActive = true
//        registrationButton.centerXAnchor.constraint(equalTo: parent.centerXAnchor, constant: 0).isActive = true
//        registrationButton.bottomAnchor.constraint(equalTo: parent.bottomAnchor, constant: -200).isActive = true
//        }
//    
//    @objc private func regButtonClicked() {
//        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//
//        let registerVC = storyBoard.instantiateViewController(withIdentifier: "RegisterVC") as! RegisterVC
//        self.present(registerVC, animated:true, completion:nil)
//    }
//    
//    private func loginButtonPlace() {
//        let loginButton = UIButton(frame: CGRect(x: 0, y: 0, width: 343, height: 57))
//        loginButton.setImage(#imageLiteral(resourceName: "enterButton"), for: .normal)
//        loginButton.addTarget(self, action: Selector(("LoginButtonTouched:")), for: UIControl.Event.touchUpInside)
//        
//        let parent = self.mainView!
//        parent.addSubview(loginButton)
//        
//        loginButton.translatesAutoresizingMaskIntoConstraints = false
//        loginButton.widthAnchor.constraint(equalToConstant: 343).isActive = true
//        loginButton.heightAnchor.constraint(equalToConstant: 57).isActive = true
//        loginButton.centerXAnchor.constraint(equalTo: parent.centerXAnchor, constant: 0).isActive = true
//        loginButton.bottomAnchor.constraint(equalTo: parent.bottomAnchor, constant: -140).isActive = true
//        }
//    
//    private func infoLabelPlace(){
//       
//        let infoLabel = UILabel()
//        infoLabel.frame = CGRect(x: 0, y: 0, width: 341, height: 26)
//        infoLabel.backgroundColor = .white
//        infoLabel.textColor = UIColor(red: 0.282, green: 0.282, blue: 0.29, alpha: 1)
//        infoLabel.font = UIFont(name: "Helvetica Neue", size: 11)
//        
//        infoLabel.numberOfLines = 0
//        infoLabel.lineBreakMode = .byWordWrapping
//        infoLabel.textAlignment = .center
//
//        infoLabel.attributedText = NSMutableAttributedString(
//            string: "Используя данное приложение, я даю своё согласие на обработку моих персональных данных.",
//            attributes: [NSAttributedString.Key.kern: 0.07])
//        
//        let parent = self.mainView!
//        parent.addSubview(infoLabel)
//        infoLabel.translatesAutoresizingMaskIntoConstraints = false
//        infoLabel.widthAnchor.constraint(equalToConstant: 343).isActive = true
//        infoLabel.heightAnchor.constraint(equalToConstant: 57).isActive = true
//        infoLabel.centerXAnchor.constraint(equalTo: parent.centerXAnchor, constant: 0).isActive = true
//        infoLabel.bottomAnchor.constraint(equalTo: parent.bottomAnchor, constant: -85).isActive = true
//    }
//    }
//
