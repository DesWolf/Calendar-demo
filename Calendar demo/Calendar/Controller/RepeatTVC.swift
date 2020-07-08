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
        endRepeatLabel.text     = Date().date(str: "\(endRepeatPicker.date)")
        endOfRepeat             = Date().date(str: "\(endRepeatPicker.date)")
    }
}

//MARK: Set Screen
extension RepeatTVC {
    private func configureScreen() {
        setupNavigationBar()
        
        if repeatLesson.rawValue == RepeatLesson.never.rawValue {
            neverCheckImage.image =  #imageLiteral(resourceName: "check")
            repeatLesson = .never
        }  else {
            everyWeekCheckImage.image = #imageLiteral(resourceName: "check")
            repeatLesson = .weekly
        }
        
        setupPicker(str: endOfRepeat ?? "")
    }
    
    private func setupNavigationBar(){
        let navBar = self.navigationController?.navigationBar
        
        navBar?.setBackgroundImage(UIImage(), for: .default)
        navBar?.shadowImage = UIImage()
        navBar?.isTranslucent = true
        navBar?.prefersLargeTitles = false
        navBar?.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.black]
    }
    
    private func setupPicker(str: String) {
        let oneMonth = TimeInterval(60 * 60 * 24 * 30)
        endRepeatPicker.minuteInterval = 5
        
        if repeatLesson.rawValue == RepeatLesson.never.rawValue {
            repeatLesson                    = .never
            endRepeatLabel.text             = Date().date(str: "\(endRepeatPicker.date.addingTimeInterval(oneMonth))")
            endRepeatLabel.isHidden         = true
            
            endRepeatPicker.datePickerMode  = .date
            endRepeatPicker.isHidden        = true
            
            endRepeatPicker.setDate(Date().addingTimeInterval(oneMonth), animated: true)
        } else {
            repeatLesson                    = .weekly
            endRepeatLabel.text             = endOfRepeat
            endRepeatLabel.isHidden         = false
            
            endRepeatPicker.datePickerMode  = .date
            endRepeatPicker.isHidden        = false
            
            endRepeatPicker.setDate(Date().convertStrToDate(str: endOfRepeat), animated: true)
        }
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
            repeatLesson                    = .never
            neverCheckImage.image           =  #imageLiteral(resourceName: "check")
            everyWeekCheckImage.image       = UIImage()
            
            if !endRepeatLabel.isHidden {
                endRepeatLabel.isHidden     = true
                endRepeatPicker.isHidden    = true
                pickerAnimation(indexPath: indexPath)
            }
        case 1:
            repeatLesson                    = .weekly
            neverCheckImage.image           = UIImage()
            everyWeekCheckImage.image       = #imageLiteral(resourceName: "check")
            
            if endRepeatLabel.isHidden {
                endRepeatLabel.isHidden     = false
                endRepeatPicker.isHidden    = false
                endOfRepeat                 = Date().date(str: "\(endRepeatPicker.date)")
                
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
