//
//  DayTVCell.swift
//  Calendar demo
//
//  Created by Максим Окунеев on 4/24/20.
//  Copyright © 2020 Максим Окунеев. All rights reserved.
//

import UIKit

class DayTVCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    
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
        
        self.timeLabel.text = "\(startTime) - \(endTime)"
        self.nameLabel.text = name
        self.descLabel.text = description
    }
}
