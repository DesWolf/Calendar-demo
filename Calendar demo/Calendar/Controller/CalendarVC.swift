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
    
    private var datesDictionary:[String] = []
    private var selectedDay = [LessonModel]()
    private var modeView: ModeView = .monthView
    
    var onAddButtonTap: (() -> (Void))?
    var onCellTap: ((LessonModel) -> (Void))?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureScreen()
        fetchCalendar(date: "")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        menuView.commitMenuViewUpdate()
        calendarView.commitCalendarViewUpdate()
    }
    
    @IBAction func sendRequest(_ sender: Any) {
        fetchCalendar(date: "")
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
//        let startDate = Date().monthMinusOne
//        let endDate = Date().monthPlusOne
//        print(startDate, endDate)
        
        setupNavigationBar()
        backgroundColor()
        calendarView.delegate = self
        menuView.delegate = self
        
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
        let nav = self.navigationController?.navigationBar
        
        navigationItem.leftBarButtonItem?.title = "Отмена"
        navigationItem.leftBarButtonItem?.tintColor = .white
        navigationItem.rightBarButtonItem?.tintColor = .white
        
        nav?.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        nav?.topItem?.title = "Июнь"
        
        nav?.setBackgroundImage(UIImage(), for: .default)
        nav?.shadowImage = UIImage()
        nav?.isTranslucent = true
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
        
        let startDate = Date().convertStrToDate(str: date)
        let endDate = Date().monthPlusOne(date: startDate)
        
        print("startDate: \(startDate), endDate: \(endDate)")
        
        self.title = Date().month(date: startDate)
        
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
            self?.datesDictionary.append(contentsOf: (self?.lessons.map ({ $0.map ({($0.dateStart ?? "")}) }) ?? [""]))
            for index in 0..<calendar.count {
                self?.datesDictionary.append(calendar[index].dateStart ?? "")
            }
            let today = Date().convertStrDate(date: "\(Date())",
                                            formatFrom: "yyyy-MM-dd HH:mm:ssZ",
                                            formatTo: "yyyy-MM-dd")
           
            self?.selectedDay = self?.lessons?.filter{ $0.dateStart == today } ?? []
            
            DispatchQueue.main.async {
                self?.calendarView.contentController.refreshPresentedMonth()
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



//MARK: CVCalendar MenuViewDelegate, CVCalendarViewDelegate
extension CalendarVC: CVCalendarMenuViewDelegate, CVCalendarViewDelegate {
    
    func presentationMode() -> CalendarMode {
        return CalendarMode.monthView
    }
    
    func firstWeekday() -> Weekday {
        return Weekday.monday
    }
    
    func didShowNextMonthView(_ date: Date) {
        print(date)
        fetchCalendar(date: "\(date)")
    }

    func didShowPreviousMonthView(_ date: Date) {
        print(date)
        fetchCalendar(date: "\(date)")
    }

    func didShowNextWeekView(from startDayView: DayView, to endDayView: DayView) {
        print(endDayView.date.commonDescription)
    }

    func didShowPreviousWeekView(from startDayView: DayView, to endDayView: DayView) {
        print(endDayView.date.commonDescription)
    }
    
    func shouldAutoSelectDayOnWeekChange() -> Bool {
        return true
    }
    
    func shouldAutoSelectDayOnMonthChange() -> Bool {
        return true
    }
    
    
    
    
    
    
    
    func dayLabelBackgroundColor(by weekDay: Weekday, status: CVStatus, present: CVPresent) -> UIColor? {
        return UIColor(red: 88/255, green: 86/255, blue: 214/255, alpha: 1)
    }
    
    func dotMarker(shouldShowOnDayView dayView: DayView) -> Bool{
        if dayView.date.day == 1 {
            return false
        }
        return true
    }
    
    func dotMarker(colorOnDayView dayView: DayView) -> [UIColor]{
        switch preliminaryView(shouldDisplayOnDayView: dayView){
        case true:
            return [UIColor.white]
        case false:
            return [UIColor.white]
        }
        
    }
    func dotMarker(sizeOnDayView dayView: DayView) -> CGFloat {
        return CGFloat(5)
    }
    func topMarkerColor() -> UIColor {
        return UIColor.white //(red: 137/255, green: 177/255, blue: 212/255, alpha: 1)
    }
    func topMarker(shouldDisplayOnDayView dayView: DayView) -> Bool {
        return true
    }
    
    func preliminaryView(viewOnDayView dayView: DayView) -> UIView {
        let circleView = CVAuxiliaryView(dayView: dayView, rect: dayView.frame, shape: CVShape.circle)
        circleView.fillColor = ColorsConfig.meetingFillCircle
        return circleView
    }
    func preliminaryView(shouldDisplayOnDayView dayView: DayView) -> Bool {
        
//         крешится при смене отображения неделя/месяц
        
//        let cvCalendarDate = Date().convertStrDate( date: "\(dayView.date.commonDescription)",
//                                                    formatFrom: "dd MMMM, yyyy",
//                                                    formatTo: "yyyy-MM-dd")
//        print(cvCalendarDate)
//        for elem in 0..<datesDictionary.count {
//            if cvCalendarDate == datesDictionary[elem] {
//                return true
//            }
//        }
            return false
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
    
//MARK: CVCalendarViewAppearanceDelegate
extension CalendarVC: CVCalendarViewAppearanceDelegate {
    func dayOfWeekTextColor() -> UIColor {
        return .white
    }
    
    // не работает смена шрифта
    //    func dayLabelColor(by weekDay: Weekday, status: CVStatus, present: CVPresent) -> UIColor? {
    //        switch (weekDay, status, present) {
    //        case (_, _, _), (_, _, _): return .white
    ////        case (.sunday, .in, _): return ColorsConfig.sundayText
    ////        case (.sunday, _, _): return ColorsConfig.sundayTextDisabled
    ////        case (_, .in, _): return ColorsConfig.text
    //        //         case (.sunday, .disabled, _): return .red
    ////        default: return ColorsConfig.textDisabled
    //        }
    //    }
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
