//
//  ContactsVC.swift
//  Calendar demo
//
//  Created by Максим Окунеев on 4/21/20.
//  Copyright © 2020 Максим Окунеев. All rights reserved.
//

import UIKit

class StudentsTVC: UITableViewController {
    
    private let searchController = UISearchController(searchResultsController: nil)
    private var students = [StudentModel]()
    private var filtredStudents = [StudentModel]()
    private let networkManagerStudents =  NetworkManagerStudents()
    private let teacherId = "9"
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
        fetchUsersData(teacherId: teacherId)
        confugureSearchBar()
    }
    
}

// MARK: - Navigation
extension StudentsTVC {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            
            let student = isFiltering ? filtredStudents[indexPath.row] : students[indexPath.row]
            
            let studentProfileVC = segue.destination as! StudentProfileVC
            studentProfileVC.student = student
        }
    }
}

// MARK: Network
extension StudentsTVC {
    private func fetchUsersData(teacherId: String) {
        networkManagerStudents.fetchStudentsList(teacherId: teacherId) { [weak self]  (contacts, error)  in
            guard let contacts = contacts else {
                print(error ?? "")
                DispatchQueue.main.async {
                    self?.simpleAlert(message: error ?? "")
                }
                return
            }
            self?.students = contacts
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
}

// MARK: TableViewDataSource
extension StudentsTVC {
    
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
    
    //    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    //        guard editingStyle == .delete else { return }
    //        let contact = students[indexPath.row]
    //        print("Editing \(contact)")
    //    }
}
//MARK: Alert
extension StudentsTVC  {
    func simpleAlert(message: String) {
        UIAlertController.simpleAlert(title:"Ошибка", msg:"\(message)", target: self)
    }
}

//MARK: SearchBar
extension StudentsTVC: UISearchResultsUpdating {
    
    func confugureSearchBar() {
        searchController.searchResultsUpdater = self
//        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Поиск"
        navigationItem.searchController = searchController
        definesPresentationContext = true
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


