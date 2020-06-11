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
        let oneHour = TimeInterval(60 * 60)
        
        startLessonLabel.text = displayedDateAndTime(str: "\(startLessonDatePicker.date)")
        endLessonDatePicker.setDate(startLessonDatePicker.date.addingTimeInterval(oneHour), animated: true)
        endLessonLabel.text = displayedHour(str: "\(endLessonDatePicker.date)")
    }
    
    @IBAction func endDateChanged(sender: UIDatePicker) {
        endLessonLabel.text = displayedHour(str: "\(endLessonDatePicker.date)")
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
        
        self.hideKeyboardWhenTappedAround()
        
        setupStartLesson()
        setupEndLesson()
        setupNavigationBar()
        tableView.backgroundColor = .bgStudent
    }
    
    private func setupStartLesson() {
        startLessonLabel.text = displayedDateAndTime(str: "\(startLessonDatePicker.date)")
        startLessonDatePicker.datePickerMode = .dateAndTime
        startLessonDatePicker.isHidden = true
    }
    
    private func setupEndLesson() {
        let oneHour = TimeInterval(60 * 60)
        
        endLessonDatePicker.datePickerMode = .time
        endLessonDatePicker.setDate(Date().addingTimeInterval(oneHour), animated: true)
        endLessonLabel.text = displayedHour(str: "\(endLessonDatePicker.date)")
        endLessonDatePicker.isHidden = true
    }
    
    private func setupNavigationBar() {
        let nav = self.navigationController?.navigationBar
        
        navigationItem.leftBarButtonItem?.title = "Отмена"
        navigationItem.leftBarButtonItem?.tintColor = .white
        navigationItem.rightBarButtonItem?.tintColor = .white
        
        nav?.setBackgroundImage(UIImage(), for: .default)
        nav?.shadowImage = UIImage()
        nav?.isTranslucent = true
        nav?.prefersLargeTitles = true
        nav?.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        nav?.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        guard editLesson == nil else { return }
        nav?.topItem?.title = "Новый урок"
    }
}

//MARK: Navigation
extension AddMeetingTVC {
    @IBAction func unwiSegueAddMeeting (_ segue: UIStoryboardSegue) {
        
        if let studentTVC = segue.source as? StudentsForLessonTVC {
        self.studentLabel.text = "\(studentTVC.selectedStudents)"
        }
        
        if let disciplineTVC = segue.source as? DisciplinesForLessonTVC {
            self.disciplineLabel.text = "\(disciplineTVC.selectedDiscipline)"
        }
        
        if let repeatTVC = segue.source as? RepeatTVC {
            self.repeatLessonLabel.text = repeatTVC.repeatLesson.rawValue
            guard let date = repeatTVC.endOfRepeat else { return }
            self.endOfRepeatLessonLabel.text = displayedDate(str: "\(date)")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier {
        case "disciplines":
                guard let disTVC = segue.destination as? DisciplinesForLessonTVC else { return }
            disTVC.selectedDiscipline = editLesson?.discipline ?? ""
        case "repeatLesson":
            guard let repeatTVC = segue.destination as? RepeatTVC else { return }
            repeatTVC.repeatLesson = RepeatLesson(rawValue: editLesson?.repeatLesson ?? "") ?? RepeatLesson.never
            
        default:
            return
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
}

//MARK: PickerView
extension AddMeetingTVC {
    private func pickerAnimation(indexPath: IndexPath) {
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.tableView.beginUpdates()
            self.tableView.deselectRow(at: indexPath as IndexPath, animated: true)
            self.tableView.endUpdates()
        })
    }
}

//MARK: Date Support Func
extension AddMeetingTVC {
    private func displayedDateAndTime(str: String) -> String {
        return Date().convertStrDate(date: str, formatFrom: "yyyy-MM-dd HH:mm:ssZ", formatTo: "dd.MM.yyyy HH:mm")
    }
    
    private func displayedDate(str: String) -> String {
        return Date().convertStrDate(date: str, formatFrom: "yyyy-MM-dd HH:mm:ssZ", formatTo: "dd.MM.yyy")
    }
    
    private func displayedHour(str: String) -> String {
        return Date().convertStrDate(date: str, formatFrom: "yyyy-MM-dd HH:mm:ssZ", formatTo: "HH:mm")
    }
    
}
