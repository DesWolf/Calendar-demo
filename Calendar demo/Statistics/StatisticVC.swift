//
//  StatisticsVC.swift
//  Calendar demo
//
//  Created by Максим Окунеев on 4/21/20.
//  Copyright © 2020 Максим Окунеев. All rights reserved.
//

import UIKit

class StatisticVC: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    let networkManagerStatistic = NetworkManagerStatistic()
    private var statistic: StatisticModel!
    private var datePicker = UIDatePicker()
    private let toolBar = UIToolbar()
    private var statisticType = ["Количество оплаченных занятий:",
                                 "Сумма оплаченных занятий:",
                                 "Количество неоплаченных занятий:",
                                 "Сумма неоплаченных занятий:",
                                 "Общее количество занятий:"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        configureScreen()
        tableView.reloadData()
    }
    @IBAction func calendarButtonTap(_ sender: Any) {
        setupPeriod()
    }
}

//MARK: Set Screen
extension StatisticVC {
    
    private func configureScreen() {
        UINavigationBar().set(controller: self)
        tableView.tableFooterView = UIView()
        
        let start = "\(Date())".prefix(10)
        let end = "\(Date().monthMinusOne(str: "\(start)"))".prefix(10)
        fetchCalendar(startDate: String(start), endDate: String(end))
        print(start, end)
    }
    
    private func setupPeriod() {
        let height = 200
        // DatePicker
        self.datePicker = UIDatePicker(frame:CGRect(x: 0, y: 0, width: Int(self.view.frame.size.width), height: height))
        self.datePicker.datePickerMode = UIDatePicker.Mode.date
        
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(self.datePicker)

        NSLayoutConstraint.activate([
        datePicker.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
        datePicker.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
        datePicker.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor,constant: -CGFloat(height)),
        datePicker.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
        ])

        // ToolBar
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
        toolBar.sizeToFit()

        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelClick))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: true)
        toolBar.isUserInteractionEnabled = true

        self.view.addSubview(toolBar)
        self.toolBar.isHidden = false
}

    @objc func doneClick() {
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateStyle = .medium
        dateFormatter1.timeStyle = .none
        //self.datePicker.resignFirstResponder()
        datePicker.isHidden = true
        self.toolBar.isHidden = true
    }

    @objc func cancelClick() {
        datePicker.isHidden = true
        self.toolBar.isHidden = true
    }
    
}

//MARK: TableViewDelegate, TableViewDataSourse
extension StatisticVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        statisticType.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "statisticCell", for: indexPath) as! StatisticCell
        let statistic = statisticType[indexPath.row]
        cell.configere(name: statistic, number: 0)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
    

}
//MARK: Network
extension StatisticVC {
    func fetchCalendar(startDate: String, endDate: String) {
        
//        let startDate = String("\(Date().monthMinusOne(str: date))".prefix(10))
//        let endDate = String("\(Date().monthPlusOne(str: date))".prefix(10))
        
        networkManagerStatistic.fetchStatistic(startDate: startDate, endDate: endDate)
        { [weak self]  (data, error)  in
            guard let data = data else {
                print(error ?? "")
                DispatchQueue.main.async {
                    self?.simpleAlert(message: error ?? "")
                }
                return
            }
    
            DispatchQueue.main.async {
                self?.statistic = data
                self?.tableView.reloadData()
            }
        }
    }
}

//MARK: Alert
extension StatisticVC {
    func simpleAlert(message: String) {
        UIAlertController.simpleAlert(title:"Ошибка", msg:"\(message)", target: self)
    }
}
