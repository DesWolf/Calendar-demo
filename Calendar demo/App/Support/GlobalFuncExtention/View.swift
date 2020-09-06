//
//  View.swift
//  Calendar demo
//
//  Created by Максим Окунеев on 8/23/20.
//  Copyright © 2020 Максим Окунеев. All rights reserved.
//

import UIKit

extension UIView {
    func didSelect(view: UIView) {
        view.layer.cornerRadius = 10
        view.backgroundColor = .appLightBlue
        view.layer.borderColor = UIColor.clear.cgColor
    }
    
    func didDeselect(view: UIView) {
        view.layer.cornerRadius = 10
        view.backgroundColor = .fieldBackGray
        view.layer.borderColor = UIColor.fieldBorder.cgColor
        view.layer.borderWidth = 0.5
    }
}
