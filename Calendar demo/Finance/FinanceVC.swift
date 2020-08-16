//
//  SettingsVC.swift
//  Calendar demo
//
//  Created by Максим Окунеев on 4/21/20.
//  Copyright © 2020 Максим Окунеев. All rights reserved.
//

import UIKit


class FinanceTVC: UITableViewController {

    @IBOutlet weak var numberOfPaidLessonsLabel: UILabel!
    @IBOutlet weak var numberOfEarnedMoneyLabel: UILabel!
    @IBOutlet weak var averageLessonCostLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

//    private func setupSegmentedControl() {
//
//        let notSelected: [NSAttributedString.Key : Any]     = [NSAttributedString.Key.foregroundColor: UIColor.white]
//        let selected: [NSAttributedString.Key : Any]        = [NSAttributedString.Key.foregroundColor: UIColor.white,
//                                                               NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue,
//                                                               NSAttributedString.Key.underlineColor: UIColor.white]
//
//        segmentedControl.setTitleTextAttributes(notSelected, for: .normal)
//        segmentedControl.setTitleTextAttributes(selected, for: .selected)
//
//        segmentedControl.removeBorders()
////        segmentedControl.backgroundColor = .clear
////        segmentedControl.selectedSegmentTintColor = .clear
//
//    }
    
//    private func setSegmentedControl() {
//        if segmentedControl.selectedSegmentIndex == 0 {
//
//            nameTF.isHidden = true
//            placeTF.isHidden = true
//
//            studentLabel.isHidden = false
//            disciplineLabel.isHidden = false
//            priceTF.isHidden = false
//        } else {
//            nameTF.isHidden = false
//            placeTF.isHidden = false
//
//            studentLabel.isHidden = true
//            disciplineLabel.isHidden = true
//            priceTF.isHidden = true
//        }
//
//        tableView.reloadData()
//    }
