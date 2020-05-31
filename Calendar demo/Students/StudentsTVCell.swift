//
//  ContactsTVCell.swift
//  Calendar demo
//
//  Created by Максим Окунеев on 5/14/20.
//  Copyright © 2020 Максим Окунеев. All rights reserved.
//

import UIKit

class StudentsTVCell: UITableViewCell {
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet weak var currentDisciplineLabel: UILabel!
    
    func configere( with user: StudentModel) {
        self.nameLabel.text = "\(user.name ?? "") \(user.surname ?? "")"
        self.currentDisciplineLabel.text = user.disciplines?.joined(separator: ", ") ?? ""
    }
}
