//
//  DisciplinesTVCell.swift
//  Calendar demo
//
//  Created by Максим Окунеев on 5/29/20.
//  Copyright © 2020 Максим Окунеев. All rights reserved.
//

import UIKit

class DisciplinesTVCell: UITableViewCell {
    
    @IBOutlet weak var disciplineLabel: UILabel!
    @IBOutlet weak var checkImage: UIImageView!
    
    func configure(discipline: String, image: UIImage) {
        disciplineLabel.text = discipline
        checkImage.image = image
    }
}


