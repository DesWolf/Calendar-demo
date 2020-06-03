//
//  PopUpVC.swift
//  Calendar demo
//
//  Created by Максим Окунеев on 6/3/20.
//  Copyright © 2020 Максим Окунеев. All rights reserved.
//

import UIKit

class PopUpVC: UIViewController {

    @IBOutlet weak var messageLablel: UILabel!
    @IBOutlet weak var messageView: UIView!
    
    var message: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        messageLablel.text = message ?? ""
      
        messageLablel.backgroundColor = .bgStudentTransperent
        messageLablel.layer.cornerRadius = 10
        messageLablel.layer.masksToBounds = true
     
        view.backgroundColor = .clear
        moveIn()
       
    }
    
    func moveIn() {
        self.view.alpha = 0.0
    
        UIView.animate(withDuration: 0.5) {
            self.view.alpha = 1.0
        }
    }
    
    func moveOut() {
        UIView.animate(withDuration: 0.5, animations: {
            self.view.alpha = 0.0
        }) { _ in
            self.view.removeFromSuperview()
        }
    }
    
    deinit {
        print("deinit", PopUpVC.self)
    }
}
