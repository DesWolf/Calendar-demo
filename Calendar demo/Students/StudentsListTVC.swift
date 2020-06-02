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
}

// MARK: - Navigation
extension StudentsListTVC {
    @IBAction func unwiSegue(_ segue: UIStoryboardSegue) {
        fetchStudents()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "showDetail":
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let student = isFiltering ? filtredStudents[indexPath.row] : students[indexPath.row]
            
            if let studentProfileVC = segue.destination as? StudentProfileTVC {
                studentProfileVC.student = student
            }
        case "newStudent":
//            if let navVC = segue.destination as? UINavigationController,
//                let addVC = navVC.topViewController as? AddOrEditStudentTVC {
//            }
            guard let studentProfileTVC = StudentProfileTVC.self else { return }
            studentProfileTVC.
            
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
    
    //    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    //        guard editingStyle == .delete else { return }
    //        let contact = students[indexPath.row]
    //        print("Editing \(contact)")
    //    }
}
//MARK: Alert
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


