//
//  MeetingCell.swift
//  Calendar demo
//
//  Created by Максим Окунеев on 4/21/20.
//  Copyright © 2020 Максим Окунеев. All rights reserved.
//

import UIKit

class MeetingCell: UITableViewCell {

    @IBOutlet var timeOfMeetingLabel: UILabel!
    @IBOutlet var meetingTextLabel: UILabel!
    
    func configere(with meeting: DayModel) {
        let time = "\(meeting.duration?.dateStart[11..<16] ?? "10:00")"

        print(time)
        self.timeOfMeetingLabel.text = "\(time)"
        self.meetingTextLabel.text = "\(meeting.studentId ?? "")"
    }
}

