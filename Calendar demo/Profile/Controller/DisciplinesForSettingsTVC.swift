//
//  DisciplinesVC.swift
//  Calendar demo
//
//  Created by Максим Окунеев on 7/11/20.
//  Copyright © 2020 Максим Окунеев. All rights reserved.
//

import UIKit

class DisciplinesForSettingsTVC: UITableViewController {
    
    public var selectedDiscipline = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupScreen()
    }
    
    @IBAction func addDiscipline(_ sender: Any) {
        addDiscipline()
    }
}

//MARK: Set Screen
extension DisciplinesForSettingsTVC {
    private func setupScreen() {
        tableView.tableFooterView = UIView()
    }
}

// MARK: Add Discipline func
extension DisciplinesForSettingsTVC {
    func addDiscipline() {
        UIAlertController.addTextAlert(target: self) { (newDiscipline: String?) in
                                        guard let newDiscipline = newDiscipline else { return }
                                        DisciplinesList.all.append(newDiscipline)
                                        self.tableView.reloadData()
        }
    }
}

// MARK: Table view data source
extension DisciplinesForSettingsTVC {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DisciplinesList.all.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "disciplineSettingsCell")!
        
        cell.textLabel?.text = DisciplinesList.all[indexPath.row]
  
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        DisciplinesList.all.remove(at: indexPath.row)
        tableView.reloadData()
    }
}
