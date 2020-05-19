//
//  ContactsVC.swift
//  Calendar demo
//
//  Created by Максим Окунеев on 4/21/20.
//  Copyright © 2020 Максим Окунеев. All rights reserved.
//

import UIKit
//import Moya

class ContactsTVController: UITableViewController {
    
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
    
    @IBAction func didTapAdd() {
    }
}

// MARK: - Navigation
extension ContactsTVController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            
            let student = isFiltering ? filtredStudents[indexPath.row] : students[indexPath.row]
            
            let addStudentTVC = segue.destination as! AddStudentTVController
            addStudentTVC.currentStudent = student
        }
    }
}

// MARK: Network
extension ContactsTVController {
    private func fetchUsersData(teacherId: String) {
        networkManagerStudents.fetchStudentsList(teacherId: teacherId) { [weak self]  (contacts, error)  in
            guard let contacts = contacts else {
                print(error ?? "")
                DispatchQueue.main.async {
                    self?.alertNetwork(message: error ?? "")
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
extension ContactsTVController {
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isFiltering ? filtredStudents.count : students.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactsTVCell", for: indexPath) as! ContactsTVCell
        let student = isFiltering ? filtredStudents[indexPath.row] : students[indexPath.row]
        cell.configere(with: student)
        return cell
    }
    
    
    //    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //        let contact = students[indexPath.row]
    //
    //
    //    }
    
    //    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    //        guard editingStyle == .delete else { return }
    //        let contact = students[indexPath.row]
    //        print("Editing \(contact)")
    //    }
}
//MARK: Alert
extension ContactsTVController  {
    func alertNetwork(message: String) {
        UIAlertController.alert(title:"Error", msg:"\(message)", target: self)
    }
}

//MARK: SearchBar
extension ContactsTVController: UISearchResultsUpdating {
    
    func confugureSearchBar() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
        definesPresentationContext = true
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


