//
//  NotificationTVCell.swift
//  Calendar demo
//
//  Created by Максим Окунеев on 6/12/20.
//  Copyright © 2020 Максим Окунеев. All rights reserved.
//

import UIKit

class NotificationTVCell: UITableViewCell {
    
    @IBOutlet weak var notificationLabel: UILabel!
    @IBOutlet weak var checkImage: UIImageView!
    
    func configure(notification: String, image: UIImage?) {
        notificationLabel.text = notification
        checkImage.image = image
    }
}
