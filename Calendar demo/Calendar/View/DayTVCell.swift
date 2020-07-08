//
//  DayTVCell.swift
//  Calendar demo
//
//  Created by Максим Окунеев on 4/24/20.
//  Copyright © 2020 Максим Окунеев. All rights reserved.
//

import UIKit

class DayTVCell: UITableViewCell {
    
    @IBOutlet weak var statusImage: UIImageView!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var payStatusLabel: UILabel!
    
    func configere(with meeting: LessonModel) {
        textLesson(meeting: meeting)
        colourLesson(meeting: meeting)
    }
}

extension DayTVCell {
    
    private func textLesson(meeting: LessonModel) {
        startTimeLabel.text         = Date().time(str: meeting.startDate)
        endTimeLabel.text           = Date().time(str: meeting.endDate)
        
        if meeting.studentName != nil {
            nameLabel.text          = "Урок с \(meeting.studentName ?? "") \(meeting.studentSurname ?? "")"
            descLabel.text          = meeting.discipline ?? ""
            payStatusLabel.text     = meeting.payStatus == 1 ? "Оплаченно" : "Не оплаченно"
            priceLabel.text         = "\(meeting.price ?? 0) руб."
            
        } else if meeting.studentName == nil && meeting.lessonName == nil {
            nameLabel.text          = "Личное"
            descLabel.text          = "мероприятие"
            
        } else if meeting.studentName == nil && meeting.lessonName != nil {
            nameLabel.text          = meeting.lessonName ?? ""
            descLabel.text          = "Личное"
        }
    }
    
    private func colourLesson(meeting: LessonModel) {
        
        let now = Date()
        let lessonDate = Date().convertStrToDate(str: meeting.startDate)
        
        if lessonDate > now {
            statusImage.backgroundColor         = meeting.studentName == nil ? .appBlueDark : .appGreen
            payStatusLabel.textColor            = meeting.payStatus == 1 ? UIColor.systemGreen : UIColor.systemRed
            
        } else {
            statusImage.backgroundColor         = .lightGray
            startTimeLabel.textColor            = .lightGray
            nameLabel.textColor                 = .lightGray
            priceLabel.textColor                = .lightGray
            payStatusLabel.textColor            = meeting.payStatus == 1 ? UIColor.lightGray : UIColor.systemRed
        }
    }
}
