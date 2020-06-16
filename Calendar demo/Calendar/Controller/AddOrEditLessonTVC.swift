//
//  ChangeMeetingVC.swift
//  Calendar demo
//
//  Created by Максим Окунеев on 4/21/20.
//  Copyright © 2020 Максим Окунеев. All rights reserved.
//

import UIKit

class AddOrEditLessonTVC: UITableViewController {
    
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var placeTF: UITextField!
    @IBOutlet weak var studentLabel: UILabel!
    @IBOutlet weak var disciplineLabel: UILabel!
    @IBOutlet weak var startLessonLabel: UILabel!
    @IBOutlet weak var startLessonDatePicker: UIDatePicker!
    @IBOutlet weak var endLessonLabel: UILabel!
    @IBOutlet weak var endLessonDatePicker: UIDatePicker!
    @IBOutlet weak var repeatLessonLabel: UILabel!
    @IBOutlet weak var endOfRepeatLessonCell: UITableViewCell!
    @IBOutlet weak var endOfRepeatLessonLabel: UILabel!
    @IBOutlet weak var priceCell: UITableViewCell!
    @IBOutlet weak var priceTF: UITextField!
    @IBOutlet weak var notificationTypeLabel: UILabel!
    @IBOutlet weak var noteTV: UITextView!
    
    var lesson: CalendarModel?
    var student: StudentModel?
    private let networkManagerCalendar =  NetworkManagerCalendar()
    
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
extension AddOrEditLessonTVC {
    private func configureScreen(){
        if lesson != nil {
            nameTF.text = lesson?.lessonName
            placeTF.text = lesson?.place ?? ""
            studentLabel.text = "\(lesson?.studentName ?? "") \(lesson?.studentSurname ?? "")"
            disciplineLabel.text = lesson?.discipline ?? ""
            startLessonLabel.text = lesson?.dateStart ?? ""
            endLessonLabel.text = lesson?.dateEnd ?? ""
            repeatLessonLabel.text = lesson?.repeatLesson ?? ""
            endOfRepeatLessonLabel.text = lesson?.endRepeatLesson ?? ""
            priceTF.text = "\(lesson?.price ?? 0)"
//            notificationTypeLabel.text = "\(lesson?.notificationType ?? "")"
            noteTV.text = lesson?.note ?? ""
        }
        
        self.hideKeyboardWhenTappedAround()
        
        setupStartLesson()
        setupEndLesson()
        setupNavigationBar()
        priceCell.backgroundColor = .bgStudent
        endOfRepeatLessonCell.isHidden  = true
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
        let navBar = self.navigationController?.navigationBar
        
        navigationItem.leftBarButtonItem?.title = "Отмена"
        navigationItem.leftBarButtonItem?.tintColor = .white
        navigationItem.rightBarButtonItem?.tintColor = .white
        
        navBar?.setBackgroundImage(UIImage(), for: .default)
        navBar?.shadowImage = UIImage()
        navBar?.isTranslucent = true
        navBar?.prefersLargeTitles = true
        navBar?.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navBar?.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        guard lesson == nil else { return }
        navBar?.topItem?.title = "Новый урок"
    }
}

//MARK: Navigation
extension AddOrEditLessonTVC {
    @IBAction func unwiSegueAddMeeting (_ segue: UIStoryboardSegue) {
        
        if let studentTVC = segue.source as? StudentsForLessonTVC {
            self.student = studentTVC.selectedStudent
            self.studentLabel.text = "\(self.student?.name ?? "") \(self.student?.surname ?? "")"
            
            let nav = self.navigationController?.navigationBar
            nav?.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        }
        
        if let disciplineTVC = segue.source as? DisciplinesForLessonTVC {
            self.disciplineLabel.text = disciplineTVC.selectedDiscipline
        }
        
        if let repeatTVC = segue.source as? RepeatTVC {
            self.repeatLessonLabel.text = repeatTVC.repeatLesson.rawValue
            if repeatTVC.repeatLesson.rawValue != RepeatLesson.never.rawValue {
                self.endOfRepeatLessonLabel.text = repeatTVC.endOfRepeat ?? ""
                endOfRepeatLessonCell.isHidden = false
            } else {
                endOfRepeatLessonCell.isHidden = true
            }
            tableView.reloadData()
        }
        
        if let notifTVC = segue.source as? NotificationTVC {
            self.notificationTypeLabel.text = "\(notifTVC.selectedNotification )"
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier {
        case "student":
            guard let studTVC = segue.destination as? StudentsForLessonTVC else { return }
            studTVC.selectedStudent = student
        case "disciplines":
            guard let disTVC = segue.destination as? DisciplinesForLessonTVC else { return }
            disTVC.selectedDiscipline =  disciplineLabel.text ?? ""
        case "repeatLesson":
            guard let repeatTVC = segue.destination as? RepeatTVC else { return }
            repeatTVC.endOfRepeat = endOfRepeatLessonLabel.text ?? ""
        case "notification":
            guard let notifTVC = segue.destination as? NotificationTVC else { return }
            notifTVC.selectedNotification =  notificationTypeLabel.text ?? RepeatLesson.never.rawValue
        default:
            return
        }
    }
    
    func saveLesson() {
        lesson = CalendarModel(lessonId: lesson != nil ? lesson?.lessonId : nil,
                               lessonName: nameTF.text,
                               place: placeTF.text,
                               studentId: lesson != nil ? lesson?.studentId : nil,
                               studentName: student?.name,
                               studentSurname: student?.surname,
                               discipline: disciplineLabel.text,
                               dateStart: displayedDate(str: "\(startLessonDatePicker.date)"),
                               timeStart: displayedHour(str: "\(startLessonDatePicker.date)"),
                               duration: [""],
                               dateEnd: displayedDate(str: "\(startLessonDatePicker.date)"),
                               timeEnd: displayedHour(str: "\(startLessonDatePicker.date)"),
                               repeatLesson: repeatLessonLabel.text,
                               endRepeatLesson: endOfRepeatLessonLabel.text,
                               price:  Int(priceTF.text ?? "0"),
//                               notificationType: notificationTypeLabel.text,
                               note: noteTV.text,
                               statusPay: 0,
                               paymentDate: "")
        if student?.studentId != nil {
            changeLesson(lesson: lesson!)
        } else {
            addNewLesson(lesson: lesson!)
        }
    }
}

//MARK: Network
extension AddOrEditLessonTVC {
    private func addNewLesson(lesson: CalendarModel) {
        networkManagerCalendar.addLesson(lessonName: lesson.lessonName ?? "",
                                         place: lesson.place ?? "",
                                         studentId: lesson.studentId ?? 0,
                                         discipline: lesson.discipline ?? "",
                                         dateStart: lesson.dateStart ?? "",
                                         timeStart: lesson.timeStart ?? "",
                                         dateEnd: lesson.dateEnd ?? "",
                                         timeEnd: lesson.timeEnd ?? "",
                                         repeatLesson: lesson.repeatLesson ?? "",
                                         endRepeatLesson: lesson.endRepeatLesson ?? "",
                                         price: lesson.price ?? 0,
//                                         notificationType: lesson.notificationType ?? "",
                                         note: lesson.note ?? "")
        { [weak self]  (responce, error)  in
            guard let responce = responce else {
                print(error ?? "")
                DispatchQueue.main.async {
                    self?.simpleAlert(message: error ?? "")
                }
                return
            }
            print("Add:",responce)
        }
    }
    
