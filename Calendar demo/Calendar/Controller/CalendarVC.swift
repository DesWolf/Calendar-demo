//
//  ViewController.swift
//  Calendar demo
//
//  Created by Максим Окунеев on 4/20/20.
//  Copyright © 2020 Максим Окунеев. All rights reserved.
//

import UIKit
import CVCalendar

class CalendarVC: UIViewController {
    
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var menuView: CVCalendarMenuView!
    @IBOutlet weak var calendarView: CVCalendarView!
    @IBOutlet weak var tableView: UITableView!
    
    private let networkManagerCalendar = NetworkManagerCalendar()
    private var calendar: [CalendarModel]?
    
    private var datesDictionary:[String] = []
    private var selectedDay = [CalendarModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureScreen()
        fetchCalendar(startDate: "2020-06-01", endDate: "2020-06-30")
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        menuView.commitMenuViewUpdate()
        calendarView.commitCalendarViewUpdate()
    }
    
    @IBAction func sendRequest(_ sender: Any) {
        fetchCalendar(startDate: "2020-06-01", endDate: "2020-06-30")
        self.calendarView.commitCalendarViewUpdate()
    }
    
}

//MARK: Set Screen
extension CalendarVC {
    private func configureScreen() {
        var startDate = Date().monthMinusOne
        var endDate = Date().monthPlusOne
        print(startDate, endDate)
        
        setupNavigationBar()
        self.view.backgroundColor = .bgStudent
        //        backgroundColor()
        calendarView.delegate = self
        menuView.delegate = self
    }
    
    private func backgroundColor() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        let firstColor = UIColor(red: 83/255, green: 185/255, blue: 209/255, alpha: 1)
        let secondColor = UIColor(red: 88/255, green: 110/255, blue: 180/255, alpha: 1)
        gradientLayer.colors = [firstColor.cgColor, secondColor.cgColor]
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
//        self.navigationController?.view.backgroundColor = .clear
    }
    
}

//MARK: Network
extension CalendarVC {
    private func fetchCalendar(startDate: String, endDate: String) {
        networkManagerCalendar.fetchCalendar(startDate: startDate, endDate: endDate) { [weak self]  (calendar, error)  in
            guard let calendar = calendar else {
                print(error ?? "")
                DispatchQueue.main.async {
                    self?.simpleAlert(message: error ?? "")
                }
                return
            }
            print(calendar)
            self?.calendar = calendar
            self?.datesDictionary.append(contentsOf: (self?.calendar.map ({ $0.map ({($0.dateStart ?? "")}) }) ?? [""]))
            for index in 0..<calendar.count {
                self?.datesDictionary.append(calendar[index].dateStart ?? "")
            }
            print(self?.datesDictionary)
            DispatchQueue.main.async {
                self?.calendarView.contentController.refreshPresentedMonth()
                self?.tableView.reloadData()
            }
        }
    }
}

//MARK: Alert
extension CalendarVC {
    func simpleAlert(message: String) {
        UIAlertController.simpleAlert(title:"Ошибка", msg:"\(message)", target: self)
    }
}

//MARK: CVCalendar MenuViewDelegate, CVCalendarViewDelegate
extension CalendarVC: CVCalendarMenuViewDelegate, CVCalendarViewDelegate{
    func presentationMode() -> CalendarMode {
        return CalendarMode.monthView
    }
    
    func firstWeekday() -> Weekday {
        return Weekday.monday
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
        let cvCalendarDate = Date().convertStrDate( date: "\(dayView.date.commonDescription)",
                                                    formatFrom: "dd MMMM, yyyy",
                                                    formatTo: "yyyy-MM-dd")
        
        for elem in 0..<datesDictionary.count {
            if cvCalendarDate == datesDictionary[elem] {
                return true
            }
        }
        return false
    }
    
    func didSelectDayView(_ dayView: DayView, animationDidFinish: Bool){
        let day = Date().convertStrDate(date: "\(dayView.date.commonDescription)",
                                        formatFrom: "dd MMMM, yyyy",
                                        formatTo: "yyyy-MM-dd")
        
        selectedDay = self.calendar?.filter{ $0.dateStart == day } ?? []
        
        self.tableView.reloadData()
        self.tableView.tableFooterView = UIView()
        print(day, selectedDay)
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
    
    //    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    //        return 50
    //    }
}





