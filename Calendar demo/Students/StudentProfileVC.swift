//
//  StudentProfileVC.swift
//  Calendar demo
//
//  Created by Максим Окунеев on 5/26/20.
//  Copyright © 2020 Максим Окунеев. All rights reserved.
//

import UIKit

class StudentProfileVC: UIViewController {
    
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var statisticView: UIView!
    @IBOutlet weak var lessonsView: UIView!
    
    var student: StudentModel?
    private let networkManagerStudents =  NetworkManagerStudents()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScreen(student: student!)
    }
    
    @IBAction func switchViewSegmControl(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            profileView.alpha = 1
            lessonsView.alpha = 0
            statisticView.alpha = 0
        case 1:
            profileView.alpha = 0
            lessonsView.alpha = 1
            statisticView.alpha = 0
        case 2:
            profileView.alpha = 0
            lessonsView.alpha = 0
            statisticView.alpha = 1
        default:
            return
        }
    }
    
    @IBAction func unwiSegue(_ segue: UIStoryboardSegue) {
        guard let addOrEditStudentTVC = segue.source as? AddOrEditStudentTVC else { return }
        student = addOrEditStudentTVC.student
        
        fetchDetailedStudent(studentId: student?.studentId ?? 0)
        nameLabel.text = "\(student?.name ?? "") \(student?.surname ?? "")"
//        commentLabel.text = "Макс уже нашел работу"
        
        
    }
}
//MARK: Setup Screen
extension StudentProfileVC {
    func setupScreen(student: StudentModel) {
        fetchDetailedStudent(studentId: student.studentId ?? 0)
        nameLabel.text = "\(student.name ?? "") \(student.surname ?? "")"
        commentLabel.text = "Макс уже нашел работу"
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
    }
}

// MARK: Navigation
extension StudentProfileVC {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "editStudent":
            guard let addStudentTVC = segue.destination as? AddOrEditStudentTVC else { return }
            addStudentTVC.student = student
        
        case "profileContainer":
            guard let profileContainer = segue.destination as? StudentProfileDetaledTVC else { return }
            profileContainer.student = student
            
        
//        case "backToList":
//        if let navVC = segue.destination as? UINavigationController,
//            let addStudentTVC = navVC.topViewController as? StudentsListTVC {
//        }
//        
//            navigationController?.popViewController(animated: true)
//            dismiss(animated: true, completion: nil)
            
        default:
            return
        }
    }
}

//MARK: Network
extension StudentProfileVC {
    func fetchDetailedStudent(studentId: Int) {
        networkManagerStudents.fetchStudent(studentId: studentId) { [weak self]  (student, error) in
            guard let student = student else {
                print(error ?? "")
                DispatchQueue.main.async {
                    self?.simpleAlert(message: error ?? "")
                }
                return
            }
            DispatchQueue.main.async {
                self?.student = student
            }
        }
    }
}

//MARK: Alert
extension StudentProfileVC  {
    func simpleAlert(message: String) {
        UIAlertController.simpleAlert(title:"Ошибка", msg:"\(message)", target: self)
    }
}
