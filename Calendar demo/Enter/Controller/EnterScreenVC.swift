//
//  LoginVC.swift
//  Calendar demo
//
//  Created by Максим Окунеев on 4/21/20.
//  Copyright © 2020 Максим Окунеев. All rights reserved.
//
//
import UIKit

class EnterScreenVC: UIViewController {

    var onEnterButtonTap: (() -> (Void))?
    var onRegisterButtonTap: (() -> (Void))?
    
    
  override func viewDidLoad() {
        super.viewDidLoad()
        
    
    }
    
    @IBAction func enterTap(_ sender: Any) { onEnterButtonTap?() }
    
    @IBAction func registerTap(_ sender: Any) { onRegisterButtonTap?() }
}

