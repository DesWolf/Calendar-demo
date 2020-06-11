//
//  StudentsForLessonTableViewCell.swift
//  Calendar demo
//
//  Created by Максим Окунеев on 6/11/20.
//  Copyright © 2020 Максим Окунеев. All rights reserved.
//

import UIKit

class StudentsForLessonTVCell: UITableViewCell {
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet weak var currentDisciplineLabel: UILabel!
    @IBOutlet weak var checkBox: UIImageView!
    
    
    func configere( with user: StudentModel, image: UIImage) {
        self.nameLabel.text = "\(user.name ?? "") \(user.surname ?? "")"
        self.currentDisciplineLabel.text = user.disciplines?.joined(separator: ", ") ?? ""
        self.checkBox.image = image
    }
}
