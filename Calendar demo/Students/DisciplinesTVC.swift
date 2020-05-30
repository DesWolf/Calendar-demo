//
//  DisciplinesTVC.swift
//  Calendar demo
//
//  Created by Максим Окунеев on 5/28/20.
//  Copyright © 2020 Максим Окунеев. All rights reserved.
//

import UIKit

class DisciplinesTVC: UITableViewController {
    
    public var chousedDisciplines: [String] = []
    private var disciplines: [String] = DisciplinesList.all
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func AddButton(_ sender: Any) {
        addDiscipline()
    }
}

// MARK: - Add Discipline
extension DisciplinesTVC {
    func addDiscipline() {
        UIAlertController.addTextAlert(title: "Какую дисциплину вы бы хотели добавить?",
                                       target: self) { (newDiscipline: String?) in
                                        guard let newDiscipline = newDiscipline else { return }
                                        DisciplinesList.all.append(newDiscipline)
                                        self.tableView.reloadData()
//                                        DispatchQueue.main.async {
//                                            self.tableView.reloadData()
//                                        }
        }
    }
}

// MARK: - Table view data source
extension DisciplinesTVC {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DisciplinesList.all.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "disciplinesCell", for: indexPath) as! DisciplinesTVCell
        let discipline = DisciplinesList.all[indexPath.row]
        var image = #imageLiteral(resourceName: "checkboxEmpty")
        
        for elem in chousedDisciplines {
            if  discipline == elem {
                image = #imageLiteral(resourceName: "checkBoxFill")
            }
        }
        cell.configure(discipline: discipline, image: image)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.dequeueReusableCell(withIdentifier: "disciplinesCell", for: indexPath) as! DisciplinesTVCell
        let discipline = DisciplinesList.all[indexPath.row]
        
        if chousedDisciplines.contains(discipline) {
            cell.checkImage.image = #imageLiteral(resourceName: "checkboxEmpty")
            chousedDisciplines = chousedDisciplines.filter{$0 != discipline}
        } else {
            cell.checkImage.image = #imageLiteral(resourceName: "checkBoxFill")
            chousedDisciplines.append(discipline)
        }
        
        tableView.reloadData()
        print(chousedDisciplines)
        print(DisciplinesList.all)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
}
