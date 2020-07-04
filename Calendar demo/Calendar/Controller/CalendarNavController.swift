//
//  CalendarNavController.swift
//  Calendar demo
//
//  Created by Максим Окунеев on 6/23/20.
//  Copyright © 2020 Максим Окунеев. All rights reserved.
//

import UIKit

class CalendarNavController: UINavigationController {
    
    private let stStoryboard = UIStoryboard(name: "Calendar", bundle:nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        openCalendar()
    }
    
    func openCalendar() {
        let calendar = stStoryboard.instantiateViewController(withIdentifier: "CalendarVC") as! CalendarVC
        
        calendar.onAddButtonTap = { [weak self] in
            guard let self = self else { return }
            let date = Date().convertStrToDate(str: "\(calendar.calendarView.presentedDate.commonDescription)")
            self.openAddOrEditLesson(lesson: nil, selectedDate: date)
            
        }
        calendar.onCellTap = { [weak self] (lesson) in
            guard let self = self else { return }
            self.openDetails(from: .list(lesson: lesson))
        }
        
        pushViewController(calendar, animated: false)
    }
    
    func openAddOrEditLesson(lesson: LessonModel?, selectedDate: Date?) {
        let addOrEditVC = stStoryboard.instantiateViewController(withIdentifier: "AddOrEditLessonTVC") as! AddOrEditLessonTVC
        
        addOrEditVC.onSaveButtonTap = { [weak self, weak addOrEditVC] (lessonId: Int, lesson: LessonModel) in
            guard let self = self, let addOrEditVC = addOrEditVC else { return }
            self.openDetails(from: .addOfEdit(addOrEditVC, lessonId: lessonId, lesson: lesson))
        }
        
        addOrEditVC.onBackButtonTap = { [weak self]  in
            guard let self = self else { return }
            
            self.popViewController(animated: true)
        }
        
        if let lesson = lesson {
            addOrEditVC.lesson = lesson
        } else {
            addOrEditVC.selectedDate = selectedDate
        }
        
        pushViewController(addOrEditVC, animated: true)
    }
    
    enum Source {
        case list(lesson: LessonModel)
        case addOfEdit(UIViewController, lessonId: Int, lesson: LessonModel)
    }
    
    func openDetails(from source: Source) {
        
        DispatchQueue.main.async {
            let profileTVC = self.stStoryboard.instantiateViewController(withIdentifier: "LessonDetailedTVC") as! LessonDetailedTVC
            
            profileTVC.onBackButtonTap = { [weak self]  in
                guard let self = self else { return }
                self.popToRootViewController(animated: true)
            }
            profileTVC.onEditButtonTap = { [weak self] (lesson) in
                guard let self = self else { return }
                self.openAddOrEditLesson(lesson: lesson, selectedDate: nil)
            }
            
            switch source {
                
            case let .list(lesson):
                profileTVC.lesson = lesson
                self.pushViewController(profileTVC, animated: true)
                
            case let .addOfEdit(viewController, lessonId, lesson):
                
                DispatchQueue.global(qos: .background).async {
                    profileTVC.fetchDetailedLesson(lessonId: lessonId)
                }
                profileTVC.lesson = lesson
                viewController.dismiss(animated: true) {
                    self.pushViewController(profileTVC, animated: false)
                }
            }
        }
    }
}

