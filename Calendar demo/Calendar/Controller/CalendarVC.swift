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
    
    private let networkManagerCalendar = NetworkManagerCalendar()
    private var lessons: [LessonModel]?
    
    //    private var datesDictionary:[String] = []
    private var currentCalendar: Calendar?
    private var selectedDay = [LessonModel]()
    private var modeView: ModeView = .monthView
    
    var onAddButtonTap: (() -> (Void))?
    var onCellTap: ((LessonModel) -> (Void))?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        self.calendarView.calendarAppearanceDelegate = self
        
//        // Animator delegate [Unnecessary]
//        self.calendarView.animatorDelegate = self
        
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
    
    @IBAction func switchCalView(_ sender: Any) {
        switchMode()
    }
    
    @IBAction func addStudent(_ sender: Any) {
        onAddButtonTap?()
    }
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
        
        let gradientBackgroundColors = [UIColor.appBlueLignt.cgColor, UIColor.appBlueDark.cgColor]
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.colors = gradientBackgroundColors
        gradientLayer.locations = [0.0,1.0]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.frame = self.view.bounds
        
        self.backgroundImage.layer.insertSublayer(gradientLayer, at: 0)
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
    private func fetchCalendar(date: String) {
        
        
        
        let startDate = Date().monthMinusOne(str: date)
        let endDate = Date().monthPlusOne(str: date)
        
        networkManagerCalendar.fetchCalendar(startDate: serverDate(str: "\(startDate)"),
                                             endDate: serverDate(str: "\(endDate)"))
        { [weak self]  (calendar, error)  in
            guard let calendar = calendar else {
                print(error ?? "")
                DispatchQueue.main.async {
                    self?.simpleAlert(message: error ?? "")
                }
                return
            }
            self?.lessons = calendar
            self?.updateSelectedDay()
            
            DispatchQueue.main.async {
                self?.calendarView.contentController.refreshPresentedMonth()
                self?.calendarView.reloadInputViews()
                self?.tableView.reloadData()
            }
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "meetingCell", for: indexPath) as! DayTVCell
        let meeting = selectedDay[indexPath.row]
        cell.configere(with: meeting)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let meeting = selectedDay[indexPath.row]
        onCellTap?(meeting)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        let selectedLesson = selectedDay[indexPath.row]
        lessons?.remove(at: indexPath.row)
        
        deleteLesson(lessonId: selectedLesson.lessonId ?? 0)
        calendarView.contentController.refreshPresentedMonth()
        calendarView.commitCalendarViewUpdate()
        menuView.commitMenuViewUpdate()
        updateSelectedDay()
        
        tableView.reloadData()
        
        
        
    }
}

//MARK: Alert
extension CalendarVC {
    func simpleAlert(message: String) {
        UIAlertController.simpleAlert(title:"Ошибка", msg:"\(message)", target: self)
    }
}

//MARK: Date Support Func
extension CalendarVC {
    private func serverDate(str: String) -> String {
        return Date().convertStrDate(date: str, formatFrom: "yyyy-MM-dd HH:mm:ssZ", formatTo: "yyyy-MM-dd")
    }
}


//Настойка календаря
// MARK: - CVCalendarViewAppearanceDelegate
extension CalendarVC: CVCalendarViewAppearanceDelegate {
    
    func dayLabelWeekdayDisabledColor() -> UIColor { return .white }
    func dayLabelPresentWeekdayInitallyBold() -> Bool { return true }
    
    func dayLabelFont(by weekDay: Weekday, status: CVStatus, present: CVPresent) -> UIFont { return UIFont.systemFont(ofSize: 16) }
    
    //цвет цифр
    func dayLabelColor(by weekDay: Weekday, status: CVStatus, present: CVPresent) -> UIColor? {
        switch (weekDay, status, present) {
        case (_,.in,.present): return .red
        case (_, .selected, .present): return .white
        case (_, .out, _): return .gray
        case (.sunday, _, _), (.saturday, _, _): return UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)
        case (_, _, .not): return .white
            
        default: return  .purple
        }
    }
    
    //Линии между цифрами
    func topMarker(shouldDisplayOnDayView dayView: CVCalendarDayView) -> Bool { return true }
    func topMarkerColor() -> UIColor { UIColor(red: 1, green: 1, blue: 1, alpha: 0.3) }
    func dotMarkerColor() -> UIColor { .white }
}


//MARK: CVCalendar MenuViewDelegate
extension CalendarVC: CVCalendarMenuViewDelegate {
    func firstWeekday() -> Weekday { return Weekday.monday }
    func dayOfWeekTextColor() -> UIColor { return .white }
}


