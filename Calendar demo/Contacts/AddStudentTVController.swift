//
//  AddUserTVC.swift
//  Calendar demo
//
//  Created by Максим Окунеев on 4/23/20.
//  Copyright © 2020 Максим Окунеев. All rights reserved.
//

import UIKit

class AddStudentTVController: UITableViewController {
    
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var surnameTF: UITextField!
    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var disciplineLabel: UILabel!
    @IBOutlet weak var disciplinePicker: UIPickerView!
    @IBOutlet weak var noteTF: UITextField!
    @IBOutlet weak var birthdayLabel: UILabel!
    @IBOutlet weak var birthdayPicker: UIPickerView!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var lessons = ["-", "Французский","Английский"]
    var duration = ["45 минут", "60 минут", "90 минут"]
    let teacherId = "9"
    var student: Student!
    //    var student = Student(studentId: "", name: "BBB", surname: "", phone: "", email: "", price: "", note: "", birthday: "")
    private let birthday = "1992-11-22"
    private let networkManagerStudents =  NetworkManagerStudents()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        disciplinePicker.isHidden = true
        self.hideKeyboardWhenTappedAround()
        
        setupEditScreen()
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        dismiss(animated: true)
    }
    @IBAction func saveButtonAction(_ sender: Any) {
        addStudent()
    }
}

// MARK: Navigation
extension AddStudentTVController {
    
    //    func savePlace() {
    //
    //        let image = imageIsChanged ? placeImage.image : #imageLiteral(resourceName: "imagePlaceholder")
    //        let imageData = image?.pngData()
    //
    //        let newPlace = Place(name: placeName.text!,
    //                             location: placeLocation.text,
    //                             type: placeType.text,
    //                             imageData: imageData,
    //                             rating: Double(ratingControl.rating))
    //
    //        if currentPlace != nil {
    //            try! realm.write {
    //                currentPlace?.name = newPlace.name
    //                currentPlace?.location = newPlace.location
    //                currentPlace?.type = newPlace.type
    //                currentPlace?.imageData = newPlace.imageData
    //                currentPlace?.rating = newPlace.rating
    //            }
    //        } else {
    //            StorageManager.saveObject(newPlace)
    //        }
    //    }
    //
    private func setupEditScreen() {
        if student != nil {
            
            setupNavigationBar()
            
            nameTF.text = student.name
            surnameTF.text = student.surname ?? ""
            phoneTF.text = student.phone ?? ""
            emailTF.text = student.email ?? ""
            disciplineLabel.text = student.currentDiscipline ?? ""
            noteTF.text = student.note ?? ""
            
        }
    }
    
    private func setupNavigationBar() {
        if let topItem = navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        }
        navigationItem.leftBarButtonItem = nil
        title = "\(student.name ?? "") \(student.surname ?? "")"
//        saveButton.isEnabled = true
    }
}


//MARK: Network
extension AddStudentTVController {
    private func addStudent() {
        networkManagerStudents.addStudent(teacherId: teacherId,
                                          name: student.name  ?? "",
                                          surname: student.surname ?? "",
                                          phone: student.phone ?? "",
                                          email: student.email ?? "",
                                          currentDiscipline: student.currentDiscipline ?? "",
                                          note: student.note ?? "")
        { [weak self]  (responce, error)  in
            guard let responce = responce else {
                print(error ?? "")
                DispatchQueue.main.async {
                    self?.alertNetwork(message: error ?? "")
                }
                return
            }
            print(responce)
        }
    }
}


//MARK: TableViewDelegate, TableViewDataSource
extension AddStudentTVController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 5:
            return CGFloat(disciplinePicker.isHidden ? 0.0 : 120.0)
        default:
            return super.tableView(tableView, heightForRowAt: indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let lessonIndexPath = IndexPath(row: 6, section: 0)
        
        switch indexPath {
        case lessonIndexPath:
            disciplinePicker.isHidden = !disciplinePicker.isHidden
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
extension AddStudentTVController : UIPickerViewDelegate, UIPickerViewDataSource {
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
            return disciplineLabel.text = lessons[row]
        default:
            return
        }
        
    }
}
//MARK: Alert
extension AddStudentTVController  {
    func alertNetwork(message: String) {
        UIAlertController.alert(title:"Error", msg:"\(message)", target: self)
    }
}
