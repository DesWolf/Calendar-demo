//
//  NotificationTVCell.swift
//  Calendar demo
//
//  Created by Максим Окунеев on 4/25/20.
//  Copyright © 2020 Максим Окунеев. All rights reserved.
//

import UIKit

class NotificationCell: UITableViewCell {

    @IBOutlet var notificationLabel: UILabel!

    func configere(with notification: NotificationModel) {
        self.notificationLabel.text = notification.name
    }
}
