//
//  ContactsTVCell.swift
//  Calendar demo
//
//  Created by Максим Окунеев on 5/14/20.
//  Copyright © 2020 Максим Окунеев. All rights reserved.
//

import UIKit

class ContactsTVCell: UITableViewCell {
       
    @IBOutlet var userNameLabel: UILabel!
     
    func configere( with user: Student) {
        self.userNameLabel.text = "\(user.name ?? "") \(user.surname ?? "")"
        }
    }
