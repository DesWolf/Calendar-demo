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
    
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var menuView: CVCalendarMenuView!
    @IBOutlet weak var calendarView: CVCalendarView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var separatorImage: UIImageView!
    
    private let networkManagerCalendar = NetworkManagerCalendar()
    var lessons: [LessonModel]?
    private var currentCalendar: Calendar?
    var selectedDay: [LessonModel]?
    private var modeView: ModeView = .monthView
    
    var onAddButtonTap: (() -> (Void))?
    var onCellTap: ((LessonModel) -> (Void))?
    
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
        
        separatorImage.backgroundColor = .separator
        calendarView.changeDaysOutShowingState(shouldShow: true)
    }
    
    private func backgroundColor() {
        
        let gradientBackgroundColors = [UIColor.appBlueLignt.cgColor, UIColor.appBlueDark.cgColor]
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.colors = gradientBackgroundColors
        gradientLayer.locations = [0.0,1.0]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.frame = self.view.bounds
        
        self.backgroundImage.layer.insertSublayer(gradientLayer, at: 0)
        
        tableView.backgroundColor = .appGray
    }
    
    private func setupNavigationBar(){
        let navBar = self.navigationController?.navigationBar
        
        navigationItem.leftBarButtonItem?.title = "Отмена"
        navigationItem.leftBarButtonItem?.tintColor = .white
        navigationItem.rightBarButtonItem?.tintColor = .white
        
        navBar?.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        title = Date().month
        
        navBar?.setBackgroundImage(UIImage(), for: .default)
        navBar?.shadowImage = UIImage()
        navBar?.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
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
            //                        print(calendar)
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
//            DispatchQueue.main.async {
//                self?.tableView.reloadData()
//            }
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return selectedDay?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "headerCell", for: indexPath)
            cell.backgroundColor = .appGray
            
            return cell
            
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "meetingCell", for: indexPath) as! DayTVCell
            guard let meeting = selectedDay?[indexPath.section] else { return cell }
            cell.configere(with: meeting)
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath == IndexPath(row: 0, section: 0) { return 25 }
        
        switch indexPath.row {
        case 0:
            return 10
        default:
            return 60
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let meeting = selectedDay?[indexPath.section] else { return }
        onCellTap?(meeting)
    }
    
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Удалить") {  (contextualAction, view, boolValue) in
            print("Delete")
            let selectedLesson = self.selectedDay?[indexPath.section]
            self.lessons?.remove(at: indexPath.section)
            self.selectedDay?.remove(at: indexPath.section)
            self.deleteLesson(lessonId: selectedLesson?.lessonId ?? 0)
        }
        
        let edit = UIContextualAction(style: .normal, title: "₽") {  (contextualAction, view, boolValue) in
            
            print("Edit")
//            let lesson = self.lessons?[indexPath.section]
            self.paymentAlert(section: indexPath.section)
            
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
    
    func paymentAlert(section: Int) {
        UIAlertController.paymentAlert(target: self) { (press: Bool) in
            
            if press == true {
                self.selectedDay?[section].payStatus = 1
                self.selectedDay?[section].paymentDate = String("\(Date())".prefix(10))
                self.payStatusChange(lesson: (self.selectedDay?[section])!)
                
            } else if press == false {
                self.selectedDay?[section].payStatus = 0
                self.selectedDay?[section].paymentDate = ""
                self.payStatusChange(lesson: (self.selectedDay?[section])!)
            }
            
            self.tableView.reloadData()
            print(self.lessons)
            
        }
    }
}


