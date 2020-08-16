//
//  ChangeMeetingVC.swift
//  Calendar demo
//
//  Created by Максим Окунеев on 4/21/20.
//  Copyright © 2020 Максим Окунеев. All rights reserved.
//

import UIKit

class AddOrEditLessonTVC: UITableViewController {
    
    @IBOutlet weak var segmetControl: UISegmentedControl!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var placeTF: UITextField!
    @IBOutlet weak var studentLabel: UILabel!
    @IBOutlet weak var disciplineLabel: UILabel!
    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var startDatePicker: UIDatePicker!
    @IBOutlet weak var endLabel: UILabel!
    @IBOutlet weak var endDatePicker: UIDatePicker!
    @IBOutlet weak var repeatLabel: UILabel!
    @IBOutlet weak var endRepeatTitle: UILabel!
    @IBOutlet weak var endRepeatLabel: UILabel!
    @IBOutlet weak var priceTitle: UILabel!
    @IBOutlet weak var priceTF: UITextField!
    @IBOutlet weak var priceCurrency: UILabel!
    @IBOutlet weak var notificationLabel: UILabel!
    @IBOutlet weak var noteTV: UITextView!
    
    @IBOutlet weak var nameBackView: UIView!
    @IBOutlet weak var studentBackView: UIView!
    @IBOutlet weak var placeBackView: UIView!
    @IBOutlet weak var disciplineBackView: UIView!
    @IBOutlet weak var startBackView: UIView!
    @IBOutlet weak var endBackView: UIView!
    @IBOutlet weak var repeatBackView: UIView!
    @IBOutlet weak var endRepeatBackView: UIView!
    @IBOutlet weak var priceBackView: UIView!
    @IBOutlet weak var notificationBackView: UIView!
    @IBOutlet weak var commentBackView: UIView!

    @IBOutlet weak var studentDisciplineCell: UITableViewCell!

    
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
     
    @IBAction func sepmentTap(_ sender: Any) {
        switch segmetControl.selectedSegmentIndex {
        case 0:
            studentDisciplineCell.isHidden = false
            priceTitle.isHidden = false
            priceBackView.isHidden = false
        case 1:
            studentDisciplineCell.isHidden = true
            priceTitle.isHidden = true
            priceBackView.isHidden = true
        default:
            break
        }
        tableView.reloadData()
    }
        
        
    
    @IBAction func studentButtonTap(_ sender: Any) {
        didSelect(view: studentBackView)
        _ = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            self.didDeselect(view: self.studentBackView)
        }
    }
    
    @IBAction func disciplineButtonTap(_ sender: Any) {
        didSelect(view: disciplineBackView)
        _ = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            self.didDeselect(view: self.disciplineBackView)
        }
    }
    
    @IBAction func isStartButtonTap(_ sender: Any) {
        let index = IndexPath(row: 3, section: 0)

        if startDatePicker.isHidden == true {
            startDatePicker.isHidden = false
            
            didSelect(view: startBackView)
            didDeselect(view: endBackView)
        
            startLabel.textColor = .appBlue
            endLabel.textColor = .black
        } else {
            startDatePicker.isHidden = true
            didDeselect(view: startBackView)
            startLabel.textColor = .black
        }
        endDatePicker.isHidden = true
        pickerAnimation(indexPath: index)
    }
    
    @IBAction func isEndButtonTap(_ sender: Any) {
        let index = IndexPath(row: 4, section: 0)
        
        if endDatePicker.isHidden == true {
            endDatePicker.isHidden = false
            didSelect(view: endBackView)
            didDeselect(view: startBackView)
            
            endLabel.textColor = .appBlue
            startLabel.textColor = .black
        } else {
            endDatePicker.isHidden = true
            didDeselect(view: endBackView)
            endLabel.textColor = .black
        }
        startDatePicker.isHidden = true
        pickerAnimation(indexPath: index)
    }
    
    
    @IBAction func isStartPickerChanged(sender: UIDatePicker) {
        let dur = StandartDuration.userDur
        
        endDatePicker.minimumDate = startDatePicker.date
        endDatePicker.setDate(startDatePicker.date.addingTimeInterval(dur), animated: true)
        
        setStartDateLabel()
        setEndDateLabel()
    }
    
    @IBAction func isEndPickerChanged(sender: UIDatePicker) {
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
    @IBAction func notificationButtonTap(_ sender: Any) {
        didSelect(view: notificationBackView)
        _ = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            self.didDeselect(view: self.notificationBackView)
        }
        
    }
    
    @IBAction func priceButtonTap(_ sender: Any) {
        priceCurrency.textColor = .black
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
        
        endRepeat(isHidden: true)
        hideKeyboardWhenTappedAround()
        setupStartLessonPicker()
        setupEndLessonPicker()
        setupNavigationBar()
        tableView.tableFooterView = UIView()
        
        setCellBackView()
        
        priceTF.attributedPlaceholder = NSAttributedString(string: "0", attributes: [NSAttributedString.Key.foregroundColor: UIColor.appTabIconGray])
    }
    
    private func setCellBackView() {
        let mass = [nameBackView, studentBackView, placeBackView, disciplineBackView, startBackView, endBackView, repeatBackView, endRepeatBackView, priceBackView, notificationBackView, commentBackView]
        
        for elem in mass {
            guard let elem = elem else { return }
            didDeselect(view: elem)
        }
        
        startLabel.textColor = .appTabIconGray
        endLabel.textColor = .appTabIconGray
    }
    
    private func didSelect(view: UIView) {
        view.layer.cornerRadius = view.frame.height / 6
        view.backgroundColor = .appLightBlue
        view.layer.borderColor = UIColor.clear.cgColor
    }
    
    private func didDeselect(view: UIView) {
        view.layer.cornerRadius = view.frame.height / 6
        view.backgroundColor = .fieldBackGray
        view.layer.borderColor = UIColor.fieldBorder.cgColor
        view.layer.borderWidth = 0.5
    }
    
    private func endRepeat(isHidden: Bool) {
        endRepeatTitle.isHidden = isHidden
        endRepeatLabel.isHidden = isHidden
        endRepeatBackView.isHidden = isHidden
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
        //        let statusBarHeight         = UIApplication.shared.statusBarFrame.height
        //        let gradientHeight          = statusBarHeight  + navBar!.frame.height
        
//        navigationItem.title = lesson == nil ? "Новый урок" : "Редактирование"
        //        navBar?.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        navigationItem.leftBarButtonItem?.title = "Отмена"
        navigationItem.leftBarButtonItem?.tintColor = .appBlue
        navigationItem.rightBarButtonItem?.tintColor = .appBlue
        
        UINavigationBar().set(controller: self)
        
    }
}

