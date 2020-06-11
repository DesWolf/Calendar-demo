//
//  DayTVCell.swift
//  Calendar demo
//
//  Created by Максим Окунеев on 4/24/20.
//  Copyright © 2020 Максим Окунеев. All rights reserved.
//

import UIKit

class DayTVCell: UITableViewCell {

    @IBOutlet var studentNameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var meetingLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func configere(with meeting: CalendarModel) {
        let startTime = "1" //"\(meeting.duration?.dateStart[11..<16] ?? "10:00")"
        let endTime =  "2" //"\(meeting.duration?.dateEnd[11..<16] ?? "11:00")"

        self.timeLabel.text = "\(startTime)-\(endTime)"
        self.studentNameLabel.text = "\(meeting.studentName ?? "test")"
        self.meetingLabel.text = "\(meeting.note ?? "test")"
}
}
