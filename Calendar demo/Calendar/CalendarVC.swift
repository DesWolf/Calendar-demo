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
    
    @IBOutlet weak var menuView: CVCalendarMenuView!
    @IBOutlet weak var calendarView: CVCalendarView!
    @IBOutlet weak var tableView: UITableView!
    
    let calendarProvider = MoyaProvider<CalendarService>()
    var datesDictionary:[String:String] = ["20 April, 2020":"Service","19 April, 2020":"Change Oil","21 April, 2020":"Check brakes"]
    var dateMeetings = [CalendarModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendarView.delegate = self
        menuView.delegate = self
        dateFormater(str: "2013-07-21T19:32:00Z")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        menuView.commitMenuViewUpdate()
        calendarView.commitCalendarViewUpdate()
        
        
    }
    @IBAction func sendRequest(_ sender: Any) {
        calendarProvider.request(.readMeeting) { (result) in
            switch result {
            case .success(let response):
                let calendar = try! JSONDecoder().decode([DayModel].self, from: response.data)
                print(calendar)
                //                self.users = users
            //                self.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    
    
    
    
}
extension CalendarVC: CVCalendarMenuViewDelegate, CVCalendarViewDelegate{
    func presentationMode() -> CalendarMode {
        return CalendarMode.monthView
    }
    
    func firstWeekday() -> Weekday {
        return Weekday.monday
    }
    
    func dotMarker(shouldShowOnDayView dayView: DayView) -> Bool{
        // Look up date in dictionary
        if(datesDictionary[dayView.date.commonDescription] != nil){
            return true // date is in the array so draw a dot
        }
        return false
    }
    func dotMarker(colorOnDayView dayView: DayView) -> [UIColor]{
        return [UIColor.red]
    }
    func dotMarker(sizeOnDayView dayView: DayView) -> CGFloat {
        return CGFloat(5)
    }
    
    func preliminaryView(viewOnDayView dayView: DayView) -> UIView {
        let circleView = CVAuxiliaryView(dayView: dayView, rect: dayView.frame, shape: CVShape.circle)
        circleView.fillColor = .green
        return circleView
    }
    func preliminaryView(shouldDisplayOnDayView dayView: DayView) -> Bool {
        if(datesDictionary[dayView.date.commonDescription] != nil){
            return true
        }
        return false
    }
    
    func didSelectDayView(_ dayView: DayView, animationDidFinish: Bool){
        
        //        dayTextView.text = ""
        // Look up date in dictionary
        //        if(datesDictionary[dayView.date.commonDescription] != nil){
        //            dayTextView.text = datesDictionary[dayView.date.commonDescription] // day is in the dictionary - wrote the corresponding text to dayTextView
        //        }
    }
}

extension CalendarVC: CVCalendarViewAppearanceDelegate {
    
    // не работает смена шрифта
    func dayLabelColor(by weekDay: Weekday, status: CVStatus, present: CVPresent) -> UIColor? {
        switch (weekDay, status, present) {
        case (_, .selected, _), (_, .highlighted, _): return ColorsConfig.selectedText
        case (.sunday, .in, _): return ColorsConfig.sundayText
        case (.sunday, _, _): return ColorsConfig.sundayTextDisabled
        case (_, .in, _): return ColorsConfig.text
        //         case (.sunday, .disabled, _): return .red
        default: return ColorsConfig.textDisabled
        }
    }
    
    
}

extension CalendarVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datesDictionary.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "meetingCell", for: indexPath) as! DayTVCell
        let meeting = dateMeetings[indexPath.row]
        cell.configere(with: meeting)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

extension CalendarVC {
    
    func dateFormater(str: String) -> Date {
        let str = str //"2013-07-21T19:32:00Z"
        let formatter = ISO8601DateFormatter()
        guard let date = formatter.date(from: str) else { return formatter.date(from:"2013-07-21T19:32:00Z")! }
        print (date)
        return date
    }
}
