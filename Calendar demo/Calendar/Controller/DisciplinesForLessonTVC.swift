//
//  Disciplines.swift
//  Calendar demo
//
//  Created by Максим Окунеев on 6/11/20.
//  Copyright © 2020 Максим Окунеев. All rights reserved.
//

import UIKit

class DisciplinesForLessonTVC: UITableViewController {
    
    public var selectedDiscipline: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
    }
    
    @IBAction func addDiscipline(_ sender: Any) {
        addDiscipline()
    }
}

//MARK: Set Screen
extension DisciplinesForLessonTVC {
    private func setupNavigationBar() {
        let nav = self.navigationController?.navigationBar
        nav?.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.black]
    }
}

// MARK: Add Discipline func
extension DisciplinesForLessonTVC {
    func addDiscipline() {
        UIAlertController.addTextAlert(title: "Какую дисциплину вы бы хотели добавить?",
                                       target: self) { (newDiscipline: String?) in
                                        guard let newDiscipline = newDiscipline else { return }
                                        DisciplinesList.all.append(newDiscipline)
                                        self.tableView.reloadData()
        }
    }
}

// MARK: Table view data source
extension DisciplinesForLessonTVC {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DisciplinesList.all.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "disciplinesLessonCell", for: indexPath) as! DisciplineLessonTVCell
        let discipline = DisciplinesList.all[indexPath.row]
        var image = UIImage()
        
        if discipline == selectedDiscipline {
            image = #imageLiteral(resourceName: "check")
        }
        
        cell.configure(discipline: discipline, image: image)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.dequeueReusableCell(withIdentifier: "disciplinesLessonCell", for: indexPath) as! DisciplineLessonTVCell
        let discipline = DisciplinesList.all[indexPath.row]
        
        if selectedDiscipline == discipline {
            cell.checkImage.image = UIImage()
            selectedDiscipline = ""
        } else {
            cell.checkImage.image = #imageLiteral(resourceName: "check")
            selectedDiscipline = discipline
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