    private func changeLesson(lesson: CalendarModel) {
        networkManagerCalendar.changeLesson(lessonId: lesson.lessonId ?? 0,
                                            lessonName: lesson.lessonName ?? "",
                                            place: lesson.place ?? "",
                                            studentId: lesson.studentId ?? 0,
                                            discipline: lesson.discipline ?? "",
                                            dateStart: lesson.dateStart ?? "",
                                            timeStart: lesson.timeStart ?? "",
                                            dateEnd: lesson.dateEnd ?? "",
                                            timeEnd: lesson.timeEnd ?? "",
                                            repeatLesson: lesson.repeatLesson ?? "",
                                            endRepeatLesson: lesson.endRepeatLesson ?? "",
                                            price: lesson.price ?? 0,
//                                            notificationType: lesson.notificationType ?? "",
                                            note: lesson.note ?? "",
                                            statusPay: lesson.statusPay ?? 0,
                                            paymentDate: lesson.paymentDate ?? "")
        { [weak self]  (responce, error)  in
            guard let responce = responce else {
                print(error ?? "")
                DispatchQueue.main.async {
                    self?.simpleAlert(message: error ?? "")
                }
                return
            }
            print("change:",responce)
        }
    }
}



//MARK: TableViewDelegate, TableViewDataSource
extension AddOrEditLessonTVC {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let startDatePicker = IndexPath(row: 1, section: 2)
        let endDatePicker = IndexPath(row: 3, section: 2)
        let endOfRepeat = IndexPath(row: 5, section: 2)
        
        switch indexPath{
        case startDatePicker:
            return CGFloat(startLessonDatePicker.isHidden ? 0.0 : 216.0)
        case endDatePicker:
            return CGFloat(endLessonDatePicker.isHidden ? 0.0 : 216.0)
        case endOfRepeat:
            return CGFloat(endOfRepeatLessonCell.isHidden ? 0.0 : 43.5)
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
extension AddOrEditLessonTVC {
    private func pickerAnimation(indexPath: IndexPath) {
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.tableView.beginUpdates()
            self.tableView.deselectRow(at: indexPath as IndexPath, animated: true)
            self.tableView.endUpdates()
        })
    }
}

//MARK: Date Support Func
extension AddOrEditLessonTVC {
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

//MARK: Alert
extension AddOrEditLessonTVC  {
    func simpleAlert(message: String) {
        UIAlertController.simpleAlert(title:"Error", msg:"\(message)", target: self)
    }
}
