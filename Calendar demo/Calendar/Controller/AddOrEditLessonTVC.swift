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
    
    public var onBackButtonTap: (() -> (Void))?
    public var onSaveButtonTap: ((Int, LessonModel) -> (Void))?
    public var lesson: LessonModel?
    public var student: StudentModel?
    public var notifInSeconds: Double?
    
    private let networkManagerCalendar =  NetworkManagerCalendar()
    private var notifications = Notifications()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureScreen()
        
    }
    @IBAction func notifCheck(_ sender: Any) {
        setNotification(meetingId: 1,
                        date: startLessonDatePicker.date,
                        notifInSeconds: notifInSeconds ?? 0,
                        notifDescription: notificationTypeLabel.text ?? "нет",
                        meetingName: nameTF.text ?? "Занятие",
                        student: "\(student?.name) \(student?.surname)")
    }
    
    @IBAction func startDateChanged(sender: UIDatePicker) {
        let oneHour = TimeInterval(60 * 60)
        
        startLessonLabel.text = displayedDateAndTime(str: "\(startLessonDatePicker.date)")
        endLessonDatePicker.setDate(startLessonDatePicker.date.addingTimeInterval(oneHour), animated: true)
        endLessonLabel.text = displayedDateAndTime(str: "\(endLessonDatePicker.date)")
    }
    
    @IBAction func endDateChanged(sender: UIDatePicker) {
        endLessonLabel.text = displayedDateAndTime(str: "\(endLessonDatePicker.date)")
    }
    @IBAction func cancelButton(_ sender: Any) {
         onBackButtonTap?()
    }
    @IBAction func saveButtonClick(_ sender: Any) {
        guard nameTF.text != "", nameTF.text != " "  else {
                DispatchQueue.main.async {
                    self.simpleAlert(message: "Пожалуйста, заполните необходимые поля")
                }
                return
            }
            saveLesson()
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
            repeatLessonLabel.text = lesson?.repeatedly ?? ""
            endOfRepeatLessonLabel.text = lesson?.endRepeat ?? ""
            priceTF.text = "\(lesson?.price ?? 0)"
            noteTV.text = lesson?.note ?? ""
        }
        
        self.hideKeyboardWhenTappedAround()
        
        setupStartLesson()
        setupEndLesson()
        setupNavigationBar()
        UIColor.setGradientToTableView(tableView: tableView, height: 0.4)
        
        priceTF.attributedPlaceholder = NSAttributedString(string: "0",
        attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
        endOfRepeatLessonCell.isHidden  = true
    }
    
    private func setupStartLesson() {
        startLessonLabel.text = displayedDateAndTime(str: "\(startLessonDatePicker.date)")
        startLessonDatePicker.datePickerMode = .dateAndTime
        startLessonDatePicker.isHidden = true
    }
    
    private func setupEndLesson() {
        let oneHour = TimeInterval(60 * 60)
        
        endLessonDatePicker.setDate(Date().addingTimeInterval(oneHour), animated: true)
        endLessonLabel.text = displayedDateAndTime(str: "\(endLessonDatePicker.date)")
        endLessonDatePicker.isHidden = true
    }
    
    private func setupNavigationBar() {
        let navBar = self.navigationController?.navigationBar
        
        navigationItem.title = lesson == nil ? "Новый урок" : "Правка"
            
        navigationItem.leftBarButtonItem?.title = "Отмена"
        navigationItem.leftBarButtonItem?.tintColor = .white
        navigationItem.rightBarButtonItem?.tintColor = .white
        
        navBar?.setBackgroundImage(UIImage(), for: .default)
        navBar?.shadowImage = UIImage()
        navBar?.isTranslucent = true
        navBar?.prefersLargeTitles = true
        navBar?.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navBar?.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        
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
                self.endOfRepeatLessonLabel.text = "\(repeatTVC.endOfRepeat ?? "")"
                endOfRepeatLessonCell.isHidden = false
            } else {
                endOfRepeatLessonCell.isHidden = true
            }
            tableView.reloadData()
        }
        
        if let notifTVC = segue.source as? NotificationTVC {
            self.notificationTypeLabel.text = "\(notifTVC.selectedNotification)"
            self.notifInSeconds = notifTVC.notifInSeconds
            print(self.notifInSeconds)
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
            repeatTVC.repeatLesson = repeatLessonLabel.text == RepeatLesson.never.rawValue ? .never : .weekly
            repeatTVC.endOfRepeat = endOfRepeatLessonLabel.text ?? ""
            
        case "notification":
            guard let notifTVC = segue.destination as? NotificationTVC else { return }
            notifTVC.selectedNotification =  notificationTypeLabel.text ?? "Нет"
            notifTVC.notifInSeconds = notifInSeconds ?? 0
        default:
            return
        }
    }
    
    func saveLesson() {
        lesson = LessonModel(lessonId: lesson != nil ? lesson?.lessonId : nil,
                               lessonName: nameTF.text,
                               place: placeTF.text,
                               studentId: lesson != nil ? lesson?.studentId : student?.studentId,
                               studentName: student?.name,
                               studentSurname: student?.surname,
                               discipline: disciplineLabel.text ?? "",
                               dateStart: serverDate(str: "\(startLessonDatePicker.date)"),
                               timeStart: serverHour(str: "\(startLessonDatePicker.date)"),
                               duration: [""],
                               dateEnd: serverDate(str: "\(endLessonDatePicker.date)"),
                               timeEnd: serverHour(str: "\(endLessonDatePicker.date)"),
                               repeatedly: repeatLessonLabel.text == "Никогда" ?  "never" : "weekly",
                               endRepeat:  repeatLessonLabel.text == "Никогда" ? "" : serverDate2(str: "\(endOfRepeatLessonLabel.text ?? "01.01.2000")"),
                               price: Int(priceTF.text ?? "0"),
                               note: noteTV.text,
                               statusPay: 0,
                               paymentDate: "")
        if lesson?.lessonId != nil {
            changeLesson(lesson: lesson!)
        } else {
            addNewLesson(lesson: lesson!)
        }
        print(lesson)
        

    }
}

