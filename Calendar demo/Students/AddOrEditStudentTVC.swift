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
    
    public var chousedDisciplines: [String]?
    public var student: StudentModel?
    private let networkManagerStudents =  NetworkManagerStudents()
    
    public var onBackButtonTap: (() -> (Void))?
    public var onSaveButtonTap: ((Int, StudentModel) -> (Void))?
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.hideKeyboardWhenTappedAround()
        configureScreen()
        
        chousedDisciplines = student?.disciplines
    }
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        configureScreen()
        tableView.reloadData()
    }
    
    @IBAction func emailTFAction(_ sender: Any) {
        guard emailTF.text?.isValidEmail() == true  else {
            return simpleAlert(message: "Введите корректный email")
        }
        print("email - ok")
    }
    
    @IBAction func tapOnBackButton(_ sender: Any) {
        onBackButtonTap?()
    }
    
    @IBAction private func tapSaveButton() {
        guard nameTF.text != "", nameTF.text != " "  else {
            DispatchQueue.main.async {
                self.simpleAlert(message: "Пожалуйста, заполните необходимые поля")
            }
            return
        }
        saveStudent()
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
        }
        
        setupNavigationBar()
        hideKeyboardWhenTappedAround()
    }
    
    private func setupNavigationBar() {

        let navBar = self.navigationController?.navigationBar
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        let gradientHeight = statusBarHeight + navBar!.frame.height
  
        navigationItem.title = student == nil ? "Новый ученик" : "Редактирование"
        navigationItem.leftBarButtonItem?.title = "Отмена"
        navigationItem.leftBarButtonItem?.tintColor = .white
        navigationItem.rightBarButtonItem?.tintColor = .white
       
        UINavigationBar().setClearNavBar(controller: self)
        UIColor.setGradientToTableView(tableView: tableView, height: Double(gradientHeight))
    }
}

//MARK: Navigation
extension AddOrEditStudentTVC {
    @IBAction func unwiSegueEditStudent(_ segue: UIStoryboardSegue) {
        if let desTVC = segue.source as? DisciplinesTVC {
            chousedDisciplines = desTVC.chousedDisciplines
            disciplinesCollectionView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "disciplines" {
            guard let nav = segue.destination as? UINavigationController, let desTVC = nav.topViewController as? DisciplinesTVC else { return }
            desTVC.chousedDisciplines = chousedDisciplines ?? []
        }
    }
}

//MARK: Network
extension AddOrEditStudentTVC {
    
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
            guard let studentId = responce.studentId else { return }
            self?.onSaveButtonTap?(studentId, newStudent)
            print("Add:",responce.studentId ?? "")
        }
    }
    
    private func changeStudent(student: StudentModel) {
        networkManagerStudents.changeStudent(studentId: student.studentId ?? 0,
                                             name: student.name!,
                                             surname: student.surname ?? "",
                                             disciplines: student.disciplines ?? [""],
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
            self?.onSaveButtonTap?(student.studentId ?? 0, student)
            print("change:",responce.message ?? "")
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
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView {
      let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 25))
        headerView.backgroundColor = .clear
    
      return headerView
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 25))
           footerView.backgroundColor = .clear
         return footerView
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
        return chousedDisciplines?.count ?? 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DisciplinesCell", for: indexPath) as! DisciplinesCollectionViewCell
        let discipline = chousedDisciplines?[indexPath.row] ?? ""
        cell.configure(with: discipline)
        return cell
    }
}


