//
//  RepeatTVC.swift
//  Calendar demo
//
//  Created by Максим Окунеев on 6/8/20.
//  Copyright © 2020 Максим Окунеев. All rights reserved.
//

import UIKit

enum RepeatLesson: String {
    case never = "Никогда"
    case weekly = "Каждую неделю"
}

class RepeatTVC: UITableViewController {
    
    @IBOutlet weak var neverCheckImage: UIImageView!
    @IBOutlet weak var everyWeekCheckImage: UIImageView!
    
    var repeatLesson: RepeatLesson = .never
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(repeatLesson.rawValue)
        configureScreen()
    }
}

//MARK: Set Screen
extension RepeatTVC {
    private func configureScreen() {
        setupNavigationBar()
        
        if repeatLesson == .never {
            neverCheckImage.image =  #imageLiteral(resourceName: "check")
        }  else {
            everyWeekCheckImage.image = #imageLiteral(resourceName: "check")
            }
        everyWeekCheckImage.image = UIImage()
    }
    
    private func setupNavigationBar(){
        let nav = self.navigationController?.navigationBar
 
        nav?.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.black]
        nav?.topItem?.title = "Повтор"
    }
}

// MARK: - Table view data source
extension RepeatTVC {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            repeatLesson = .never
            neverCheckImage.image =  #imageLiteral(resourceName: "check")
            everyWeekCheckImage.image = UIImage()
        case 1:
            repeatLesson = .weekly
            neverCheckImage.image = UIImage()
            everyWeekCheckImage.image = #imageLiteral(resourceName: "check")
        default:
            return
        }
    }
}

