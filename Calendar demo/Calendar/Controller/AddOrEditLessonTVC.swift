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
    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var startDatePicker: UIDatePicker!
    @IBOutlet weak var endLabel: UILabel!
    @IBOutlet weak var endDatePicker: UIDatePicker!
    @IBOutlet weak var repeatLabel: UILabel!
    @IBOutlet weak var endRepeatCell: UITableViewCell!
    @IBOutlet weak var endRepeatLabel: UILabel!
    @IBOutlet weak var priceCell: UITableViewCell!
    @IBOutlet weak var priceTF: UITextField!
    @IBOutlet weak var notificationLabel: UILabel!
    @IBOutlet weak var noteTV: UITextView!
    
    public var onBackButtonTap: (() -> (Void))?
    public var onSaveButtonTap: ((Int, LessonModel) -> (Void))?
    public var lesson: LessonModel?
    public var student: StudentModel?
    public var notifInSeconds: Double?
    public var selectedDate: Date?
    
    
    private let networkManagerCalendar =  NetworkManagerCalendar()
    private var notifications = Notifications()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureScreen()
    }
    
    
    
    @IBAction func startDateChanged(sender: UIDatePicker) {
        let dur = StandartDuration.userDur
        
        endDatePicker.minimumDate = startDatePicker.date
        endDatePicker.setDate(startDatePicker.date.addingTimeInterval(dur), animated: true)
        
        setStartDateLabel()
        setEndDateLabel()
    }

    @IBAction func endDateChanged(sender: UIDatePicker) {
        setEndDateLabel()
    }

    @IBAction func cancelButton(_ sender: Any) {
        onBackButtonTap?()
    }
    
    @IBAction func saveButtonClick(_ sender: Any) {
            saveLesson()
            setNotification(meetingId           : 1,
                            date                : startDatePicker.date,
                            notifInSeconds      : notifInSeconds ?? 0,
                            notifDescription    : notificationLabel.text ?? "нет",
                            meetingName         : nameTF.text ?? "Занятие",
                            student             : "\(student?.name ?? "") \(student?.surname ?? "")")
    }
}

//MARK: Set Screen
extension AddOrEditLessonTVC {
    
    private func configureScreen(){
        
        print(String(describing:lesson))
        
        
        if lesson != nil {
            let endRepeat           = Date().str(str: lesson?.endRepeat, to: .date)
            
            nameTF.text             = lesson?.lessonName
            placeTF.text            = lesson?.place ?? ""
            studentLabel.text       = "\(lesson?.studentName ?? "") \(lesson?.studentSurname ?? "")"
            disciplineLabel.text    = lesson?.discipline ?? ""
            repeatLabel.text        = lesson?.repeatedly ?? ""
            endRepeatLabel.text     = endRepeat
            priceTF.text            = "\(lesson?.price ?? 0)"
            noteTV.text             = lesson?.note ?? ""
        }
    
        endRepeatCell.isHidden  = true
        hideKeyboardWhenTappedAround()
        setupStartLessonPicker()
        setupEndLessonPicker()
        setupNavigationBar()
        
        priceTF.attributedPlaceholder = NSAttributedString(string: "0", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
    }
    
    private func setupStartLessonPicker() {
        let date = lesson != nil ? Date().strToDate(str: lesson?.startDate) : selectedDate
        let picker = date ?? Date()
        
        startDatePicker.setDate(picker, animated: true)
        startDatePicker.minuteInterval = 5
        startDatePicker.isHidden = true
        
        setStartDateLabel()
    }
    
    private func setupEndLessonPicker() {
        let dur = StandartDuration.userDur
        let date = lesson != nil ? Date().strToDate(str: lesson?.startDate) : selectedDate
        let picker = date?.addingTimeInterval(dur) ?? Date()
        
        endDatePicker.setDate(picker, animated: true)
        endDatePicker.minuteInterval = 5
        endDatePicker.isHidden = true
        
        setEndDateLabel()
    }
    
    private func setStartDateLabel() {
        startLabel.text = Date().str(str: "\(startDatePicker.date)", to: .dateTime)
       }
    
    private func setEndDateLabel() {
        endLabel.text = Date().str(str: "\(endDatePicker.date)", to: .dateTime)
    }
    
    
    
    private func setupNavigationBar() {
        let navBar                  = self.navigationController?.navigationBar
        let statusBarHeight         = UIApplication.shared.statusBarFrame.height
        let gradientHeight          = statusBarHeight  + navBar!.frame.height
        
        navigationItem.title = lesson == nil ? "Новый урок" : "Редактирование"
        navigationItem.leftBarButtonItem?.title = "Отмена"
        navigationItem.leftBarButtonItem?.tintColor = .white
        navigationItem.rightBarButtonItem?.tintColor = .white
        
        UINavigationBar().setClearNavBar(controller: self)
        
        UIColor.setGradientToTableView(tableView: tableView, height: Double(gradientHeight))
    }
}

//MARK: Navigation
extension AddOrEditLessonTVC {
    @IBAction func unwiSegueAddMeeting (_ segue: UIStoryboardSegue) {
        
        if let studentTVC = segue.source as? StudentsForLessonTVC {
            self.student = studentTVC.selectedStudent
            self.studentLabel.text = "\(self.student?.name ?? "") \(self.student?.surname ?? "")"
            
//            print(student)
            
        }
        
        if let disciplineTVC = segue.source as? DisciplinesForLessonTVC {
            self.disciplineLabel.text = disciplineTVC.selectedDiscipline
        }
        
        if let repeatTVC = segue.source as? RepeatTVC {
            self.repeatLabel.text = repeatTVC.repeatLesson.rawValue
            if repeatTVC.repeatLesson.rawValue != RepeatLesson.never.rawValue {
                self.endRepeatLabel.text = "\(repeatTVC.endOfRepeat ?? "")"
                endRepeatCell.isHidden = false
            } else {
                endRepeatCell.isHidden = true
            }
            tableView.reloadData()
        }
        
        if let notifTVC = segue.source as? NotificationTVC {
            self.notificationLabel.text = "\(notifTVC.selectedNotification)"
            self.notifInSeconds = notifTVC.notifInSeconds
        }
        
        let nav = self.navigationController?.navigationBar
        nav?.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier {
        case "student":
            guard let nav = segue.destination as? UINavigationController,
                    let studTVC = nav.topViewController as? StudentsForLessonTVC else { return }
            studTVC.selectedStudent = student
        case "disciplines":
            guard let nav = segue.destination as? UINavigationController,
                    let disTVC = nav.topViewController as? DisciplinesForLessonTVC else { return }
            disTVC.selectedDiscipline =  disciplineLabel.text ?? ""
        case "repeatLesson":
            guard let nav = segue.destination as? UINavigationController,
                    let repeatTVC = nav.topViewController as? RepeatTVC else { return }
            repeatTVC.repeatLesson = repeatLabel.text == RepeatLesson.never.rawValue ? .never : .weekly
            repeatTVC.endOfRepeat = endRepeatLabel.text ?? ""
            
        case "notification":
            guard let nav = segue.destination as? UINavigationController,
                    let notifTVC = nav.topViewController as? NotificationTVC else { return }
            notifTVC.selectedNotification =  notificationLabel.text ?? "Нет"
            notifTVC.notifInSeconds = notifInSeconds ?? 0
            
        default:
            return
        }
    }
    
