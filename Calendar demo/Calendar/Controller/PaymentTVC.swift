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
    
    var payment: Int?
    var paymentDate: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureScreen()
    }
    
    @IBAction func paimentChanged(sender: UIDatePicker) {
        paymentDate                 = Date().str(str: "\(paymentPicker.date)", to: .date)
        dateOfPaymentLabel.text     = paymentDate
    }
}

//MARK: Set Screen
extension PaymentTVC {
    private func configureScreen() {
        setupPicker()
        tableView.tableFooterView = UIView()
        
        if payment == 0 {
            notPaidCheckImage.image =  #imageLiteral(resourceName: "check")
            payment = 0
        }  else {
            paidCheckImage.image = #imageLiteral(resourceName: "check")
            payment = 1
            dateOfPaymentLabel.text = paymentDate ?? ""
        }
    }
    
    private func setupPicker() {
        
        if payment == 0 {
            dateOfPaymentLabel.text         = Date().str(str: "\(paymentPicker.date)", to: .date)
            dateOfPaymentLabel.isHidden     = true
            
            paymentPicker.datePickerMode    = .date
            paymentPicker.isHidden          = true
            paymentPicker.setDate(Date(), animated: true)
        } else {
            dateOfPaymentLabel.text         = paymentDate
            paymentPicker.datePickerMode    = .date
            
            dateOfPaymentLabel.isHidden     = false
            paymentPicker.isHidden          = false
            paymentPicker.setDate(Date().strToDate(str: paymentDate), animated: true)
        }
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
            payment = 0
            notPaidCheckImage.image =  #imageLiteral(resourceName: "check")
            paidCheckImage.image = UIImage()
            if !dateOfPaymentLabel.isHidden {
                dateOfPaymentLabel.isHidden = true
                paymentPicker.isHidden = true
                pickerAnimation(indexPath: indexPath)
                
            }
        case 1:
            payment = 1
            notPaidCheckImage.image =  UIImage()
            paidCheckImage.image = #imageLiteral(resourceName: "check")
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
