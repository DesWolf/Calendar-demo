//
//  DisciplinesTVC.swift
//  Calendar demo
//
//  Created by Максим Окунеев on 5/28/20.
//  Copyright © 2020 Максим Окунеев. All rights reserved.
//

import UIKit



class DisciplinesTVC: UITableViewController {
    
   var chousedDisciplines: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupScreen()
    }
    
    @IBAction func AddButton(_ sender: Any) {
        addDiscipline()
    }
}

//MARK: Set Navigation Bar
extension DisciplinesTVC {
    private func setupScreen() {

        tableView.tableFooterView = UIView()
    }
    
}

// MARK: Add Discipline
extension DisciplinesTVC {
    func addDiscipline() {
        UIAlertController.addTextAlert(target: self,
                                       title: "Новая дисциплина",
                                       text: "Введите название дисциплины")
        { (newDiscipline: String?) in
            guard let newDiscipline = newDiscipline else { return }
            DisciplinesList.all.append(newDiscipline)
            self.tableView.reloadData()
        }
    }
}

// MARK: Table view data source
extension DisciplinesTVC {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DisciplinesList.all.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "disciplinesCell", for: indexPath) as! DisciplinesTVCell
        let discipline = DisciplinesList.all[indexPath.row]
        var image = #imageLiteral(resourceName: "oval")
        
        for elem in chousedDisciplines {
            if  discipline == elem {
                image = #imageLiteral(resourceName: "checkmark")
            }
        }
        cell.configure(discipline: discipline, image: image)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.dequeueReusableCell(withIdentifier: "disciplinesCell", for: indexPath) as! DisciplinesTVCell
        let discipline = DisciplinesList.all[indexPath.row]
        
        if chousedDisciplines.contains(discipline) {
            cell.checkImage.image = #imageLiteral(resourceName: "checkmark")
            chousedDisciplines = chousedDisciplines.filter{$0 != discipline}
        } else {
            cell.checkImage.image = #imageLiteral(resourceName: "oval")
            chousedDisciplines.append(discipline)
        }
        tableView.reloadData()
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