    func saveLesson() {
        let endRepeat = "\(Date().strToDate(str: endRepeatLabel.text))"
        let start = "\(startDatePicker.date)".prefix(19)
        let end = "\(endDatePicker.date)".prefix(19)
        
        lesson = LessonModel(lessonId       : lesson != nil ? lesson?.lessonId : nil,
                             lessonName     : nameTF.text,
                             place          : placeTF.text,
                             studentId      : student?.studentId == nil ? lesson?.studentId : student?.studentId,
                             studentName    : student?.name,
                             studentSurname : student?.surname,
                             discipline     : disciplineLabel.text ?? "",
                             startDate      : "\(start)",
                             duration       : [],
                             endDate        : "\(end)",
                             repeatedly     : repeatLabel.text == "Никогда" ?  "never" : "weekly",
                             endRepeat      :  repeatLabel.text == "Никогда" ? "" : endRepeat,
                             price          : Int(priceTF.text ?? "0"),
                             note           : noteTV.text,
                             payStatus      : 0,
                             paymentDate    : "")
        
        if lesson?.lessonId != nil {
            changeLesson(lesson: lesson!)
        } else {
            addNewLesson(lesson: lesson!)
        }
    }
}

//MARK: Network
extension AddOrEditLessonTVC {
    private func addNewLesson(lesson: LessonModel) {
        networkManagerCalendar.addLesson(name           : lesson.lessonName ?? "",
                                         place          : lesson.place ?? "",
                                         studentId      : lesson.studentId ?? 0,
                                         discipline     : lesson.discipline ?? "",
                                         startDate      : lesson.startDate ?? "",
                                         endDate        : lesson.endDate ?? "",
                                         repeatedly     : lesson.repeatedly ?? "",
                                         endRepeat      : lesson.endRepeat ?? "",
                                         price          : lesson.price ?? 0,
                                         note           : lesson.note ?? "")
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
        networkManagerCalendar.changeLesson(lessonId    : lesson.lessonId ?? 0,
                                            name        : lesson.lessonName ?? "",
                                            place       : lesson.place ?? "",
                                            studentId   : lesson.studentId ?? 0,
                                            discipline  : lesson.discipline ?? "",
                                            startDate   : lesson.startDate ?? "",
                                            endDate     : lesson.endDate ?? "",
                                            repeatedly  : lesson.repeatedly ?? "",
                                            endRepeat   : lesson.endRepeat ?? "",
                                            price       : lesson.price ?? 0,
                                            note        : lesson.note ?? "",
                                            payStatus   : lesson.payStatus ?? 0,
                                            paymentDate : lesson.paymentDate ?? "")
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
        let startPicker         = IndexPath(row: 1, section: 2)
        let endPicker           = IndexPath(row: 3, section: 2)
        let endRepeat           = IndexPath(row: 5, section: 2)
        
        switch indexPath{
        case startPicker:
            return CGFloat(startDatePicker.isHidden ? 0.0 : 216.0)
        case endPicker:
            return CGFloat(endDatePicker.isHidden ? 0.0 : 216.0)
        case endRepeat:
            return CGFloat(endRepeatCell.isHidden ? 0.0 : 43.5)
        default:
            return super.tableView(tableView, heightForRowAt: indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let startDateIndexPath  = IndexPath(row: 0, section: 2)
        let endDateIndexPath    = IndexPath(row: 2, section: 2)
        
        switch indexPath {
        case startDateIndexPath:
            startDatePicker.isHidden = !startDatePicker.isHidden
            pickerAnimation(indexPath: indexPath)
        case endDateIndexPath:
            endDatePicker.isHidden = !endDatePicker.isHidden
            pickerAnimation(indexPath: indexPath)
        default:
            return
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath){
        let priceCell = IndexPath(row:0, section: 3)
        
        if indexPath == priceCell {
            cell.contentView.backgroundColor = .appBlueDark
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 25))
        headerView.backgroundColor = .clear
        
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 25))
        footerView.backgroundColor = .clear
        return footerView
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
