//
//  DayTVCell.swift
//  Calendar demo
//
//  Created by Максим Окунеев on 4/24/20.
//  Copyright © 2020 Максим Окунеев. All rights reserved.
//

import UIKit

class DayTVCell: UITableViewCell {
    
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var payStatusLabel: UILabel!
    
    func configere(with meeting: LessonModel) {
        var name: String?
        var description: String?
        let startTime       =  Date().time(str: meeting.startDate)
        let endTime         =  Date().time(str: meeting.endDate)
        
        
        if meeting.studentName == nil {
            name            = meeting.lessonName ?? ""
            description     = "Личное"
        } else {
            name            = "Урок с \(meeting.studentName ?? "") \(meeting.studentSurname ?? "")"
            description     = meeting.discipline ?? ""
        }
        
        
        payStatusLabel.textColor    = meeting.payStatus == 1 ? UIColor.systemGreen : UIColor.systemRed
        payStatusLabel.text         = meeting.payStatus == 1 ? "Оплаченно" : "Не оплаченно"
        startTimeLabel.text         = startTime
        endTimeLabel.text           = endTime
        nameLabel.text              = name
        descLabel.text              = description
    }
}
