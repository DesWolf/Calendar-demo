//
//  StudentProfileDetaledVC.swift
//  Calendar demo
//
//  Created by Максим Окунеев on 5/27/20.
//  Copyright © 2020 Максим Окунеев. All rights reserved.
//

import UIKit

class StudentProfileDetaledTVC: UITableViewController {
    
    
    @IBOutlet weak var number: UITextView!
    @IBOutlet weak var email: UITextView!
    @IBOutlet weak var comment: UITextView!
    @IBOutlet weak var disciplinesCollectionView: UICollectionView!
    
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    
    var disciplines = ["Французский", "Java", "Английский", "Rkbyujycrbq"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        comment.text = "dfsdgsdgsdgagdgsdgagasd"

        self.tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 1))
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
        return disciplines.count
    }

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DisciplinesCell", for: indexPath) as! DisciplinesCollectionViewCell
        let discipline = disciplines[indexPath.row]
        cell.configere(with: discipline)
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
    
    
//    func tableView(tableView: UITableView,
//                            willDisplayCell cell: UITableViewCell,
//                            forRowAtIndexPath indexPath: NSIndexPath)
//    {
//        if indexPath.row == 2 {
//            // Hiding separator line for only one specific UITableViewCell
//            cell.separatorInset = UIEdgeInsets(top: 0, left: cell.bounds.size.width, bottom: 0, right: 0)
//        }
//    }
    
    
//   func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath)
//   {
//       // Row 2 at Section 2
//       if indexPath.row == 3 && indexPath.section == 1 {
//           // Hiding separator line for one specific UITableViewCell
//        cell.separatorInset = UIEdgeInsets(top: 0, left: cell.bounds.size.width, bottom: 0, right: 0)
//
//           // Here we add a line at the bottom of the cell (e.g. here at the second row of the second section).
//           let additionalSeparatorThickness = CGFloat(1)
//           let additionalSeparator = UIView(frame: CGRect(x: 0,
//                                                          y: cell.frame.size.height - additionalSeparatorThickness,
//                                                          width: cell.frame.size.width,
//                                                          height: additionalSeparatorThickness))
//            
//        additionalSeparator.backgroundColor = UIColor.red
//           cell.addSubview(additionalSeparator)
//       }
//   }
}



