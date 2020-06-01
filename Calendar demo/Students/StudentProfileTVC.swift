//
//  StudentProfileVC.swift
//  Calendar demo
//
//  Created by Максим Окунеев on 5/26/20.
//  Copyright © 2020 Максим Окунеев. All rights reserved.
//

import UIKit

class StudentProfileTVC: UITableViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var phoneTV: UITextView!
    @IBOutlet weak var emailTV: UITextView!
    @IBOutlet weak var disciplinesCollectionView: UICollectionView!
    @IBOutlet weak var noteTV: UITextView!
    
    var student: StudentModel?
    private let networkManagerStudents =  NetworkManagerStudents()
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchDetailedStudent(studentId: student?.studentId ?? 0)
        
    }

    
    @IBAction func unwiSegue(_ segue: UIStoryboardSegue) {
        guard let addOrEditStudentTVC = segue.source as? AddOrEditStudentTVC else { return }
        addOrEditStudentTVC.saveStudent()
        let editStudent = addOrEditStudentTVC.student
//        fetchDetailedStudent(studentId: student?.studentId ?? 0)
        setupScreen(student: editStudent)
    }
}
//MARK: Setup Screen
extension StudentProfileTVC {
    func setupScreen(student: StudentModel?) {
        
        
        setNavigationController()
        
        nameLabel.text = "\(student?.name ?? "") \(student?.surname ?? "")"
        commentLabel.text = "Макс уже нашел работу"
        phoneTV.text = student?.phone ?? ""
        emailTV.text = student?.email ?? ""
        noteTV.text = student?.note ?? ""
        self.tableView.tableFooterView = UIView(frame: CGRect(x: 0,
                                                              y: 0,
                                                              width: tableView.frame.size.width,
                                                              height: 1))

        phoneTV.isScrollEnabled = false
        emailTV.isScrollEnabled = false
        
        
        
    }
    
    func setNavigationController() {
    self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    self.navigationController?.navigationBar.shadowImage = UIImage()
    self.navigationController?.navigationBar.isTranslucent = true
    self.navigationController?.view.backgroundColor = .clear
    }
}

//MARK: UITextViewDelegate
extension StudentProfileTVC: UITextViewDelegate{
    func textView(_ textView: UITextView, shouldInteractWith URL: URL,
                  in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        UIApplication.shared.open(URL)
        return false
    }
}

//MARK: UICollectionView, UICollectionViewDelegateFlowLayout
extension StudentProfileTVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return student?.disciplines?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DisciplinesCell", for: indexPath) as! DisciplinesCollectionViewCell
        guard let discipline = student?.disciplines?[indexPath.row] else { return cell }
        cell.configure(with: discipline)
        return cell
    }
}

//MARK: TableViewDelegate
extension StudentProfileTVC {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 4:
            return UITableView.automaticDimension
        default:
            return super.tableView(tableView, heightForRowAt: indexPath)
        }
    }
}

// MARK: Navigation
extension StudentProfileTVC {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier  == "editStudent" {
            guard let addStudentTVC = segue.destination as? AddOrEditStudentTVC else { return }
            addStudentTVC.student = student
        }
    }
}

//MARK: Network
extension StudentProfileTVC {
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
                self?.setupScreen(student: student)
            }
        }
    }
}

//MARK: Alert
extension StudentProfileTVC  {
    func simpleAlert(message: String) {
        UIAlertController.simpleAlert(title:"Ошибка", msg:"\(message)", target: self)
    }
}
