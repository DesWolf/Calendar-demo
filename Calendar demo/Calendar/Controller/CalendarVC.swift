//
//  ViewController.swift
//  Calendar demo
//
//  Created by Максим Окунеев on 4/20/20.
//  Copyright © 2020 Максим Окунеев. All rights reserved.
//

import UIKit
import CVCalendar

enum ModeView {
    case monthView
    case weekView
}

class CalendarVC: UIViewController {
    
    @IBOutlet weak var backCalendarView: UIView!
    @IBOutlet weak var menuView: CVCalendarMenuView!
    @IBOutlet weak var calendarView: CVCalendarView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dateLabel: UILabel!
    
    var lessons: [LessonModel] = []
    var selectedDay: [LessonModel] = []
    var onAddButtonTap: (() -> (Void))?
    var onCellTap: ((LessonModel) -> (Void))?
    
    private let networkManagerCalendar = NetworkManagerCalendar()

    private var currentCalendar: Calendar?
    private var modeView: ModeView = .monthView
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.calendarView.calendarAppearanceDelegate = self
        self.menuView.menuViewDelegate = self
        self.calendarView.calendarDelegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        configureScreen()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        calendarView.commitCalendarViewUpdate()
        menuView.commitMenuViewUpdate()
    }
    
    @IBAction func sendRequest(_ sender: Any) {
        fetchCalendar(date: "\(Date())")
        self.calendarView.commitCalendarViewUpdate()
        print(lessons)
    }
    
    @IBAction func switchCalView(_ sender: Any) { switchMode() }
    
    @IBAction func addStudent(_ sender: Any) { onAddButtonTap?() }
}

//MARK: Set Screen
extension CalendarVC {
    private func configureScreen() {
        fetchCalendar(date: "\(Date())")
        setupNavigationBar()
        backgroundColor()
        
        calendarView.changeDaysOutShowingState(shouldShow: true)
    }
    
    private func backgroundColor() {
        backCalendarView.backgroundColor = .appBackGray
        backCalendarView.layer.cornerRadius = 10
        backCalendarView.layer.borderColor = UIColor.fieldBorder.cgColor
        backCalendarView.layer.borderWidth = 0.5
    }
    
    private func setupNavigationBar(){
        UINavigationBar().set(controller: self)
        navigationItem.rightBarButtonItem?.tintColor = .appBlue
        
        navigationItem.title = Date().month
    }
    
    func switchMode() {
        if modeView == ModeView.monthView {
            modeView = .weekView
            calendarView.changeMode(.weekView)
        } else {
            modeView = .monthView
            calendarView.changeMode(.monthView)
        }
    }
}

//MARK: Network
extension CalendarVC {
    func fetchCalendar(date: String) {
        
        let startDate = String("\(Date().monthMinusOne(str: date))".prefix(10))
        let endDate = String("\(Date().monthPlusOne(str: date))".prefix(10))
        
        networkManagerCalendar.fetchCalendar(startDate: startDate, endDate: endDate)
        { [weak self]  (calendar, error)  in
            guard let calendar = calendar else {
                print(error ?? "")
                DispatchQueue.main.async {
                    self?.simpleAlert(message: error ?? "")
                }
                return
            }
            self?.lessons = calendar
            
            self?.filterLessons(day: "\("\(Date())".prefix(10))")
            
            DispatchQueue.main.async {
                self?.calendarView.contentController.refreshPresentedMonth()
                self?.calendarView.reloadInputViews()
                self?.tableView.reloadData()
            }
        }
    }
    
    private func payStatusChange(lesson: LessonModel) {
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
            print("change:",responce.message ?? "")
            
        }
    }
    
    private func deleteLesson(lessonId: Int) {
        networkManagerCalendar.deleteLesson(lessonId: lessonId) { [weak self]  (message, error)  in
            guard let message = message else {
                print(error ?? "")
                DispatchQueue.main.async {
                    self?.simpleAlert(message: error ?? "")
                }
                return
            }
            print("Delete from server:",message.message ?? "")
        }
    }
}

//MARK: TableViewDelegate & TableViewDataSource
extension CalendarVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedDay.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "meetingCell", for: indexPath) as! LessonTVCell
        cell.configere(with: selectedDay[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        onCellTap?(selectedDay[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Удалить") {  (contextualAction, view, boolValue) in
            print("Delete")
            let selectedLesson = self.selectedDay[indexPath.row]
            self.lessons.remove(at: indexPath.row)
            self.selectedDay.remove(at: indexPath.row)
            self.deleteLesson(lessonId: selectedLesson.lessonId ?? 0)
            self.tableView.reloadData()
        }
        
        let edit = UIContextualAction(style: .normal, title: "₽") {  (contextualAction, view, boolValue) in
            self.paymentAlert(index: indexPath.row)
        }
        edit.backgroundColor = .appLightGreen
        
        return UISwipeActionsConfiguration(actions: [delete, edit])
    }
}

//MARK: Alert
extension CalendarVC {
    func simpleAlert(message: String) {
        UIAlertController.simpleAlert(title:"Ошибка", msg:"\(message)", target: self)
    }
    
    func paymentAlert(index: Int) {
        UIAlertController.paymentAlert(target: self) { (press: Bool) in
            if press == true {
                self.selectedDay[index].payStatus = 1
                self.selectedDay[index].paymentDate = String("\(Date())".prefix(10))
                self.payStatusChange(lesson: (self.selectedDay[index]))
            } else if press == false {
                self.selectedDay[index].payStatus = 0
                self.selectedDay[index].paymentDate = ""
                self.payStatusChange(lesson: (self.selectedDay[index]))
            }
            
            self.tableView.reloadData()
        }
    }
}
