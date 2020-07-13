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
    
    var onAddButtonTap: (() -> (Void))?
    var onCellTap: ((StudentModel) -> (Void))?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        confugureSearchBar()
    }
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        configureScreen()
        fetchStudents()
        self.tableView.reloadData()
    }
    
    @IBAction func addStudent(_ sender: Any) { onAddButtonTap?() }
    
    @IBAction func refreshButton(_ sender: Any) { fetchStudents() }
    
}
// MARK: Set Screen
extension StudentsListTVC {
    private func configureScreen() {
        confugureSearchBar()
        let navBar = self.navigationController?.navigationBar
        
        navBar?.prefersLargeTitles = false
        
        title = "Выбор ученика"
        navBar?.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        tableView.tableFooterView = UIView()
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
            print("Delete from server:",message.message ?? "")
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedStudent = students[indexPath.row]
        onCellTap?(selectedStudent)
    }
}

//MARK: Alert & Notification
extension StudentsListTVC  {
    func simpleAlert(message: String) {
        UIAlertController.simpleAlert(title:"Ошибка", msg:"\(message)", target: self)
    }
}

//MARK: SearchBar
extension StudentsListTVC: UISearchResultsUpdating {
    
    func confugureSearchBar() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Поиск"
        navigationItem.searchController = searchController
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    private func filterContentForSearchText(_ searchText: String){
        filtredStudents = students.filter { (students: StudentModel) -> Bool in
            return students.name?.lowercased().range(of: searchText.lowercased()) != nil ||
                students.surname?.lowercased().range(of: searchText.lowercased()) != nil
        }
        tableView.reloadData()
    }
}