////Настойка календаря
//// MARK: - CVCalendarViewAppearanceDelegate
//extension CalendarVC: CVCalendarViewAppearanceDelegate {
//    
//    func dayLabelWeekdayDisabledColor() -> UIColor { return .white }
//    func dayLabelPresentWeekdayInitallyBold() -> Bool { return true }
//    
//    func dayLabelFont(by weekDay: Weekday, status: CVStatus, present: CVPresent) -> UIFont { return UIFont.systemFont(ofSize: 16) }
//    
//    //цвет цифр
//    func dayLabelColor(by weekDay: Weekday, status: CVStatus, present: CVPresent) -> UIColor? {
//        switch (weekDay, status, present) {
//        case (_,.in,.present): return .red
//        case (_, .selected, .present): return .white
//        case (_, .out, _): return .gray
//        case (.sunday, _, _), (.saturday, _, _): return UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)
//        case (_, _, .not): return .white
//            
//        default: return  .purple
//        }
//    }
//    
//    //Линии между цифрами
//    func topMarker(shouldDisplayOnDayView dayView: CVCalendarDayView) -> Bool { return true }
//    func topMarkerColor() -> UIColor { UIColor(red: 1, green: 1, blue: 1, alpha: 0.3) }
//    func dotMarkerColor() -> UIColor { .white }
//}
//
//
////MARK: CVCalendar MenuViewDelegate
//extension CalendarVC: CVCalendarMenuViewDelegate {
//    func firstWeekday() -> Weekday { return Weekday.monday }
//    func dayOfWeekTextColor() -> UIColor { return .white }
//}
//
//
////MARK: CVCalendar CVCalendarViewDelegate
//extension CalendarVC: CVCalendarViewDelegate {
//    
//    func presentationMode() -> CalendarMode { return CalendarMode.monthView }
//    func shouldShowWeekdaysOut() -> Bool { return true }
//    
//    func shouldAutoSelectDayOnWeekChange() -> Bool { return true }
//    func shouldAutoSelectDayOnMonthChange() -> Bool { return true }
//    
//    func presentedDateUpdated(_ date: CVDate) { title =  date.globalDescription }
//    
//    //загрузка данных при свайпе календаря
//    func didShowNextMonthView(_ date: Date) { fetchCalendar(date: "\(date)") }
//    func didShowPreviousMonthView(_ date: Date) { fetchCalendar(date: "\(date)") }
//    
//    func didShowNextWeekView(from startDayView: DayView, to endDayView: DayView) {
//        guard endDayView.date.day <= 7 else { return }
//        fetchCalendar(date: "\(startDayView.date.commonDescription)")
//    }
//    
//    func didShowPreviousWeekView(from startDayView: DayView, to endDayView: DayView) {
//        guard startDayView.date.day >= 24  else { return }
//        fetchCalendar(date: "\(startDayView.date.commonDescription)")
//    }
//    
//    //Кружки которые нравяться Егору
//    //    func preliminaryView(viewOnDayView dayView: DayView) -> UIView {
//    //        let circleView = CVAuxiliaryView(dayView: dayView, rect: dayView.frame, shape: CVShape.circle)
//    //        circleView.fillColor = ColorsConfig.meetingFillCircle
//    //        return circleView
//    //    }
//    
//    //Текущие кружки
//    func dayLabelBackgroundColor(by weekDay: Weekday, status: CVStatus, present: CVPresent) -> UIColor? {
//        switch (weekDay, status, present) {
//        case (_, .selected, .present): return .red
//        case (_, .selected, .not): return UIColor(red: 146/255, green: 207/255, blue: 238/255, alpha: 1)
//        default: return  UIColor.clear
//        }
//    }
//    
//    //Отрисовка точек под кружками
//    func dotMarker(colorOnDayView dayView: DayView) -> [UIColor]{ return [.white] }
//    func dotMarker(sizeOnDayView dayView: DayView) -> CGFloat { return 15 }
//    func dotMarker(shouldShowOnDayView dayView: DayView) -> Bool{
//        return preliminaryView(shouldDisplayOnDayView: dayView) ? true : false
//    }
//    
//    
//    func preliminaryView(shouldDisplayOnDayView dayView: DayView) -> Bool {
//        if let day = dayView.date {
//            let day2 = day.convertedDate()?.addingTimeInterval(60 * 60 * 24)
//            let convDay = "\(day2 ?? Date())".prefix(10)
//            let datesDictionary = filterDates(lessons: lessons)
//            
//            for elem in 0..<datesDictionary.count {
//                if convDay == datesDictionary[elem].prefix(10) {
//                    return true
//                }
//            }
//        }
//        return false
//    }
//    
//    func didSelectDayView(_ dayView: DayView, animationDidFinish: Bool){
//        if let day = dayView.date {
//            let currentDay = "\(day.convertedDate()?.addingTimeInterval(60 * 60 * 24) ?? Date())"
//            let shortCurrentDay = String(currentDay.prefix(10))
//            
//            filterLessons(day: shortCurrentDay)
//            
//            self.tableView.reloadData()
//            self.tableView.tableFooterView = UIView()
//            self.dateLabel.text = Date().str(str: "\(currentDay)", to: .fullDateTime)
//        }
//    }
//    
//    private func filterDates(lessons: [LessonModel]?) ->([String]) {
//        var datesDictionary: [String]?  = []
//        let res = lessons.map ({ $0.map ({($0.duration ?? [""])}) }) ?? [""]
//        
//        for index in 0..<(res?.count ?? 0) {
//            datesDictionary?.append(contentsOf: res?[index] as? [String] ?? [])
//        }
//        return datesDictionary ?? [""]
//    }
//    
//    private func filterLessons(day: String) {
//        selectedDay = lessons?.filter { ($0.duration?.filter({ $0.contains(day) == true }) != []) == true }
//    }
//}
