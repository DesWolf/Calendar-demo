//
//  DayTVCell.swift
//  Calendar demo
//
//  Created by Максим Окунеев on 4/24/20.
//  Copyright © 2020 Максим Окунеев. All rights reserved.
//

import UIKit

class DayTVCell: UITableViewCell {
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    
    func configere(with meeting: LessonModel) {
        let startTime =  serverHour(str: meeting.timeStart ?? "00:00:00")
        let endTime =    serverHour(str: meeting.timeEnd ?? "01:00:00")
        var name = ""
        var description = ""
        
        if meeting.studentName == nil {
            name = meeting.lessonName ?? ""
            description = "Личное"
        } else {
            name = "Урок с \(meeting.studentName ?? "") \(meeting.studentSurname ?? "")"
            description = meeting.discipline ?? ""
        }
        
        self.timeLabel.text = "\(startTime) - \(endTime)"
        self.nameLabel.text = name
        self.descLabel.text = description
    }
    
    
    private func serverHour(str: String) -> String {
        return Date().convertStrDate(date: str, formatFrom: "HH:mm:ss", formatTo: "HH:mm")
    }
}
