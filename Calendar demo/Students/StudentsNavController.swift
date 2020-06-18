//
//  StudentsNavController.swift
//  Calendar demo
//
//  Created by Максим Окунеев on 6/18/20.
//  Copyright © 2020 Максим Окунеев. All rights reserved.
//

import UIKit

class StudentsNavController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showListOfStudents()
    }
    
    func showListOfStudents() {
        let showListOfStudents = UIStoryboard(name: "Students", bundle:nil).instantiateViewController(withIdentifier: "StudentsListTVC") as! StudentsListTVC
        
        showListOfStudents.onAddButtonTap = { [weak self] in
            guard let self = self else { return }
            self.openAddStudent()
        }
        showListOfStudents.onCellTap = { [weak self] in
            guard let self = self else { return }
            self.openDetails(from: .list)
        }
        pushViewController(showListOfStudents, animated: false)
    }
    
    func openAddStudent() {
        let addOrEditVC = UIStoryboard(name: "Students", bundle:nil).instantiateViewController(withIdentifier: "AddOrEditStudentTVC") as! AddOrEditStudentTVC
        addOrEditVC.onSaveButtonTap = { [weak self, weak addOrEditVC] in // weak ЧТОБЫ ИЗБЕЖАТЬ УТЕЧЕК ПАМЯТИ!
            guard let self = self, let addOrEditVC = addOrEditVC else { return }
            self.openDetails(from: .add(addOrEditVC))
        }
        let nav = UINavigationController(rootViewController: addOrEditVC)
        present(nav, animated: true)
    }
    
    enum Source {
        case list
        case add(UIViewController)
    }
    
    func openDetails(from source: Source) {
        let showStudentVC = UIStoryboard(name: "Students", bundle:nil).instantiateViewController(withIdentifier: "StudentProfileTVC") as! StudentProfileTVC
        switch source {
        case .list:
            pushViewController(showStudentVC, animated: true)
        case let .add(viewController):
            viewController.dismiss(animated: true) {
                self.pushViewController(showStudentVC, animated: true)
            }
        }
    }
}
