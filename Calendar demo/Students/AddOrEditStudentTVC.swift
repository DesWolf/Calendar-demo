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
    
    var chousedDisciplines: [String] = []
    var student: StudentModel?
    private let networkManagerStudents =  NetworkManagerStudents()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        configureScreen()
    }
    
    @IBAction func emailTFAction(_ sender: Any) {
        guard emailTF.text?.isValidEmail() == true  else {
            return simpleAlert(message: "Введите корректный email")
        }
        print("email - ok")
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
    
    private func configureScreen() {
        if student != nil {
            nameTF.text = student?.name
            surnameTF.text = student?.surname ?? ""
            phoneTF.text = student?.phone ?? ""
            emailTF.text = student?.email ?? ""
            noteTF.text = student?.note ?? ""
            student?.disciplines?.forEach { chousedDisciplines.append($0) }
        }
        
        setupNavigationBar()
        tableView.backgroundColor = .bgStudent
        
    }
    
    private func setupNavigationBar() {
        let nav = self.navigationController?.navigationBar
        
        if student == nil {
            nav?.topItem?.title = "Новый ученик"
        }
        navigationItem.leftBarButtonItem?.title = "Отмена"
        navigationItem.leftBarButtonItem?.tintColor = .white
        navigationItem.rightBarButtonItem?.tintColor = .white
        
        nav?.setBackgroundImage(UIImage(), for: .default)
        nav?.shadowImage = UIImage()
        nav?.isTranslucent = true
        nav?.prefersLargeTitles = true
        nav?.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        nav?.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
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
        student = StudentModel(studentId: student != nil ? student?.studentId : nil,
                               name: nameTF.text ?? "",
                               surname: surnameTF.text,
                               disciplines: chousedDisciplines,
                               phone: phoneTF.text,
                               email: emailTF.text,
                               note: noteTF.text )
        if student?.studentId != nil {
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
            print("Add:",responce)
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
            print("change:",responce)
        }
    }
}

//MARK: TableViewDelegate, TableViewDataSource
extension AddOrEditStudentTVC {
    override func tableView(_ tableView: UITableView,
                            heightForRowAt indexPath: IndexPath) -> CGFloat {
        
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
            return height
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


