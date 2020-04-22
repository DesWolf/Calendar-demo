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
    
    var meetings = [MeetingModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()


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

// MARK: TableViewDataSource & TableViewDelegate
extension DetailedDayVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        meetings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "meetingCell", for: indexPath) as! MeetingCell
        let meeting = meetings[indexPath.row]
        
        cell.configere(with: meeting)
        
        return cell
    }
}

