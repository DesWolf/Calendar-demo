//
//  AddUserTVC.swift
//  Calendar demo
//
//  Created by Максим Окунеев on 4/23/20.
//  Copyright © 2020 Максим Окунеев. All rights reserved.
//

import UIKit

class AddOrEditStudentTVC: UITableViewController {
    
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var surnameTF: UITextField!
    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var commentTF: UITextView!
    
    @IBOutlet weak var disciplinesCollectionView: UICollectionView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    
    var chousedDisciplines: [String] = []
//    let teacherId = "9"
    var student: StudentModel?

//    private let birthday = "1992-11-22"
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

    deinit {
        print("deinit", AddOrEditStudentTVC.self)
    }
}

// MARK: - Navigation
extension AddOrEditStudentTVC {
    @IBAction func unwiSegue(_ segue: UIStoryboardSegue) {
        guard let disciplinesTVC = segue.source as? DisciplinesTVC else { return }
        chousedDisciplines = disciplinesTVC.chousedDisciplines
        disciplinesCollectionView.reloadData()
        tableView.reloadData()
    }
    
    //    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //        switch segue.identifier {
    //        case "discilinesTVC":
    //            if let disciplinesTVC = segue.destination as? DisciplinesTVC {
    //                disciplinesTVC.chousedDisciplines = chousedDisciplines
    //            }
    //        case "backToStudentProfile":
    //            if let navVC = segue.destination as? UINavigationController,
    //                let studentProfileVC = navVC.topViewController as? StudentProfileVC {
    //                studentProfileVC.student = student
    //            }
    //        case .none:
    //            return
    //        case .some(_):
    //            return
    //        }
    //    }
}


// MARK: Navigation
extension AddOrEditStudentTVC {
    
    func saveStudent() {
        student = StudentModel(studentId: student != nil ? student?.studentId : 0,
                                          name: nameTF.text!,
                                          surname: surnameTF.text,
                                          disciplines: chousedDisciplines,
                                          phone: phoneTF.text,
                                          email: emailTF.text,
                                          note: commentTF.text )
        if student != nil {
            changeStudent(student: student!)
        } else {
            addNewStudent(newStudent: student!)
        }
    }
    
    private func setupEditScreen() {
        if student != nil {
            setupNavigationBar()
            
            nameTF.text = student?.name
            surnameTF.text = student?.surname ?? ""
            phoneTF.text = student?.phone ?? ""
            emailTF.text = student?.email ?? ""
            commentTF.text = student?.note ?? ""
            student?.disciplines?.forEach { chousedDisciplines.append($0) }
        }
        self.tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 1))
    }
    
    private func setupNavigationBar() {
        if let topItem = navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        }
        navigationItem.leftBarButtonItem = nil
        title = "\(student?.name ?? "") \(student?.surname ?? "")"
    }
}


//MARK: Network
extension AddOrEditStudentTVC {
    private func addNewStudent(newStudent: StudentModel) {
        networkManagerStudents.addStudent(studentId: newStudent.studentId ?? 0,
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
    
    private func changeStudent(student: StudentModel) {
        networkManagerStudents.changeStudent(studentId: student.studentId ?? 0,
                                             name: student.name!,
                                             surname: student.surname ?? "",
                                             disciplines: student.disciplines ?? [],
                                             phone: student.phone ?? "",
                                             email: student.email ?? "",
                                             note: student.note ?? "")
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
extension AddOrEditStudentTVC {
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 2:
            return UITableView.automaticDimension
        default:
            return super.tableView(tableView, heightForRowAt: indexPath)
        }
    }
}

extension AddOrEditStudentTVC: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        tableView.beginUpdates()
        tableView.endUpdates()
    }
}

//MARK: Alert
extension AddOrEditStudentTVC  {
    func simpleAlert(message: String) {
        UIAlertController.simpleAlert(title:"Error", msg:"\(message)", target: self)
    }
}

//MARK: UICollectionView, UICollectionViewDelegateFlowLayout
extension AddOrEditStudentTVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
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

