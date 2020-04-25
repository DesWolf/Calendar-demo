//
//  AddUserTVC.swift
//  Calendar demo
//
//  Created by Максим Окунеев on 4/23/20.
//  Copyright © 2020 Максим Окунеев. All rights reserved.
//

import UIKit

class AddUserTVC: UITableViewController {
    
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var surNameTF: UITextField!
    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var durationPicker: UIPickerView!
    @IBOutlet weak var lessonLabel: UILabel!
    @IBOutlet weak var lessonPicker: UIPickerView!
    @IBOutlet weak var priceTF: UITextField!
    @IBOutlet weak var commentTF: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var lessons = ["-", "Французский","Английский"]
    var duration = ["45 минут", "60 минут", "90 минут"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        datePicker.date = NSDate() as Date
        dateLabel.text = "\(datePicker.date)"
        datePicker.isHidden = true
        durationPicker.isHidden = true
        lessonPicker.isHidden = true
        self.hideKeyboardWhenTappedAround()
    }
    
    @IBAction func dateChanged(sender: UIDatePicker) {
        dateLabel.text = "\(datePicker.date)"
        print(dateLabel.text as Any)
    }
    
    @IBAction func saveButtonAction(_ sender: Any) {
//            guard let url = URL(string: "http://5.63.154.6/api/lesson?key=0194f13efb8487de1fc1b99edb5f598d") else { return }
//                let session = URLSession.shared
//                session.dataTask(with: url) { (data, response, error) in
//                    guard let response = response, let data = data else { return }
//                    
//                    print(data)
//                    do {
//                        let json = try JSONSerialization.jsonObject(with: data, options: [])
//                        print(json)
//                    } catch {
//                        print(error)
//                    }
//                }.resume()
            }
}



//MARK: TableViewDelegate, TableViewDataSource
extension AddUserTVC {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 4:
            return CGFloat(datePicker.isHidden ? 0.0 : 216.0)
        case 6:
            return CGFloat(durationPicker.isHidden ? 0.0 : 120.0)
        case 8:
            return CGFloat(lessonPicker.isHidden ? 0.0 : 120.0)
        default:
            return super.tableView(tableView, heightForRowAt: indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dateIndexPath = IndexPath(row: 3, section: 0)
        let durationIndexPath = IndexPath(row: 5, section: 0)
        let lessonIndexPath = IndexPath(row: 7, section: 0)
        
        switch indexPath {
        case dateIndexPath:
            datePicker.isHidden = !datePicker.isHidden
            pickerAnimation(indexPath: indexPath)
        case durationIndexPath:
            durationPicker.isHidden = !durationPicker.isHidden
            pickerAnimation(indexPath: indexPath)
        case lessonIndexPath:
            lessonPicker.isHidden = !lessonPicker.isHidden
            pickerAnimation(indexPath: indexPath)
        default:
            return
        }
    }
    
    func pickerAnimation(indexPath: IndexPath) {
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.tableView.beginUpdates()
            self.tableView.deselectRow(at: indexPath as IndexPath, animated: true)
            self.tableView.endUpdates()
        })
    }
}
//MARK: PickerView Delegate & DataSource
extension AddUserTVC : UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case 0:
            return duration.count
        case 1:
            return lessons.count
        default:
            return 0
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case 0:
            return duration[row]
        case 1:
            return lessons[row]
        default:
            return ""
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag {
        case 0:
            return durationLabel.text = duration[row]
        case 1:
            return lessonLabel.text = lessons[row]
        default:
            return
        }
        
    }
}
