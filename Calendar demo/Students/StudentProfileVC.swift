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

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
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
    
    func configure() {
        nameLabel.text = "\(student?.surname ?? "") \(student?.name ?? "")"
        commentLabel.text = "Макс уже нашел работу"
    }
}

// MARK: - Navigation
extension StudentProfileVC {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "profileContainer":
            let profileContainer = segue.destination as! StudentProfileDetaledTVC
            profileContainer.student = student!
        case "editStudent":
            let addStudentTVC = segue.destination as! AddStudentTVC
            addStudentTVC.currentStudent = student!
        default:
            return
        }
    }
}
