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
    @IBOutlet weak var endRepeatLabel: UILabel!
    @IBOutlet weak var endRepeatPicker: UIDatePicker!
    
    var repeatLesson: RepeatLesson = .never
    var endOfRepeat: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureScreen()
    }
    
    @IBAction func endDateChanged(sender: UIDatePicker) {
        endRepeatLabel.text = displayedDate(str: "\(endRepeatPicker.date)")
        endOfRepeat = "\(endRepeatPicker.date)"
    }
}

//MARK: Set Screen
extension RepeatTVC {
    private func configureScreen() {
        setupNavigationBar()
        setupPicker()

        if repeatLesson == .never {
            neverCheckImage.image =  #imageLiteral(resourceName: "check")
        }  else {
            everyWeekCheckImage.image = #imageLiteral(resourceName: "check")
        }
    }
    
    private func setupNavigationBar(){
        let nav = self.navigationController?.navigationBar
        nav?.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.black]
    }
    
    private func setupPicker() {
        let oneMonth = TimeInterval(60 * 60 * 24 * 30)

        endRepeatLabel.text = displayedDate(str: "\(endRepeatPicker.date.addingTimeInterval(oneMonth))")
        endRepeatLabel.isHidden = true
        
        endRepeatPicker.datePickerMode = .date
        endRepeatPicker.setDate(Date().addingTimeInterval(oneMonth), animated: true)
        endRepeatPicker.isHidden = true
    }
    
    private func displayedDate(str: String) -> String {
       return Date().convertStrDate(date: str, formatFrom: "yyyy-MM-dd HH:mm:ssZ", formatTo: "dd.MM.yyyy")
        
    }
}

//MARK: TableViewDelegate, TableViewDataSource
extension RepeatTVC {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.row{
        case 2:
            return CGFloat(endRepeatLabel.isHidden ? 0.0 : 44.0)
        case 3:
            return CGFloat(endRepeatPicker.isHidden ? 0.0 : 216.0)
        default:
            return super.tableView(tableView, heightForRowAt: indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            repeatLesson = .never
            neverCheckImage.image =  #imageLiteral(resourceName: "check")
            everyWeekCheckImage.image = UIImage()
            if !endRepeatLabel.isHidden {
                endRepeatLabel.isHidden = true
                endRepeatPicker.isHidden = true
                pickerAnimation(indexPath: indexPath)
            }
        case 1:
            repeatLesson = .weekly
            neverCheckImage.image = UIImage()
            everyWeekCheckImage.image = #imageLiteral(resourceName: "check")
            if endRepeatLabel.isHidden {
                endRepeatLabel.isHidden = false
                endRepeatPicker.isHidden = false
                pickerAnimation(indexPath: indexPath)
            }
        default:
            return
        }
    }
    
    func pickerAnimation(indexPath: IndexPath) {
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.tableView.beginUpdates()
            self.tableView.deselectRow(at: indexPath as IndexPath, animated: true)
            self.tableView.endUpdates()
        })
    }
}
