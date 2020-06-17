//
//  ContactsVC.swift
//  Calendar demo
//
//  Created by Максим Окунеев on 4/21/20.
//  Copyright © 2020 Максим Окунеев. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

class StudentsListTVC: UITableViewController {
    
    private let searchController = UISearchController(searchResultsController: nil)
    private var students = [StudentModel]()
    private var filtredStudents = [StudentModel]()
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
        fetchStudents()
        confugureSearchBar()
        
    }
    @IBAction func refreshButton(_ sender: Any) {
        fetchStudents()
    }
}

// MARK: - Navigation
extension StudentsListTVC {
    @IBAction func unwiSegueListOfContacts (_ segue: UIStoryboardSegue) {
        if let addOrEditStudentTVC = segue.source as? AddOrEditStudentTVC {
            addOrEditStudentTVC.saveStudent()
            fetchStudents()
            simplePopup(text: "Добавлен новый ученик!")
        } else if segue.source is StudentProfileTVC {
            fetchStudents()
            simplePopup(text: "Ученик изменен")
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "showDetail":
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let student = isFiltering ? filtredStudents[indexPath.row] : students[indexPath.row]
            
            guard let studentProfileTVC = segue.destination as? StudentProfileTVC else { return }
            studentProfileTVC.student = student
            
        case "newStudent":
            guard let navVC = segue.destination as? UINavigationController else { return }
            _ = navVC.topViewController as? AddOrEditStudentTVC
        case .none:
            return
        case .some(_):
            return
        }
    }
    
}

// MARK: Network
extension StudentsListTVC {
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
    
    private func deleteStudent(studentId: Int) {
        networkManagerStudents.deleteStudent(studentId: studentId) { [weak self]  (message, error)  in
            guard let message = message else {
                print(error ?? "")
                DispatchQueue.main.async {
                    self?.simpleAlert(message: error ?? "")
                }
                return
            }
            print("Delete from server:",message.message)
        }
    }
}


// MARK: TableViewDataSource
extension StudentsListTVC {
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isFiltering ? filtredStudents.count : students.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactsTVCell", for: indexPath) as! StudentsTVCell
        let student = isFiltering ? filtredStudents[indexPath.row] : students[indexPath.row]
        cell.configere(with: student)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        let selectedStudent = students[indexPath.row]
        students.remove(at: indexPath.row)
        deleteStudent(studentId: selectedStudent.studentId ?? 0)
        tableView.reloadData()
    }
}

//MARK: Alert & Notification
extension StudentsListTVC  {
    func simpleAlert(message: String) {
        UIAlertController.simpleAlert(title:"Ошибка", msg:"\(message)", target: self)
    }
    
    func simplePopup(text: String) {
        let sampleStoryBoard : UIStoryboard = UIStoryboard(name: "Contacts", bundle:nil)
        let popUpVC  = sampleStoryBoard.instantiateViewController(withIdentifier: "popUpVC") as! PopUpVC
        
        let tabBarHeight: CGFloat = self.tabBarController?.tabBar.frame.height ?? 40
        let navHeight: CGFloat = self.navigationController?.navigationBar.frame.height ?? 20
        let windowWidth = self.view.frame.width
        let windowHeight = self.view.frame.height - tabBarHeight - navHeight
        
        popUpVC.message = text
        self.addChild(popUpVC)
        popUpVC.view.frame = CGRect(x: 0, y: 0, width: windowWidth, height: windowHeight)
        self.view.addSubview(popUpVC.view)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            popUpVC.moveOut()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                popUpVC.view.removeFromSuperview()
            }
        }
    }
}

//MARK: SearchBar
extension StudentsListTVC: UISearchResultsUpdating {
    
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