//MARK: Network
extension AddOrEditLessonTVC {
    private func addNewLesson(lesson: LessonModel) {
        networkManagerCalendar.addLesson(name: lesson.lessonName ?? "",
                                         place: lesson.place ?? "",
                                         studentId: lesson.studentId ?? 0,
                                         discipline: lesson.discipline ?? "",
                                         dateStart: lesson.dateStart ?? "",
                                         timeStart: lesson.timeStart ?? "",
                                         dateEnd: lesson.dateEnd ?? "",
                                         timeEnd: lesson.timeEnd ?? "",
                                         repeatedly: lesson.repeatedly ?? "",
                                         endRepeat: lesson.endRepeat ?? "",
                                         price: lesson.price ?? 0,
                                         note: lesson.note ?? "")
        { [weak self]  (responce, error)  in
            guard let responce = responce else {
                print(error ?? "")
                DispatchQueue.main.async {
                    self?.simpleAlert(message: error ?? "")
                }
                return
            }
            guard let lessonId = responce.lessonId else { return }
            self?.onSaveButtonTap?(lessonId, lesson)
            print("Add:",responce.message ?? "")
        }
    }
    
    private func changeLesson(lesson: LessonModel) {
        networkManagerCalendar.changeLesson(lessonId: lesson.lessonId ?? 0,
                                            name: lesson.lessonName ?? "",
                                            place: lesson.place ?? "",
                                            studentId: lesson.studentId ?? 0,
                                            discipline: lesson.discipline ?? "",
                                            dateStart: lesson.dateStart ?? "",
                                            timeStart: lesson.timeStart ?? "",
                                            dateEnd: lesson.dateEnd ?? "",
                                            timeEnd: lesson.timeEnd ?? "",
                                            repeatedly: lesson.repeatedly ?? "",
                                            endRepeat: lesson.endRepeat ?? "",
                                            price: lesson.price ?? 0,
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
            self?.onSaveButtonTap?(lesson.lessonId ?? 0, lesson)
            print("change:",responce.message ?? "")
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
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath){
        let priceCell = IndexPath(row:0, section: 3)
        
        if indexPath == priceCell {
            cell.contentView.backgroundColor = .bgStudent
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
    
    private func serverDate(str: String) -> String {
        return Date().convertStrDate(date: str, formatFrom: "yyyy-MM-dd HH:mm:ssZ", formatTo: "yyyy-MM-dd")
    }
    
    private func serverDate2(str: String) -> String {
        return Date().convertStrDate(date: str, formatFrom: "dd.MM.yyyy", formatTo: "yyyy-MM-dd")
    }
    
    private func serverHour(str: String) -> String {
        return Date().convertStrDate(date: str, formatFrom: "yyyy-MM-dd HH:mm:ssZ", formatTo: "HH:mm:ss")
    }
    
}

//MARK: Alert
extension AddOrEditLessonTVC  {
    func simpleAlert(message: String) {
        UIAlertController.simpleAlert(title:"Error", msg:"\(message)", target: self)
    }
}

//MARK: Set Notification
extension AddOrEditLessonTVC {
    func setNotification(meetingId: Int, date: Date, notifInSeconds: Double, notifDescription: String, meetingName: String, student: String) {
        
        let notifDate = date.addingTimeInterval(-notifInSeconds)
        let message = student == "" ? "Через \(notifDescription) запланировано \(meetingName) с \(student)" : "Через \(notifDescription) запланировано \(meetingName)"
        
        self.notifications.scheduleNotification(meetingId: meetingId, date: notifDate, title: meetingName, message: message)
    }
}
