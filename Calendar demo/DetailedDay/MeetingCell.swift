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
    
    func configere(with meeting: MeetingModel) {
        self.timeOfMeetingLabel.text = "\(meeting.meetingDate)"
        self.meetingTextLabel.text = "\(meeting.studentName) \(meeting.studentSurname)"
    }
}
