//
//  ContactsVC.swift
//  Calendar demo
//
//  Created by Максим Окунеев on 4/21/20.
//  Copyright © 2020 Максим Окунеев. All rights reserved.
//

import UIKit
import Moya

class ContactsTVC: UITableViewController {

    var users = [User]()
    let userProvider = MoyaProvider<UserService>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userProvider.request(.readUsers) { (result) in
            switch result {
            case .success(let response):
                let users = try! JSONDecoder().decode([User].self, from: response.data)
                self.users = users
                self.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    @IBAction func didTapAdd() {
        let kilo = User(id: 55, name: "Kilo Loco")
        
        userProvider.request(.createUser(name: kilo.name)) { (result) in
            switch result {
            case .success(let response):
                let newUser = try! JSONDecoder().decode(User.self, from: response.data)
                self.users.insert(newUser, at: 0)
                self.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
   
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let user = users[indexPath.row]
        cell.textLabel?.text = user.name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = users[indexPath.row]
        
        userProvider.request(.updateUser(id:user.id, name:"[Modified] " + user.name)) { (result) in
            switch result {
            case .success(let response):
                let modifiedUser = try! JSONDecoder().decode(User.self, from: response.data)
                self.users[indexPath.row] = modifiedUser
                self.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        let user = users[indexPath.row]
        print(user)
    }
}
