//
//  StatisticsVC.swift
//  Calendar demo
//
//  Created by Максим Окунеев on 4/21/20.
//  Copyright © 2020 Максим Окунеев. All rights reserved.
//

import UIKit
import CVCalendar

class StatisticTVC: UITableViewController {

    
    
    
    @IBOutlet weak var numberOfStudentsLabel: UILabel!
    @IBOutlet weak var numberOfPlannedLessonsLabel: UILabel!
    @IBOutlet weak var numberOfFinishedLessonsLabel: UILabel!
    @IBOutlet weak var numberOfCancelLessonsLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        configureScreen()
        tableView.reloadData()
    }
}


//MARK: Set Screen
extension StatisticTVC {
    
    func configureScreen() {
        
        setupNavigationBar()
        
    }
    
    
    private func setupNavigationBar() {
        
        let navBar = self.navigationController?.navigationBar
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        let gradientHeight = statusBarHeight + navBar!.frame.height
        
        UINavigationBar().setClearNavBar(controller: self)
        UIColor.setGradientToTableView(tableView: tableView, height: Double(gradientHeight))
        
        setNavButton()
    }
    
    
    func setNavButton() {
        let button =  UIButton(type: .custom)
        button.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        
        button.setTitle("Апрель, 2020", for: .normal)
        button.addTarget(self, action: #selector(clickOnNavButton), for: .touchUpInside)
        navigationItem.titleView = button
    }
    
    
    @objc func clickOnNavButton() {
        
        
        let storyboard = UIStoryboard(name: "Statistic", bundle: nil)
        let myAlert = storyboard.instantiateViewController(withIdentifier: "AlertCalendarVC")
        myAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        myAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        self.present(myAlert, animated: true, completion: nil)
        
        
        
        
        
        
        
        
        
//        let vc = UIViewController()
//        vc.preferredContentSize = CGSize(width: 200,height: 250)
        
//        let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: 250, height: 300))
//        datePicker.datePickerMode = .date
//        datePicker.locale = Locale.current

//        vc.view.addSubview(datePicker)
//        let editRadiusAlert = UIAlertController(title: "Выбирите период", message: "", preferredStyle: UIAlertController.Style.alert)
//        editRadiusAlert.setValue(vc, forKey: "contentViewController")
//        editRadiusAlert.addAction(UIAlertAction(title: "Done", style: .default, handler: nil))
//        editRadiusAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
//        self.present(editRadiusAlert, animated: true)
    
    }
}
