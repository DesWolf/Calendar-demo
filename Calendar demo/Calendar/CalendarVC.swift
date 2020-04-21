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
        
        dayTextView.text = ""
        // Look up date in dictionary
        if(datesDictionary[dayView.date.commonDescription] != nil){
            dayTextView.text = datesDictionary[dayView.date.commonDescription] // day is in the dictionary - wrote the corresponding text to dayTextView
        }
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
