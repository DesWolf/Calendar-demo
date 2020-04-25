//
//  ViewController.swift
//  Calendar demo
//
//  Created by Максим Окунеев on 4/20/20.
//  Copyright © 2020 Максим Окунеев. All rights reserved.
//

import UIKit
import CVCalendar
import Moya


class CalendarVC: UIViewController {
    
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var menuView: CVCalendarMenuView!
    @IBOutlet weak var calendarView: CVCalendarView!
    @IBOutlet weak var tableView: UITableView!
    
    private var datesDictionary:[String] = []
    private var calendarMeetings = [DayModel]()
    private var selectedDay = [DayModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchCalendar()
        backgroundColor()
        calendarView.delegate = self
        menuView.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        menuView.commitMenuViewUpdate()
        calendarView.commitCalendarViewUpdate()
    }
    
    @IBAction func sendRequest(_ sender: Any) {
        self.calendarView.commitCalendarViewUpdate()
    }
    
}
//MARK: Network
extension CalendarVC {
    private func fetchCalendar() {
        CalendarService.fetchCalendar { (jsonData) in
            self.calendarMeetings = jsonData
            
            for index in 0..<self.calendarMeetings.count {
                self.datesDictionary.append(self.calendarMeetings[index].date ?? "")
            }
            print(self.datesDictionary)
            self.calendarView.contentController.refreshPresentedMonth()

        }
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
            return [UIColor(red: 88/255, green: 0/255, blue: 214/255, alpha: 1)]
        case false:
            return [UIColor(red: 88/255, green: 86/255, blue: 214/255, alpha: 1)]
        }
        //        return [UIColor(red: 88/255, green: 86/255, blue: 214/255, alpha: 1)]
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

        
        for elem in 0..<datesDictionary.count {
            if(toNewFormatDate(dateString: "\(dayView.date.commonDescription)") == datesDictionary[elem]) {
                return true
            }
        }
        return false
    }
    
    
    //    func dotMarker(shouldShowOnDayView dayView: CVCalendarDayView) -> Bool {
    //        let dateformatter = DateFormatter()
    //        dateformatter.dateFormat = "yyyy-MM-dd"
    //        let date2 = dateformatter.string(from: dayView.date.convertedDate()!)
    //        for elem in 0..<datesDictionary.count {
    //            let str = datesDictionary[elem]
    //            if(date2 == str.substring(toIndex: str.length - 9)) {
    //                return true
    //            }
    //        }
    //        return false
    //    }
    
    func didSelectDayView(_ dayView: DayView, animationDidFinish: Bool){
        let selectDay = toNewFormatDate(dateString: "\(dayView.date.commonDescription)")
        selectedDay = self.calendarMeetings.filter{ $0.date == selectDay }
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

//MARK: DateString
extension CalendarVC {
    func dateString(format: String) -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = format
        
        return formatter.string(from: date)
    }
    
    func toNewFormatDate(dateString: String) -> String{
      var result = ""
      let formatter = DateFormatter()
      formatter.dateFormat = "dd MMMM, yyyy"
      if let date = formatter.date(from: dateString) {
        formatter.dateFormat = "yyyy-MM-dd"
        result = formatter.string(from: date)
      }
     return result
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}



//MARK: Background Customization
extension CalendarVC {
    func backgroundColor() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        let firstColor = UIColor(red: 83/255, green: 185/255, blue: 209/255, alpha: 1)
        let secondColor = UIColor(red: 88/255, green: 110/255, blue: 180/255, alpha: 1)
        gradientLayer.colors = [firstColor.cgColor, secondColor.cgColor]
        self.backgroundImage.layer.insertSublayer(gradientLayer, at: 0)
        clearNavigationBar()
    }
    
    func clearNavigationBar(){
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
    }
}

//MARK: String Sorting
extension String {
    
    var length: Int {
        return count
    }
    
    subscript (i: Int) -> String {
        return self[i ..< i + 1]
    }
    
    func substring(fromIndex: Int) -> String {
        return self[min(fromIndex, length) ..< length]
    }
    
    func substring(toIndex: Int) -> String {
        return self[0 ..< max(0, toIndex)]
    }
    
    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
                                            upper: min(length, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start ..< end])
    }
}
