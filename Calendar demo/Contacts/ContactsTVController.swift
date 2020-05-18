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

    var students = [StudentModel]()
    private let networkManagerStudents =  NetworkManagerStudents()
    private let teacherId = "9"

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUsersData(teacherId: teacherId)
    }
    
    @IBAction func didTapAdd() {
    }
}

// MARK: - Navigation
extension ContactsTVController {
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       if segue.identifier == "showDetail" {
           guard let indexPath = tableView.indexPathForSelectedRow else { return }
           
        let student = students[indexPath.row]
           
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
        return 44
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return students.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactsTVCell", for: indexPath) as! ContactsTVCell
        let user = students[indexPath.row]
        cell.configere(with: user)
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
