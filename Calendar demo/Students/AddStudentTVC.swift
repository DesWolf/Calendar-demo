//
//  AddUserTVC.swift
//  Calendar demo
//
//  Created by Максим Окунеев on 4/23/20.
//  Copyright © 2020 Максим Окунеев. All rights reserved.
//

import UIKit

class AddStudentTVC: UITableViewController {
    
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var surnameTF: UITextField!
    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var commentTF: UITextView!
    
    @IBOutlet weak var disciplinesCollectionView: UICollectionView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    

    var chousedDisciplines = ["Немецкий"]
    let teacherId = "9"
    var currentStudent: StudentModel?
    private let birthday = "1992-11-22"
    private let networkManagerStudents =  NetworkManagerStudents()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        setupEditScreen()
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func saveButtonAction(_ sender: Any) {
        saveStudent()
    }

}

// MARK: - Navigation
extension AddStudentTVC {
    @IBAction func unwiSegue(_ segue: UIStoryboardSegue) {
           guard let disciplinesTVC = segue.source as? DisciplinesTVC else { return }
           chousedDisciplines = disciplinesTVC.chousedDisciplines
           disciplinesCollectionView.reloadData()
           tableView.reloadData()
       }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "discilinesTVC" {
            let disciplinesTVC = segue.destination as! DisciplinesTVC
            disciplinesTVC.chousedDisciplines = chousedDisciplines
        }
    }
}


// MARK: Navigation
extension AddStudentTVC {
    
    func saveStudent() {
        let newStudent = StudentModel(studentId: "",
                                      name: nameTF.text!,
                                      surname: surnameTF.text,
                                      disciplines: chousedDisciplines,
                                      phone: phoneTF.text,
                                      email: emailTF.text,
                                      note: commentTF.text )
        
        if currentStudent != nil {
            // вызываем запрос на изменение пользователя
            print("вызываем запрос на изменение пользователя")
        } else {
            // запрос в сеть на сохранение нового пользователя
            //                addNewStudent(newStudent: newStudent)
        }
    }
    
    private func setupEditScreen() {
        if currentStudent != nil {
            
            setupNavigationBar()
            
            nameTF.text = currentStudent?.name
            surnameTF.text = currentStudent?.surname ?? ""
            phoneTF.text = currentStudent?.phone ?? ""
            emailTF.text = currentStudent?.email ?? ""
            commentTF.text = currentStudent?.note ?? ""
            
        }
        self.tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 1))
    }
    
    private func setupNavigationBar() {
        if let topItem = navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        }
        navigationItem.leftBarButtonItem = nil
        title = "\(currentStudent?.name ?? "") \(currentStudent?.surname ?? "")"
        //        saveButton.isEnabled = true
    }
}


//MARK: Network
extension AddStudentTVC {
    private func addNewStudent(newStudent: StudentModel) {
        networkManagerStudents.addStudent(teacherId: teacherId,
                                          studentId: "",
                                          name: newStudent.name!,
                                          surname: newStudent.surname ?? "",
                                          disciplines: newStudent.disciplines ?? [],
                                          phone: newStudent.phone ?? "",
                                          email: newStudent.email ?? "",
                                          note: newStudent.note ?? "")
        { [weak self]  (responce, error)  in
            guard let responce = responce else {
                print(error ?? "")
                DispatchQueue.main.async {
                    self?.simpleAlert(message: error ?? "")
                }
                return
            }
            print(responce)
        }
    }
}


//MARK: TableViewDelegate, TableViewDataSource
extension AddStudentTVC {
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 2:
            return UITableView.automaticDimension
        default:
            return super.tableView(tableView, heightForRowAt: indexPath)
        }
    }
}

extension AddStudentTVC: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        tableView.beginUpdates()
        tableView.endUpdates()
    }
}

//MARK: Alert
extension AddStudentTVC  {
    func simpleAlert(message: String) {
        UIAlertController.simpleAlert(title:"Error", msg:"\(message)", target: self)
    }
}

//MARK: UICollectionView, UICollectionViewDelegateFlowLayout
extension AddStudentTVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return chousedDisciplines.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DisciplinesCell", for: indexPath) as! DisciplinesCollectionViewCell
        let discipline = chousedDisciplines[indexPath.row]
        cell.configure(with: discipline)
        return cell
    }
}

