//
//  TypeCollectionViewCell.swift
//  Calendar demo
//
//  Created by Максим Окунеев on 8/2/20.
//  Copyright © 2020 Максим Окунеев. All rights reserved.
//

import UIKit

class TypeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var textLabel: UILabel!
    
    func configure(name: String, mode: Bool) {
        
        if mode == true {
            backgroundColor = .fieldBorder
            textLabel.textColor = .appBlue
        } else  {
//            backgroundColor = .clear
//            layer.borderColor = UIColor.fieldBorder.cgColor
//            layer.borderWidth = 0.5
            textLabel.textColor = .appTabIconGray
        }
        textLabel.text = name
    }
}
