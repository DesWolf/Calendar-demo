//
//  DetailedDayVC.swift
//  Calendar demo
//
//  Created by Максим Окунеев on 4/21/20.
//  Copyright © 2020 Максим Окунеев. All rights reserved.
//

import UIKit

class DetailedDayVC: UIViewController {
    
    @IBOutlet weak var todayTableView: UITableView!
    @IBOutlet weak var todayLabel: UILabel!
    @IBOutlet var numberOfTodayTask: UILabel!
    @IBOutlet var nextmeetingLabel: UILabel!
    @IBOutlet var notificationsTableView: UITableView!
    
    var todayMeetings = [DayModel]()
    var notifications: [NotificationModel] = [NotificationModel(name: "Через 2 дня необходимо оплатить налог 1430 руб. за Май"), NotificationModel(name: "Сегодня у Чебурашки последнее предоплаченное занятие")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        todayLabel.text = self.todayString(format: "dd MMMM YYYY")
        fetchCalendar()
        todayTableView.reloadData()
    }
}

//MARK: Network
extension DetailedDayVC {
    private func fetchCalendar() {
        DetailedDayService.fetchCalendar { (jsonData) in
            let today = self.todayString(format: "yyyy-MM-dd")
            self.todayMeetings = jsonData.filter{ $0.date == today }
            //            self.todayMeetings.sort() { $0.duration?.dateStart < $1.duration?.dateStart }
            
            self.todayTableView.reloadData()
            self.todayTableView.tableFooterView = UIView()
        }
    }
}

// MARK: TableViewDataSource & TableViewDelegate
extension DetailedDayVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == todayTableView {
            numberOfTodayTask.text = "\(todayMeetings.count)"
            return todayMeetings.count
        } else {
            return notifications.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == todayTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "todayMeetingCell", for: indexPath) as! MeetingCell
            let meeting = todayMeetings[indexPath.row]
            cell.configere(with: meeting)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "notificationsCell", for: indexPath) as! NotificationCell
            let notification = notifications[indexPath.row]
            cell.configere(with: notification)
            return cell
        }
    }
}

extension DetailedDayVC {
    func todayString(format: String) -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = format
        
        return formatter.string(from: date)
    }
}


