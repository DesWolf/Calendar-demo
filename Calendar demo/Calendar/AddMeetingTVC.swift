//
//  ChangeMeetingVC.swift
//  Calendar demo
//
//  Created by Максим Окунеев on 4/21/20.
//  Copyright © 2020 Максим Окунеев. All rights reserved.
//

import UIKit

class AddMeetingTVC: UITableViewController {
    
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var dobDatePicker: UIDatePicker!
    @IBOutlet weak var dobLabel: UILabel!
    @IBOutlet weak var lessonLabel: UILabel!
    @IBOutlet weak var lessonPicker: UIPickerView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var lessons = ["Французский","Английский"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dobDatePicker.date = NSDate() as Date
        dobLabel.text = "\(dobDatePicker.date)" // my label in cell above
        dobDatePicker.isHidden = true
        lessonPicker.isHidden = true
        
        //        self.lessonPicker.delegate = self
        //        self.lessonPicker.dataSource = self
    }
    
    @IBAction func dateChanged(sender: UIDatePicker) {
        // updates ur label in the cell above
        dobLabel.text = "\(dobDatePicker.date)"
    }
    
    @IBAction func saveButtonAction(_ sender: Any) {
    }
    
    
}

//MARK: TableViewDelegate, TableViewDataSource
extension AddMeetingTVC {
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 2  {
            let height:CGFloat = dobDatePicker.isHidden ? 0.0 : 216.0
            return height
        }
        if indexPath.row == 4 {
            let height:CGFloat = lessonPicker.isHidden ? 0.0 : 122.0
            return height
        }
        return super.tableView(tableView, heightForRowAt: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dobIndexPath = NSIndexPath(row: 1, section: 0)
        
        if dobIndexPath as IndexPath == indexPath {
            dobDatePicker.isHidden = !dobDatePicker.isHidden
            
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                self.tableView.beginUpdates()
                // apple bug fix - some TV lines hide after animation
                self.tableView.deselectRow(at: indexPath as IndexPath, animated: true)
                self.tableView.endUpdates()
            })
        }
        
        let lessonIndexPath = NSIndexPath(row: 3, section: 0)
        
        if lessonIndexPath as IndexPath == indexPath {
            lessonPicker.isHidden = !lessonPicker.isHidden
            //            pickerAnimation()
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                self.tableView.beginUpdates()
                // apple bug fix - some TV lines hide after animation
                self.tableView.deselectRow(at: indexPath as IndexPath, animated: true)
                self.tableView.endUpdates()
            })
        }
    }
    
    //    func pickerAnimation() {
    //        UIView.animate(withDuration: 0.3, animations: { () -> Void in
    //            self.tableView.beginUpdates()
    //            // apple bug fix - some TV lines hide after animation
    //            self.tableView.deselectRow(at: indexPath as IndexPath, animated: true)
    //            self.tableView.endUpdates()
    //        })
    //    }
}

extension AddMeetingTVC : UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return lessons.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        lessons[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        lessonLabel.text = lessons[row]
    }
}

