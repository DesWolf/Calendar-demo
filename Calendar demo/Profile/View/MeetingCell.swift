//
//  MeetingCell.swift
//  Calendar demo
//
//  Created by Максим Окунеев on 4/21/20.
//  Copyright © 2020 Максим Окунеев. All rights reserved.
//

import UIKit

class ProfileCell: UITableViewCell {
    
    @IBOutlet weak var settingName: UILabel!
    @IBOutlet weak var settingImage: UIImageView!
    
    func configere(name: String, image: UIImage) {
        self.settingName.text = name
        self.settingImage.image = image
    }
}