//MARK: CVCalendar CVCalendarViewDelegate
extension CalendarVC: CVCalendarViewDelegate {
    
    func presentationMode() -> CalendarMode { return CalendarMode.monthView }
    func shouldShowWeekdaysOut() -> Bool { return true }
    
    func shouldAutoSelectDayOnWeekChange() -> Bool { return true }
    func shouldAutoSelectDayOnMonthChange() -> Bool { return true }
    
    func presentedDateUpdated(_ date: CVDate) { title =  date.globalDescription }
    
    //загрузка данных при свайпе календаря
    func didShowNextMonthView(_ date: Date) { fetchCalendar(date: "\(date)") }
    func didShowPreviousMonthView(_ date: Date) { fetchCalendar(date: "\(date)") }
    
    func didShowNextWeekView(from startDayView: DayView, to endDayView: DayView) {
        guard endDayView.date.day <= 7 else { return }
        fetchCalendar(date: "\(startDayView.date.commonDescription)")
    }
    
    func didShowPreviousWeekView(from startDayView: DayView, to endDayView: DayView) {
        guard startDayView.date.day >= 24  else { return }
        fetchCalendar(date: "\(startDayView.date.commonDescription)")
    }
    
    //Кружки которые нравяться Егору
    //    func preliminaryView(viewOnDayView dayView: DayView) -> UIView {
    //        let circleView = CVAuxiliaryView(dayView: dayView, rect: dayView.frame, shape: CVShape.circle)
    //        circleView.fillColor = ColorsConfig.meetingFillCircle
    //        return circleView
    //    }
    
    //Текущие кружки
    func dayLabelBackgroundColor(by weekDay: Weekday, status: CVStatus, present: CVPresent) -> UIColor? {
        switch (weekDay, status, present) {
        case (_, .selected, .present): return .red
        case (_, .selected, .not): return UIColor(red: 146/255, green: 207/255, blue: 238/255, alpha: 1)
        default: return  UIColor.clear
        }
    }
    
    //Отрисовка точек под кружками
    func dotMarker(colorOnDayView dayView: DayView) -> [UIColor]{ return [.white] }
    func dotMarker(sizeOnDayView dayView: DayView) -> CGFloat { return 15 }
    func dotMarker(shouldShowOnDayView dayView: DayView) -> Bool{
        return preliminaryView(shouldDisplayOnDayView: dayView) ? true : false
    }
    
    
    func preliminaryView(shouldDisplayOnDayView dayView: DayView) -> Bool {
        if let day = dayView.date {
            let day2 = day.convertedDate()?.addingTimeInterval(60 * 60 * 24 )
            let convDay = "\(day2 ?? Date())".prefix(10)
            let datesDictionary = filterDates(lessons: lessons)
            
            for elem in 0..<datesDictionary.count {
                if convDay == datesDictionary[elem] {
                    return true
                }
            }
        }
        return false
    }
    
    
    func filterDates(lessons: [LessonModel]?) ->([String]) {
        var datesDictionary: [String]  = []
        datesDictionary.append(contentsOf: (lessons.map ({ $0.map ({($0.dateStart ?? "")}) }) ?? [""]))
        
        return datesDictionary
    }
    
    func filterDates2(lessons: [LessonModel]?) ->([String]) {
        var datesDictionary: [String]?  = []
        let res = lessons.map ({ $0.map ({($0.duration ?? [""])}) }) ?? [""]
        
        for index in 0..<(res?.count ?? 0) {
            datesDictionary?.append(contentsOf: res?[index] as? [String] ?? [])
        }
        
        return datesDictionary ?? [""]
    }
    
    
    func updateSelectedDay() {
        let today = Date().convertStrDate(date: "\(Date())",
            formatFrom: "yyyy-MM-dd HH:mm:ssZ",
            formatTo: "yyyy-MM-dd")
        
        self.selectedDay = self.lessons?.filter{ $0.dateStart == today } ?? []
    }
    
    
    func didSelectDayView(_ dayView: DayView, animationDidFinish: Bool){
        let day = Date().convertStrDate(date: "\(dayView.date.commonDescription)",
            formatFrom: "dd MMMM, yyyy",
            formatTo: "yyyy-MM-dd")
        
        selectedDay = self.lessons?.filter{ $0.dateStart == day } ?? []
        
        self.tableView.reloadData()
        self.tableView.tableFooterView = UIView()
    }
}
