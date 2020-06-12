//
//  studentsForCalendarTVC.swift
//  Calendar demo
//
//  Created by Максим Окунеев on 6/11/20.
//  Copyright © 2020 Максим Окунеев. All rights reserved.
//

import UIKit

class StudentsForLessonTVC: UITableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    private var students = [StudentModel]()
    private var filtredStudents = [StudentModel]()
    var selectedStudent: StudentModel?
    private let networkManagerStudents =  NetworkManagerStudents()
    private var isFiltering: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setScreen()
    }
}

//MARK: Set Screen
extension StudentsForLessonTVC {
    
    private func setScreen(){
        fetchStudents()
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        let nav = self.navigationController?.navigationBar
        nav?.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.black]
    }
}

// MARK: Network
extension StudentsForLessonTVC {
    private func fetchStudents() {
        networkManagerStudents.fetchStudentsList() { [weak self]  (students, error)  in
            guard let students = students else {
                print(error ?? "")
                DispatchQueue.main.async {
                    self?.simpleAlert(message: error ?? "")
                }
                return
            }
            self?.students = students
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
}

// MARK: TableViewDataSource
extension StudentsForLessonTVC {
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isFiltering ? filtredStudents.count : students.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "studentsForLessonTVCell", for: indexPath) as! StudentsForLessonTVCell
        let student = isFiltering ? filtredStudents[indexPath.row] : students[indexPath.row]
        var image = #imageLiteral(resourceName: "oval")

        if student.studentId == selectedStudent?.studentId {
            image = #imageLiteral(resourceName: "checkmark")
        }
        
        cell.configere(with: student, image: image)
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.dequeueReusableCell(withIdentifier: "studentsForLessonTVCell", for: indexPath) as! StudentsForLessonTVCell
        
        let student = isFiltering ? filtredStudents[indexPath.row] : students[indexPath.row]
        
        if student.studentId == selectedStudent?.studentId {
            cell.checkBox.image = #imageLiteral(resourceName: "oval")
            selectedStudent = nil
            
        } else {
            cell.checkBox.image = #imageLiteral(resourceName: "checkmark")
            selectedStudent = student
        }
        tableView.reloadData()
    }
}

//MARK: Alert & Notification
extension StudentsForLessonTVC  {
    func simpleAlert(message: String) {
        UIAlertController.simpleAlert(title:"Ошибка", msg:"\(message)", target: self)
    }
}

//MARK: SearchBar
extension StudentsForLessonTVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard searchText != "" && searchText != " " else {
            isFiltering = false
            tableView.reloadData()
            return
        }
        isFiltering = true
        
        filtredStudents = students.filter { (students: StudentModel) -> Bool in
            return students.name?.lowercased().range(of: searchText.lowercased()) != nil ||
                    students.surname?.lowercased().range(of: searchText.lowercased()) != nil
        }
        tableView.reloadData()
}
}