//MARK: Navigation
extension AddOrEditLessonTVC {
    @IBAction func unwiSegueAddMeeting (_ segue: UIStoryboardSegue) {
        
        if let studentTVC = segue.source as? StudentsForLessonTVC {
            self.student = studentTVC.selectedStudent
            self.studentLabel.text = "\(self.student?.name ?? "") \(self.student?.surname ?? "")"
        }

        if let disciplineTVC = segue.source as? DisciplinesForLessonTVC {
            self.disciplineLabel.text = disciplineTVC.selectedDiscipline
        }
        
        if let repeatTVC = segue.source as? RepeatTVC {
            self.repeatLabel.text = repeatTVC.repeatLesson.rawValue
            self.repeatLabel.textColor = .black
            if repeatTVC.repeatLesson.rawValue != RepeatLesson.never.rawValue {
                self.endRepeatLabel.text = "\(repeatTVC.endOfRepeat ?? "")"
                self.endRepeatLabel.textColor = .black
                endRepeat(isHidden: false)
            } else {
                endRepeat(isHidden: true)
            }
            tableView.reloadData()
        }
        
        if let notifTVC = segue.source as? NotificationTVC {
            self.notificationLabel.text = "\(notifTVC.selectedNotification)"
            self.notificationLabel.textColor = .black
            self.notifInSeconds = notifTVC.notifInSeconds
        }
        
        let nav = self.navigationController?.navigationBar
        nav?.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier {
        case "repeatLesson":
            guard let nav = segue.destination as? UINavigationController,
                let repeatTVC = nav.topViewController as? RepeatTVC else { return }
            repeatTVC.repeatLesson = repeatLabel.text == RepeatLesson.never.rawValue ? .never : .weekly
            repeatTVC.endOfRepeat = endRepeatLabel.text ?? ""
            
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
            endRepeat      : repeatLabel.text == "Никогда" ? "" : endRepeat,
            price          : Int(priceTF.text ?? "0"),
            note           : noteTV.text,
            payStatus      : lesson != nil ? lesson?.payStatus : 0,
            paymentDate    : lesson != nil ? lesson?.paymentDate: "")
        
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
        
        let nameAndPlace     = IndexPath(row: 0, section: 0)
        let studentDiscipline = IndexPath(row: 1, section: 0)
        let startEnd         = IndexPath(row: 2, section: 0)
        let startPicker      = IndexPath(row: 3, section: 0)
        let endPicker        = IndexPath(row: 4, section: 0)
        let repeatSign       = IndexPath(row: 5, section: 0)
        let notif            = IndexPath(row: 6, section: 0)
        let comment          = IndexPath(row: 7, section: 0)
        
        switch indexPath{
        case studentDiscipline:
            return CGFloat(studentDisciplineCell.isHidden ? 0.0 : 96.0)
        case startPicker:
            return CGFloat(startDatePicker.isHidden ? 0.0 : 216.0)
        case endPicker:
            return CGFloat(endDatePicker.isHidden ? 0.0 : 216.0)
//        case endRepeat:
//            return CGFloat(endRepeatCell.isHidden ? 0.0 : 96)
//        case price:
//            return CGFloat(priceCell.isHidden ? 0.0 : 96.0)
        default:
            return super.tableView(tableView, heightForRowAt: indexPath)
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
