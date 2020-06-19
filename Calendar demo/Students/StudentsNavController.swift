//
//  StudentsNavController.swift
//  Calendar demo
//
//  Created by Максим Окунеев on 6/18/20.
//  Copyright © 2020 Максим Окунеев. All rights reserved.
//

import UIKit

class StudentsNavController: UINavigationController {
    
    private let stStoryboard = UIStoryboard(name: "Students", bundle:nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        openListOfStudents()
    }
    
    func openListOfStudents() {
        let openListOfStudents = stStoryboard.instantiateViewController(withIdentifier: "StudentsListTVC") as! StudentsListTVC
        
        openListOfStudents.onAddButtonTap = { [weak self] in
            guard let self = self else { return }
            self.openAddStudent()
        }
        
        openListOfStudents.onCellTap = { [weak self] (student) in
            guard let self = self else { return }
            self.openDetails(from: .list(student: student))
        }
        
        pushViewController(openListOfStudents, animated: false)
    }
    
    
    func openDisciplines(disciplines: [String]) {
        
        let discTVC = stStoryboard.instantiateViewController(withIdentifier: "DisciplinesTVC") as! DisciplinesTVC
//        let addOrEditVC = stStoryboard.instantiateViewController(withIdentifier: "AddOrEditStudentTVC") as! AddOrEditStudentTVC
        
        
//        let nav = UINavigationController(rootViewController: discTVC)
        discTVC.chousedDisciplines = disciplines
        present(discTVC, animated: true)
//        nav.present(discTVC, animated: true)
     
    }
    
    func openAddStudent() {
        let addOrEditVC = stStoryboard.instantiateViewController(withIdentifier: "AddOrEditStudentTVC") as! AddOrEditStudentTVC
        
        addOrEditVC.onSaveButtonTap = { [weak self, weak addOrEditVC] (studentId: Int, student: StudentModel) in
            guard let self = self, let addOrEditVC = addOrEditVC else { return }
            self.openDetails(from: .addOfEdit(addOrEditVC, studentId: studentId, student: student))
        }
        
        let nav = UINavigationController(rootViewController: addOrEditVC)
        present(nav, animated: true)
    }
    
    func openEditStudent(student: StudentModel?) {
        let addOrEditVC = stStoryboard.instantiateViewController(withIdentifier: "AddOrEditStudentTVC") as! AddOrEditStudentTVC
        
        addOrEditVC.onSaveButtonTap = { [weak self, weak addOrEditVC] (studentId: Int, student: StudentModel) in
            guard let self = self, let addOrEditVC = addOrEditVC else { return }
            self.openDetails(from: .addOfEdit(addOrEditVC, studentId: studentId, student: student))
        }
        
        addOrEditVC.onDisciplinesButtonTap = { [weak self] (disciplines) in
            guard let self = self else { return }
            self.openDisciplines(disciplines: disciplines)
        }
        
        
        let nav = UINavigationController(rootViewController: addOrEditVC)
        if let student = student {
            addOrEditVC.student = student
        }
        present(nav, animated: true)
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
                self.openEditStudent(student: student)
            }
            
            switch source {
            case let .list(student):
                profileTVC.student = student
                self.pushViewController(profileTVC, animated: true)
            case let .addOfEdit(viewController, studentId, student):
                
                DispatchQueue.global(qos: .background).async {
                    profileTVC.fetchDetailedStudent(studentId: studentId)
                }
                
                profileTVC.student = student
                self.pushViewController(profileTVC, animated: false)
                viewController.dismiss(animated: true)
            }
        }
    }
    
    
}

