//
//  NotificationTVC.swift
//  Calendar demo
//
//  Created by Максим Окунеев on 6/12/20.
//  Copyright © 2020 Максим Окунеев. All rights reserved.
//

import UIKit

class NotificationTVC: UITableViewController {
       
    var listOfNotif: [NotifModel] = [NotifModel(name: "Нет", description: "Нет", seconds: 0),
                                     NotifModel(name: "5 сек", description: "За 5 сек", seconds: 5), // для теста, удалить
                                     NotifModel(name: "5 мин", description: "За 5 мин", seconds: 60 * 5),
                                     NotifModel(name: "15 мин", description: "За 15 мин", seconds: 60 * 15),
                                     NotifModel(name: "30 мин", description: "За 30 мин", seconds: 60 * 30),
                                     NotifModel(name: "1 час", description: "За 1 час", seconds: 60 * 60),
                                     NotifModel(name: "2 часа", description: "За 2 часа", seconds: 60 * 60 * 2),
                                     NotifModel(name: "1 день", description: "За 1 день", seconds: 60 * 60 * 24),
                                     NotifModel(name: "2 дня", description: "За 2 дня", seconds: 60 * 60 * 24 * 2)]
    
    public var selectedNotification = ""
    public var notifInSeconds = 0.0
    
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
        let navBar = self.navigationController?.navigationBar
        
        navBar?.setBackgroundImage(UIImage(), for: .default)
        navBar?.shadowImage = UIImage()
        navBar?.isTranslucent = true
        navBar?.prefersLargeTitles = false
        
        navBar?.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.black]
    }
}


// MARK:  Table view data source
extension NotificationTVC {
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return listOfNotif.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "notificationCell", for: indexPath) as! NotificationTVCell
        let notif = listOfNotif[indexPath.row]
        
        var image = UIImage()
        
        if notifInSeconds == notif.seconds {
            image = #imageLiteral(resourceName: "check")
        }
        
        cell.configure(notification: notif.description, image: image)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.dequeueReusableCell(withIdentifier: "notificationCell", for: indexPath) as! NotificationTVCell
        let notif = listOfNotif[indexPath.row]
        
        if notif.seconds == notifInSeconds {
            cell.checkImage.image = nil
            notifInSeconds = 0
            selectedNotification = "Нет"
        } else {
            cell.checkImage.image = #imageLiteral(resourceName: "check")
            notifInSeconds = notif.seconds
            selectedNotification = notif.name
        }
        tableView.reloadData()
    }
}
