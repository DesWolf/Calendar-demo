//
//  StudentProfileDetaledVC.swift
//  Calendar demo
//
//  Created by Максим Окунеев on 5/27/20.
//  Copyright © 2020 Максим Окунеев. All rights reserved.
//

import UIKit

class StudentProfileDetaledTVC: UITableViewController {
    
    @IBOutlet weak var phoneTV: UITextView!
    @IBOutlet weak var emailTV: UITextView!
    @IBOutlet weak var noteTV: UITextView!
    @IBOutlet weak var disciplinesCollectionView: UICollectionView!
    
    var student: StudentModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    func configure() {
        phoneTV.text = student?.phone ?? ""
        emailTV.text = student?.email ?? ""
        noteTV.text = student?.note ?? ""
        self.tableView.tableFooterView = UIView(frame: CGRect(x: 0,
                                                              y: 0,
                                                              width: tableView.frame.size.width,
                                                              height: 1))
        phoneTV.isScrollEnabled = false
        emailTV.isScrollEnabled = false
    }
}


//MARK: UITextViewDelegate
extension StudentProfileDetaledTVC: UITextViewDelegate{
    func textView(_ textView: UITextView, shouldInteractWith URL: URL,
                  in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        UIApplication.shared.open(URL)
        return false
    }
}

//MARK: UICollectionView, UICollectionViewDelegateFlowLayout
extension StudentProfileDetaledTVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return student?.disciplines?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DisciplinesCell", for: indexPath) as! DisciplinesCollectionViewCell
        guard let discipline = student?.disciplines?[indexPath.row] else { return cell }
        cell.configure(with: discipline)
        return cell
    }
}

//MARK: TableViewDelegate
extension StudentProfileDetaledTVC {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 3:
            return UITableView.automaticDimension
        default:
            return super.tableView(tableView, heightForRowAt: indexPath)
        }
    }
}





