//
//  StudentsNavController.swift
//  Calendar demo
//
//  Created by Максим Окунеев on 6/18/20.
//  Copyright © 2020 Максим Окунеев. All rights reserved.
//

import UIKit

class StudentsNavController: UINavigationController {
    
    private let stStoryboard = UIStoryboard(name: "Students", bundle: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        openListOfStudents()
    }
    
    func openListOfStudents() {
        let listOfStudents = stStoryboard.instantiateViewController(withIdentifier: "StudentsListTVC") as! StudentsListTVC
        
        listOfStudents.onAddButtonTap = { [weak self] in
            guard let self = self else { return }
            self.openAddOrEditStudent(student: nil)
        }
        
        listOfStudents.onCellTap = { [weak self] (student) in
            guard let self = self else { return }
            self.openDetails(from: .list(student: student))
        }
        
        pushViewController(listOfStudents, animated: false)
    }
    
    func openAddOrEditStudent(student: StudentModel?) {
        let addOrEditVC = stStoryboard.instantiateViewController(withIdentifier: "AddOrEditStudentTVC") as! AddOrEditStudentTVC
        
        addOrEditVC.onSaveButtonTap = { [weak self, weak addOrEditVC] (studentId: Int, student: StudentModel) in
            guard let self = self, let addOrEditVC = addOrEditVC else { return }
            self.openDetails(from: .addOfEdit(addOrEditVC, studentId: studentId, student: student))
        }
        
        addOrEditVC.onBackButtonTap = { [weak self]  in
            guard let self = self else { return }
            self.popViewController(animated: true)
        }
                
        if let student = student {
            addOrEditVC.student = student
        }
        pushViewController(addOrEditVC, animated: true)
    }
    
    enum Source {
        case list(student: StudentModel)
        case addOfEdit(UIViewController, studentId: Int, student: StudentModel)
    }
    
    func openDetails(from source: Source) {
        
        DispatchQueue.main.async {
            let profileTVC = self.stStoryboard.instantiateViewController(withIdentifier: "StudentProfileTVC") as! StudentProfileTVC
            
            profileTVC.onBackButtonTap = { [weak self]  in
                guard let self = self else { return }
                self.popToRootViewController(animated: true)
            }
            profileTVC.onEditButtonTap = { [weak self] (student) in
                guard let self = self else { return }
                self.openAddOrEditStudent(student: student)
            }
            
            switch source {
                
            case let .list(student):
                profileTVC.student = student
                self.pushViewController(profileTVC, animated: true)
                
            case let .addOfEdit(viewController, studentId, student):
                
                    if student == nil {
                    DispatchQueue.global(qos: .background).async {
                        profileTVC.fetchDetailedStudent(studentId: studentId)
                    }
                    }
                
                profileTVC.student = student
                viewController.dismiss(animated: true) {
                    self.pushViewController(profileTVC, animated: false)
                }
                
            }
        }
    }
}

