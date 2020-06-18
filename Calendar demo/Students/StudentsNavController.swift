//
//  StudentsNavController.swift
//  Calendar demo
//
//  Created by Максим Окунеев on 6/18/20.
//  Copyright © 2020 Максим Окунеев. All rights reserved.
//

import UIKit

class StudentsNavController: UINavigationController {

   

//   init() {
//       current = StudentsListTVC()
//       super.init(nibName:  nil, bundle: nil)
//   }
//
//   required init?(coder aDecoder: NSCoder) {
//       fatalError("init(coder:) has not been implemented")
//   }
   
   override func viewDidLoad() {
       super.viewDidLoad()
      
    showListOfStudents()

   }
   

    func showListOfStudents() {
        let destVC = StudentsListTVC()
        self.navigationController?.pushViewController(destVC, animated: true)
    }
    
    func showAddStudents() {
        let destVC = AddOrEditLessonTVC()
        self.navigationController?.pushViewController(destVC, animated: true)
    }
}
