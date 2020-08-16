//
//  AlertCalendarVC.swift
//  Calendar demo
//
//  Created by Максим Окунеев on 7/14/20.
//  Copyright © 2020 Максим Окунеев. All rights reserved.
//

import UIKit
import CVCalendar

class AlertCalendarVC: UIViewController {
    
    @IBOutlet weak var backbroundView: UIView!
//    @IBOutlet weak var menuView: CVCalendarMenuView!
    @IBOutlet weak var calendarView: CVCalendarView!
    @IBOutlet weak var dateLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // CVCalendarMenuView initialization with frame
        //        self.menuView = CVCalendarMenuView(frame: CGRect(x: 0, y: 0, width: 300, height: 15))
        
        // CVCalendarView initialization with frame
        //        self.calendarView = CVCalendarView(frame: CGRect(x: 0, y: 20, width: 300, height: 450))
        
//         Appearance delegate [Unnecessary]
                self.calendarView.calendarAppearanceDelegate = self
        
        // Animator delegate [Unnecessary]
        self.calendarView.animatorDelegate = self
        
//        self.menuView.menuViewDelegate = self
        self.calendarView.calendarDelegate = self
        
        
        setupScreen()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Commit frames' updates
//        self.menuView.commitMenuViewUpdate()
        self.calendarView.commitCalendarViewUpdate()
    }
    
    
    
    @IBAction func dismissButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}

//MARK: Setup Screen
extension AlertCalendarVC {
    
    private func setupScreen() {
        
        backbroundView.layer.cornerRadius = 10
        backbroundView.layer.masksToBounds = false
        backbroundView.layer.shadowColor = UIColor.black.cgColor
        backbroundView.layer.shadowOpacity = 1
        backbroundView.layer.shadowOffset = .zero
        backbroundView.layer.shadowRadius = 10
        
        calendarView.layer.cornerRadius = 10
        calendarView.backgroundColor = .clear
    }
    
}

extension AlertCalendarVC: CVCalendarViewDelegate, CVCalendarMenuViewDelegate {
    
    func presentationMode() -> CalendarMode {
        .monthView
    }
    
    func firstWeekday() -> Weekday {
        .monday
    }
    
    
    
    func shouldSelectRange() -> Bool { return true }
//    func shouldAutoSelectDayOnMonthChange() -> Bool { return true }
    
    func didSelectRange(from startDayView: DayView, to endDayView: DayView) {
        
        print("RANGE SELECTED: \(startDayView.date.convertedDate()) to \(endDayView.date.convertedDate())")
    }
    
//    func selectionViewPath() -> ((CGRect) -> (UIBezierPath)) {
//        return { UIBezierPath(rect: CGRect(x: 0, y: 0, width: $0.width, height: $0.height)) }
//    }
    
    func didSelectDayView(_ dayView: DayView, animationDidFinish: Bool){
        if let day = dayView.date {
            let currentDay = "\(day.convertedDate()?.addingTimeInterval(60 * 60 * 24) ?? Date())"
 
            self.dateLabel.text = "\(Date().str(str: "\(currentDay)", to: .monthYear))".capitalizingFirstLetter()
        }
        
}
}
