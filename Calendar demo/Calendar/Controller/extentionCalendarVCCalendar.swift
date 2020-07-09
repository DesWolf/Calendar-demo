//
//  extentionCalendarVCCalendar.swift
//  Calendar demo
//
//  Created by Максим Окунеев on 7/9/20.
//  Copyright © 2020 Максим Окунеев. All rights reserved.
//

import UIKit
import CVCalendar

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
            let day2 = day.convertedDate()?.addingTimeInterval(60 * 60 * 24)
            let convDay = "\(day2 ?? Date())".prefix(10)
            let datesDictionary = filterDates(lessons: lessons)
            
            for elem in 0..<datesDictionary.count {
                if convDay == datesDictionary[elem].prefix(10) {
                    return true
                }
            }
        }
        return false
    }
    
    func didSelectDayView(_ dayView: DayView, animationDidFinish: Bool){
        if let day = dayView.date {
            let currentDay = "\(day.convertedDate()?.addingTimeInterval(60 * 60 * 24) ?? Date())"
            let shortCurrentDay = String(currentDay.prefix(10))
            
            filterLessons(day: shortCurrentDay)
            
            self.tableView.reloadData()
            self.tableView.tableFooterView = UIView()
            self.dateLabel.text = Date().str(str: "\(currentDay)", to: .fullDateTime)
        }
    }
    
    private func filterDates(lessons: [LessonModel]?) ->([String]) {
        var datesDictionary: [String]?  = []
        let res = lessons.map ({ $0.map ({($0.duration ?? [""])}) }) ?? [""]
        
        for index in 0..<(res?.count ?? 0) {
            datesDictionary?.append(contentsOf: res?[index] as? [String] ?? [])
        }
        return datesDictionary ?? [""]
    }
    
    func filterLessons(day: String) {
        selectedDay = lessons?.filter { ($0.duration?.filter({ $0.contains(day) == true }) != []) == true }
    }
}
