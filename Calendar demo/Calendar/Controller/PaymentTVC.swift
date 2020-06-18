//
//  PaymentTVC.swift
//  Calendar demo
//
//  Created by Максим Окунеев on 6/13/20.
//  Copyright © 2020 Максим Окунеев. All rights reserved.
//

import UIKit

class PaymentTVC: UITableViewController {
    
    @IBOutlet weak var paidCheckImage: UIImageView!
    @IBOutlet weak var dateOfPaymentLabel: UILabel!
    @IBOutlet weak var paymentPicker: UIDatePicker!
    @IBOutlet weak var notPaidCheckImage: UIImageView!
    
    var payment = ""
    var paymentDate: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureScreen()
        print(payment)
    }
    
    @IBAction func paimentChanged(sender: UIDatePicker) {
        dateOfPaymentLabel.text = displayedDate(str: "\(paymentPicker.date)")
        paymentDate = displayedDate(str: "\(paymentPicker.date)")
    }
}

//MARK: Set Screen
extension PaymentTVC {
    private func configureScreen() {
        setupNavigationBar()
        setupPicker()
        
        if payment == "Не оплаченно" {
            notPaidCheckImage.image =  #imageLiteral(resourceName: "checkmark")
            payment = "Не оплаченно"
        }  else {
            paidCheckImage.image = #imageLiteral(resourceName: "checkmark")
            payment = "Оплаченно"
            dateOfPaymentLabel.text = paymentDate ?? ""
        }
    }
    
    private func setupNavigationBar(){
        let nav = self.navigationController?.navigationBar
        nav?.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.black]
    }
    
    private func setupPicker() {
        
        if payment == "Не оплаченно" {
            dateOfPaymentLabel.text = displayedDate(str: "\(paymentPicker.date)")
            dateOfPaymentLabel.isHidden = true
            
            paymentPicker.datePickerMode = .date
            paymentPicker.setDate(Date(), animated: true)
            paymentPicker.isHidden = true
        } else {
            dateOfPaymentLabel.text = paymentDate
            dateOfPaymentLabel.isHidden = false
            
            paymentPicker.datePickerMode = .date
            paymentPicker.setDate(Date().convertStrToDate(str: paymentDate ?? "01.01.2021"), animated: true)
            paymentPicker.isHidden = false
        }
        
    }
    
    private func displayedDate(str: String) -> String {
        return Date().convertStrDate(date: str, formatFrom: "yyyy-MM-dd HH:mm:ssZ", formatTo: "dd.MM.yyyy")
        
    }
}

//MARK: TableViewDelegate, TableViewDataSource
extension PaymentTVC {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.row{
        case 2:
            return CGFloat(dateOfPaymentLabel.isHidden ? 0.0 : 44.0)
        case 3:
            return CGFloat(paymentPicker.isHidden ? 0.0 : 216.0)
        default:
            return super.tableView(tableView, heightForRowAt: indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            payment = "Не оплаченно"
            notPaidCheckImage.image =  #imageLiteral(resourceName: "checkmark")
            paidCheckImage.image = #imageLiteral(resourceName: "oval")
            if !dateOfPaymentLabel.isHidden {
                dateOfPaymentLabel.isHidden = true
                paymentPicker.isHidden = true
                pickerAnimation(indexPath: indexPath)
                
            }
        case 1:
            payment = "Оплаченно"
            notPaidCheckImage.image =  #imageLiteral(resourceName: "oval")
            paidCheckImage.image = #imageLiteral(resourceName: "checkmark")
            if dateOfPaymentLabel.isHidden {
                dateOfPaymentLabel.isHidden = false
                paymentPicker.isHidden = false
                pickerAnimation(indexPath: indexPath)
            }
        default:
            return
        }
    }
    
    func pickerAnimation(indexPath: IndexPath) {
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.tableView.beginUpdates()
            self.tableView.deselectRow(at: indexPath as IndexPath, animated: true)
            self.tableView.endUpdates()
        })
    }
}

