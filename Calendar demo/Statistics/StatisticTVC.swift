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
    
    @IBOutlet weak var payTotalLabel: UILabel!
    @IBOutlet weak var notPayTotalLabel: UILabel!
    @IBOutlet weak var countLessonPayLabel: UILabel!
    @IBOutlet weak var countLessonNotPayLabel: UILabel!
    @IBOutlet weak var countLessonTotalLabel: UILabel!
    
    let networkManagerStatistic = NetworkManagerStatistic()
    private var statistic: StatisticModel?
    
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
        tableView.backgroundColor = .appGray
        
        let start = "\(Date())".prefix(10)
        let end = "\(Date().monthMinusOne(str: "\(start)"))".prefix(10)
        fetchCalendar(startDate: String(start), endDate: String(end))
        print(start, end)
        
    }
    
    
    private func setupNavigationBar() {
        
        let navBar = self.navigationController?.navigationBar
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        let gradientHeight = statusBarHeight + navBar!.frame.height
        
        UINavigationBar().set(controller: self)
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

    }
}

//MARK: Network
extension StatisticTVC {
    func fetchCalendar(startDate: String, endDate: String) {
        
//        let startDate = String("\(Date().monthMinusOne(str: date))".prefix(10))
//        let endDate = String("\(Date().monthPlusOne(str: date))".prefix(10))
        
        networkManagerStatistic.fetchStatistic(startDate: startDate, endDate: endDate)
        { [weak self]  (statistic, error)  in
            guard let statistic = statistic else {
                print(error ?? "")
                DispatchQueue.main.async {
                    self?.simpleAlert(message: error ?? "")
                }
                return
            }
            
            DispatchQueue.main.async {
                self?.payTotalLabel.text = "\(statistic.payTotal ?? 0)"
                self?.notPayTotalLabel.text = String(describing: statistic.notPayTotal)
                self?.countLessonPayLabel.text = String(describing: statistic.countLessonPay)
                self?.countLessonNotPayLabel.text = String(describing: statistic.countLessonNotPay)
                self?.countLessonTotalLabel.text = String(describing: statistic.countLessonTotal)
                self?.tableView.reloadData()
            }
            
            
        }
    }
}


//MARK: Alert
extension StatisticTVC {
    func simpleAlert(message: String) {
        UIAlertController.simpleAlert(title:"Ошибка", msg:"\(message)", target: self)
    }
}

