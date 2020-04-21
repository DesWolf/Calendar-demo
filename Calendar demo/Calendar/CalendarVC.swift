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
    
    @IBOutlet weak var menuView: CVCalendarMenuView!
    @IBOutlet weak var calendarView: CVCalendarView!
    @IBOutlet var dayTextView: UITextView!
    
    var datesDictionary:[String:String] = ["20 April, 2020":"Service","19 April, 2020":"Change Oil","21 April, 2020":"Check brakes"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendarView.delegate = self
        menuView.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        menuView.commitMenuViewUpdate()
        calendarView.commitCalendarViewUpdate()
    }
    
    
}
extension CalendarVC: CVCalendarMenuViewDelegate, CVCalendarViewDelegate {
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
        return [UIColor.black]
    }
//    func dotMarker(sizeOnDayView dayView: DayView) -> CGFloat {
//        return 
//    }
    func shouldSelectDayView(_ dayView: DayView) -> Bool {
        return true
    }
    
    func didSelectDayView(_ dayView: DayView, animationDidFinish: Bool){
        
        dayTextView.text = ""
        // Look up date in dictionary
        if(datesDictionary[dayView.date.commonDescription] != nil){
            dayTextView.text = datesDictionary[dayView.date.commonDescription] // day is in the dictionary - wrote the corresponding text to dayTextView
        }
    }
    
    
    
}
