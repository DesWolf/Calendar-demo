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
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var disciplines = ["-", "Французский","Английский"]
    let teacherId = "9"
    var currentStudent: StudentModel!
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
        saveStudent()
    }
}

// MARK: Navigation
extension AddStudentTVController {
    
        func saveStudent() {
            let newStudent = AddStudentModel(
                                name: nameTF.text!,
                                surname: surnameTF.text,
                                phone: phoneTF.text,
                                email: emailTF.text,
                                currentDiscipline: disciplineLabel.text,
                                note: noteTF.text )
    
            if currentStudent != nil {
                // вызываем запрос на изменение пользователя
                print("вызываем запрос на изменение пользователя")
                } else {
                // запрос в сеть на сохранение нового пользователя
                addNewStudent(newStudent: newStudent)
            }
    }
    
    private func setupEditScreen() {
        if currentStudent != nil {
            
            setupNavigationBar()
            
            nameTF.text = currentStudent.name
            surnameTF.text = currentStudent.surname ?? ""
            phoneTF.text = currentStudent.phone ?? ""
            emailTF.text = currentStudent.email ?? ""
            disciplineLabel.text = currentStudent.currentDiscipline ?? ""
            noteTF.text = currentStudent.note ?? ""
            
        }
    }
    
    private func setupNavigationBar() {
        if let topItem = navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        }
        navigationItem.leftBarButtonItem = nil
        title = "\(currentStudent.name ?? "") \(currentStudent.surname ?? "")"
        saveButton.isEnabled = true
    }
}


//MARK: Network
extension AddStudentTVController {
    private func addNewStudent(newStudent: AddStudentModel) {
        networkManagerStudents.addStudent(teacherId: teacherId,
                                          name: newStudent.name!,
                                          surname: newStudent.surname ?? "",
                                          phone: newStudent.phone ?? "",
                                          email: newStudent.email ?? "",
                                          currentDiscipline: newStudent.currentDiscipline ?? "",
                                          note: newStudent.note ?? "")
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
        let disciplinesIndexPath = IndexPath(row: 4, section: 0)
        
        switch indexPath {
        case disciplinesIndexPath:
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
        case 1:
            return disciplines.count
        default:
            return 0
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case 1:
            return disciplines[row]
        default:
            return ""
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag {
        case 1:
            return disciplineLabel.text = disciplines[row]
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