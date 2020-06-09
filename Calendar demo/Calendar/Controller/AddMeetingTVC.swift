//
//  ChangeMeetingVC.swift
//  Calendar demo
//
//  Created by Максим Окунеев on 4/21/20.
//  Copyright © 2020 Максим Окунеев. All rights reserved.
//

import UIKit

class AddMeetingTVC: UITableViewController {
    
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var placeTF: UITextField!
    @IBOutlet weak var studentLabel: UILabel!
    @IBOutlet weak var disciplineLabel: UILabel!
    @IBOutlet weak var startLessonLabel: UILabel!
    @IBOutlet weak var startLessonDatePicker: UIDatePicker!
    @IBOutlet weak var endLessonLabel: UILabel!
    @IBOutlet weak var endLessonDatePicker: UIDatePicker!
    @IBOutlet weak var repeatLessonLabel: UILabel!
    @IBOutlet weak var endOfRepeatLessonLabel: UILabel!
    @IBOutlet weak var priceTF: UITextField!
    @IBOutlet weak var notificationTypeLabel: UILabel!
    @IBOutlet weak var noteTV: UITextView!
    

    var editLesson: CalendarModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureScreen()
    }
    
    
    
    @IBAction func startDateChanged(sender: UIDatePicker) {
        startLessonLabel.text = displayedDate(str: "\(endLessonDatePicker.date)")
    }
    
    @IBAction func endDateChanged(sender: UIDatePicker) {
        endLessonLabel.text = displayedDate(str: "\(startLessonDatePicker.date)")
    }
    
}

//MARK: Set Screen
extension AddMeetingTVC {
    private func configureScreen(){
        if editLesson != nil {
            nameTF.text = editLesson?.lessonName
            placeTF.text = editLesson?.place ?? ""
            studentLabel.text = "\(editLesson?.studentName ?? "") \(editLesson?.studentSurname ?? "")"
            disciplineLabel.text = editLesson?.discipline ?? ""
            startLessonLabel.text = editLesson?.dateStart ?? ""
            endLessonLabel.text = editLesson?.dateEnd ?? ""
            repeatLessonLabel.text = editLesson?.repeatLesson ?? ""
            endOfRepeatLessonLabel.text = editLesson?.endRepeatLesson ?? ""
            priceTF.text = "\(editLesson?.price ?? 0)"
            notificationTypeLabel.text = "\(editLesson?.notificationType ?? 0)"
            noteTV.text = editLesson?.note ?? ""
        }
        
        startLessonDatePicker.date = NSDate() as Date
        startLessonLabel.text = "\(startLessonDatePicker.date)"
        startLessonDatePicker.isHidden = true
        
        endLessonDatePicker.date = NSDate() as Date
        endLessonLabel.text = "\(endLessonDatePicker.date)"
        endLessonDatePicker.isHidden = true
               
        self.hideKeyboardWhenTappedAround()
            
        

        
        setupNavigationBar()
        tableView.backgroundColor = .bgStudent
    }
    
    private func setupNavigationBar() {
        let nav = self.navigationController?.navigationBar
        
        if editLesson == nil {
            nav?.topItem?.title = "Новый урок"
        }
        
        navigationItem.leftBarButtonItem?.title = "Отмена"
        navigationItem.leftBarButtonItem?.tintColor = .white
        navigationItem.rightBarButtonItem?.tintColor = .white
        
        nav?.setBackgroundImage(UIImage(), for: .default)
        nav?.shadowImage = UIImage()
        nav?.isTranslucent = true
        nav?.prefersLargeTitles = true
        nav?.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        nav?.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    
    private func displayedDate(str: String) -> String {
       return Date().convertStrDate(date: str, formatFrom: "yyyy-MM-dd HH:mm:ssZ", formatTo: "dd.MM.yyyy HH:mm")
        
    }
}



//MARK: Navigation
extension AddMeetingTVC {
    @IBAction func unwiSegueAddMeeting (_ segue: UIStoryboardSegue) {
        
        guard let repeatTVC = segue.source as? RepeatTVC else { return }
        self.repeatLessonLabel.text = repeatTVC.repeatLesson.rawValue
        self.endOfRepeatLessonLabel.text = "\(repeatTVC.endOfRepeat)"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "repeatLesson" {
        
        guard let repeatTVC = segue.destination as? RepeatTVC else { return }
        repeatTVC.repeatLesson = RepeatLesson(rawValue: editLesson?.repeatLesson ?? "") ?? RepeatLesson.never
    }
}
}

//MARK: TableViewDelegate, TableViewDataSource
extension AddMeetingTVC {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let startDatePicker = IndexPath(row: 1, section: 2)
        let endDatePicker = IndexPath(row: 3, section: 2)
        
        switch indexPath{
        case startDatePicker:
            return CGFloat(startLessonDatePicker.isHidden ? 0.0 : 216.0)
        case endDatePicker:
            return CGFloat(endLessonDatePicker.isHidden ? 0.0 : 216.0)
        default:
            return super.tableView(tableView, heightForRowAt: indexPath)
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let startDateIndexPath = IndexPath(row: 0, section: 2)
        let endDateIndexPath = IndexPath(row: 2, section: 2)
      
        switch indexPath {
        case startDateIndexPath:
            startLessonDatePicker.isHidden = !startLessonDatePicker.isHidden
            pickerAnimation(indexPath: indexPath)
        case endDateIndexPath:
            endLessonDatePicker.isHidden = !endLessonDatePicker.isHidden
            pickerAnimation(indexPath: indexPath)
        
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
