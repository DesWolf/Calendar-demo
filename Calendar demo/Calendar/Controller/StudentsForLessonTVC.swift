//
//  studentsForCalendarTVC.swift
//  Calendar demo
//
//  Created by Максим Окунеев on 6/11/20.
//  Copyright © 2020 Максим Окунеев. All rights reserved.
//

import UIKit

class StudentsForLessonTVC: UITableViewController {

    private let searchController = UISearchController(searchResultsController: nil)
    private var students = [StudentModel]()
    private var filtredStudents = [StudentModel]()
    var selectedStudents = ""
    private let networkManagerStudents =  NetworkManagerStudents()
    private var search = false
    private var searchBarisEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    private var isFiltering: Bool {
        return searchController.isActive && !searchBarisEmpty
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        setupNavigationBar()
    }
}

//MARK: Set Screen
extension StudentsForLessonTVC {
    private func setupNavigationBar() {
        fetchStudents()
        let nav = self.navigationController?.navigationBar
        nav?.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.black]
        
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
        let studentNameSurname = "\(student.name ?? "") \(student.surname ?? "")"
        if studentNameSurname == selectedStudents {
            image = #imageLiteral(resourceName: "checkmark")
        }
        
        cell.configere(with: student, image: image)
        return cell
    }


override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let cell = tableView.dequeueReusableCell(withIdentifier: "studentsForLessonTVCell", for: indexPath) as! StudentsForLessonTVCell
    
    let student = isFiltering ? filtredStudents[indexPath.row] : students[indexPath.row]
    let studentNameSurname = "\(student.name ?? "") \(student.surname ?? "")"
   
    
    if selectedStudents == studentNameSurname {
        cell.checkBox.image = #imageLiteral(resourceName: "oval")
        selectedStudents = ""
        
    } else {
        cell.checkBox.image = #imageLiteral(resourceName: "checkmark")
        selectedStudents = studentNameSurname
        print(selectedStudents)
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
extension StudentsForLessonTVC: UISearchResultsUpdating {
    
    func confugureSearchBar() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Поиск"
        navigationItem.searchController = searchController
        //        definesPresentationContext = true
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
        searchController.obscuresBackgroundDuringPresentation = searchBarisEmpty ? true : false
    }
    
    private func filterContentForSearchText(_ searchText: String){
        filtredStudents = students.filter { (students: StudentModel) -> Bool in
            return students.name?.lowercased().range(of: searchText.lowercased()) != nil ||
                students.surname?.lowercased().range(of: searchText.lowercased()) != nil
        }
        tableView.reloadData()
    }
}

