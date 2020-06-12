//
//  NotificationTVC.swift
//  Calendar demo
//
//  Created by Максим Окунеев on 6/12/20.
//  Copyright © 2020 Максим Окунеев. All rights reserved.
//

import UIKit

class NotificationTVC: UITableViewController {
    
    var listOfNotification = ["Нет", "За 5 мин","За 15 мин","За 30 мин","За 1 час","За 2 часа","За 1 день","За 2 день"]
    public var selectedNotification = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        print(selectedNotification)
        configureScreen()
    }
}

// MARK:  Set Screen
extension NotificationTVC {
    private func configureScreen() {
        setupNavigationBar()
        
    }
    
    private func setupNavigationBar(){
        let nav = self.navigationController?.navigationBar
        nav?.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.black]
    }
}


// MARK:  Table view data source
extension NotificationTVC {
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return listOfNotification.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "notificationCell", for: indexPath) as! NotificationTVCell
        let notif = listOfNotification[indexPath.row]
        var image = UIImage()
        
        if selectedNotification == notif {
            image = #imageLiteral(resourceName: "check")
        }
        
        cell.configure(notification: notif, image: image)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.dequeueReusableCell(withIdentifier: "notificationCell", for: indexPath) as! NotificationTVCell
        let notif = listOfNotification[indexPath.row]
        
        if notif == selectedNotification {
            cell.checkImage.image = nil
            selectedNotification = ""
        } else {
            cell.checkImage.image = #imageLiteral(resourceName: "check")
            selectedNotification = notif
        }
        tableView.reloadData()
    }
}
