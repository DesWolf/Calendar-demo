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

    var contacts = [Contact]()
    private let networkManagerMainData =  NetworkManagerMainData()

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUsersData()
    }
    
    @IBAction func didTapAdd() {
    }
}

// MARK: Network
extension ContactsTVController {
    private func fetchUsersData() {
        networkManagerMainData.fetchUsersData() { [weak self]  (contacts, error)  in
            guard let contacts = contacts else {
                print(error ?? "")
                    DispatchQueue.main.async {
                        self?.alertNetwork(message: error ?? "")
                    }
                    return
                }
            self?.contacts = contacts
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
}

// MARK: TableViewDataSource
extension ContactsTVController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactsTVCell", for: indexPath) as! ContactsTVCell
        let user = contacts[indexPath.row]
        cell.configere(with: user)
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let contact = contacts[indexPath.row]
        print("Select \(contact)")
       
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        let contact = contacts[indexPath.row]
        print("Editing \(contact)")
    }
}
//MARK: Alert
extension ContactsTVController  {
    func alertNetwork(message: String) {
        UIAlertController.alert(title:"Error", msg:"\(message)", target: self)
    }
}
