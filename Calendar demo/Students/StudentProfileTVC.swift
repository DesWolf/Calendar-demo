//
//  StudentProfileVC.swift
//  Calendar demo
//
//  Created by Максим Окунеев on 5/26/20.
//  Copyright © 2020 Максим Окунеев. All rights reserved.
//

import UIKit

class StudentProfileTVC: UITableViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var phoneTV: UITextView!
    @IBOutlet weak var emailTV: UITextView!
    @IBOutlet weak var disciplinesCollectionView: UICollectionView!
    @IBOutlet weak var noteTV: UITextView!
    
    private let networkManagerStudents =  NetworkManagerStudents()
    
    public var student: StudentModel?
    public var onEditButtonTap: ((StudentModel) -> (Void))?
    public var onBackButtonTap: (() -> (Void))?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationController()
        setupScreen(student: student)
    }
    
    @IBAction private func tapOnBackButton(_ sender: Any) {
        self.onBackButtonTap?()
    }
    
    @IBAction private func tapOnEditButton(_ sender: Any) {
        if student == nil {
            simpleAlert(message: "Нет интернет соединения, попробуйте позже")
        } else {
            self.onEditButtonTap?(student!)
        }
    }
}

//MARK: Setup Screen
extension StudentProfileTVC {
    func setupScreen(student: StudentModel?) {
        
        nameLabel.text = "\(student?.name ?? "") \(student?.surname ?? "")"
        commentLabel.text = "Ученик"
        phoneTV.text = student?.phone ?? ""
        emailTV.text = student?.email ?? ""
        noteTV.text = student?.note ?? ""
        
        phoneTV.isScrollEnabled = false
        emailTV.isScrollEnabled = false
        
        
    }
    
    private func setNavigationController() {
        let navBar = self.navigationController?.navigationBar
        let statusBarHeight = view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        let firstCellHeight = tableView.cellForRow(at: IndexPath(row: 0, section: 0))?.frame.height
        let gradientHeight = statusBarHeight + navBar!.frame.height + (firstCellHeight ?? 145)

        UINavigationBar().setClearNavBar(controller: self)
        navBar?.prefersLargeTitles = false
        navigationItem.leftBarButtonItem?.tintColor = .white
        UIColor.setGradientToTableView(tableView: tableView, height: Double(gradientHeight))
    }
}


//MARK: UITextViewDelegate
extension StudentProfileTVC: UITextViewDelegate{
    func textView(_ textView: UITextView, shouldInteractWith URL: URL,
                  in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        UIApplication.shared.open(URL)
        return false
    }
}

//MARK: UICollectionView, UICollectionViewDelegateFlowLayout
extension StudentProfileTVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  student?.disciplines?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DisciplinesCell", for: indexPath) as! DisciplinesCollectionViewCell
        guard let discipline = student?.disciplines?[indexPath.row] else { return cell }
        cell.configure(with: discipline)
        return cell
    }
}

//MARK: TableViewDelegate
extension StudentProfileTVC {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let firstCellHeight: CGFloat = 145
        let secondCellHeight: CGFloat = 95
        let thirdCellHeight: CGFloat = 65
        let fourthCellHeight: CGFloat = 65
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
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = indexPath.row == 0 ? UIColor.clear : .white
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

//MARK: Network
extension StudentProfileTVC {
    func fetchDetailedStudent(studentId: Int) {
        networkManagerStudents.fetchStudent(studentId: studentId) { [weak self]  (student, error) in
            guard let student = student else {
                print(error ?? "")
                DispatchQueue.main.async {
                    self?.simpleAlert(message: error ?? "")
                }
                return
            }
            self?.student = student
        }
    }
}

//MARK: Alert
extension StudentProfileTVC  {
    func simpleAlert(message: String) {
        UIAlertController.simpleAlert(title:"Ошибка", msg:"\(message)", target: self)
    }
}
