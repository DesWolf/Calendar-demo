//
//  StatisticTableViewCell.swift
//  Calendar demo
//
//  Created by Максим Окунеев on 9/6/20.
//  Copyright © 2020 Максим Окунеев. All rights reserved.
//

import UIKit

class StatisticCell: UITableViewCell {

    @IBOutlet weak var statisticName: UILabel!
    @IBOutlet weak var statisticNumber: UILabel!
    
    func configere(name: String, number: Int) {
        self.statisticName.text = name
//        self.statisticNumber.text = number
    }
}
