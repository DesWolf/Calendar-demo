//
//  DayTVCell.swift
//  Calendar demo
//
//  Created by Максим Окунеев on 4/24/20.
//  Copyright © 2020 Максим Окунеев. All rights reserved.
//

import UIKit

class LessonTVCell: UITableViewCell {
    
    @IBOutlet weak var backCellView: UIView!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var payStatusLabel: UILabel!
    
    func configere(with meeting: LessonModel) {
        textLesson(meeting: meeting)
        colourLesson(meeting: meeting)
        
        backCellView.backgroundColor = .appBackGray
        backCellView.layer.cornerRadius = 5
        backCellView.layer.borderColor = UIColor.fieldBorder.cgColor
        backCellView.layer.borderWidth = 0.5
        
        self.backCellView.layer.masksToBounds = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        priceLabel.text = nil
        payStatusLabel.text = nil
    }
}

extension LessonTVCell {
    
    private func textLesson(meeting: LessonModel) {
        startTimeLabel.text         = Date().str(str: meeting.startDate, to: .time)
        endTimeLabel.text           = Date().str(str: meeting.endDate, to: .time)
        
        if meeting.studentName != nil {
            nameLabel.text          = "Урок с \(meeting.studentName ?? "") \(meeting.studentSurname ?? "")"
            descLabel.text          = meeting.discipline ?? ""
            payStatusLabel.text     = meeting.payStatus == 1 ? "Оплачено" : "Не оплачено"
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
        let lessonDate = Date().strToDate(str: meeting.endDate)
        
        if lessonDate > now {
            statusView.backgroundColor         = meeting.studentName != nil ? .appBlue : .systemPink
            payStatusLabel.textColor            = meeting.payStatus == 1 ? UIColor.systemGreen : UIColor.systemRed
            
        } else {
            statusView.backgroundColor          = .lightGray
            startTimeLabel.textColor            = .lightGray
            nameLabel.textColor                 = .lightGray
            priceLabel.textColor                = .lightGray
            payStatusLabel.textColor            = meeting.payStatus == 1 ? UIColor.lightGray : UIColor.systemRed
        }
    }
}
