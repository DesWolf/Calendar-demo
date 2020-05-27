//
//  DisciplinesCollectionViewCell.swift
//  Calendar demo
//
//  Created by Максим Окунеев on 5/27/20.
//  Copyright © 2020 Максим Окунеев. All rights reserved.
//

import UIKit

class DisciplinesCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var textLabel: UILabel!
    
    
    func configere(with discipline: String) {
        
        textLabel.text = discipline
        
    }
}
