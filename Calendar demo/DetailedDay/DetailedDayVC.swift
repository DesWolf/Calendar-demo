//
//  DetailedDayVC.swift
//  Calendar demo
//
//  Created by Максим Окунеев on 4/21/20.
//  Copyright © 2020 Максим Окунеев. All rights reserved.
//

import UIKit

class DetailedDayVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var todayMeetings = [DayModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fetchCalendar()
        tableView.reloadData()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

//MARK: Network
extension DetailedDayVC {
    private func fetchCalendar() {
        DetailedDayService.fetchCalendar { (jsonData) in
            let date = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            let result = formatter.string(from: date)
            print(result)
            self.todayMeetings = jsonData.filter{ $0.date == result }
            print(self.todayMeetings)
            
            self.tableView.reloadData()
            self.tableView.tableFooterView = UIView()
        }
    }
}

// MARK: TableViewDataSource & TableViewDelegate
extension DetailedDayVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        todayMeetings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "meetingCell", for: indexPath) as! MeetingCell
        let meeting = todayMeetings[indexPath.row]
        
        cell.configere(with: meeting)
        
        return cell
    }
}

