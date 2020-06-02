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
    @IBOutlet weak var noteTF: UITextView!
    
    @IBOutlet weak var disciplinesCollectionView: UICollectionView!
//    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    
    var chousedDisciplines: [String] = []
    
    var student: StudentModel?
    
    private let networkManagerStudents =  NetworkManagerStudents()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        setupEditScreen()
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        dismiss(animated: true)
    }
    
    deinit {
        print("deinit", AddOrEditStudentTVC.self)
    }
}

//MARK: Setup Screen
extension AddOrEditStudentTVC {
    private func setupEditScreen() {
        if student != nil {
            setupNavigationBar()
            nameTF.text = student?.name
            surnameTF.text = student?.surname ?? ""
            phoneTF.text = student?.phone ?? ""
            emailTF.text = student?.email ?? ""
            noteTF.text = student?.note ?? ""
            student?.disciplines?.forEach { chousedDisciplines.append($0) }
        }
        self.tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 1))
    }
    
    private func setupNavigationBar() {
        if let topItem = navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        }
        navigationItem.leftBarButtonItem?.title = "Отмена"
        title = "\(student?.name ?? "") \(student?.surname ?? "")"
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "discilinesTVC" {
            
            guard let disciplinesTVC = segue.destination as? DisciplinesTVC else { return }
            disciplinesTVC.chousedDisciplines = chousedDisciplines
        }
    }
    
    func saveStudent() {
        student = StudentModel(studentId: student != nil ? student?.studentId : 0,
                               name: nameTF.text!,
                               surname: surnameTF.text,
                               disciplines: chousedDisciplines,
                               phone: phoneTF.text,
                               email: emailTF.text,
                               note: noteTF.text )
        if student != nil {
            changeStudent(student: student!)
        } else {
            addNewStudent(newStudent: student!)
            
            
        }
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

            let firstCellHeight: CGFloat = 78
            let secondCellHeight: CGFloat = 40
            let thirdCellHeight: CGFloat = 230
            let fourthCellHeight: CGFloat = 80
        let tabBarHeight: CGFloat = self.tabBarController?.tabBar.frame.height ?? 100
            
            switch indexPath.row {
            case 0:
            return firstCellHeight
            case 1:
            return secondCellHeight
            case 2:
            return thirdCellHeight
            case 3:
            return fourthCellHeight
            case 4:
                let height = self.view.frame.height - firstCellHeight - secondCellHeight - thirdCellHeight - fourthCellHeight - tabBarHeight
            return  height //UITableView.automaticDimension
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

