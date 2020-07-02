//
//  AlertService.swift
//  Calendar demo
//
//  Created by Максим Окунеев on 5/14/20.
//  Copyright © 2020 Максим Окунеев. All rights reserved.
//

import UIKit

extension UIAlertController {
    class func simpleAlert(title:String, msg:String, target: UIViewController) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default) {
            (result: UIAlertAction) -> Void in
        })
        
        target.present(alert, animated: true, completion: nil)
    }
    
    class func addTextAlert(title:String, target: UIViewController, actionHandler: ((_ text: String?) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: "", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "Добавьте дисциплину..."
        })
        
        alert.addAction(UIAlertAction(title: "Добавить", style: .default, handler: { (action:UIAlertAction) in
            guard let textField =  alert.textFields?.first else {
                actionHandler?(nil)
                return
            }
            actionHandler?(textField.text)
        }))
        target.present(alert, animated: true, completion: nil)
    }
}
