//
//  LessonDetailedTVC.swift
//  Calendar demo
//
//  Created by Максим Окунеев on 6/13/20.
//  Copyright © 2020 Максим Окунеев. All rights reserved.
//

import UIKit

class LessonDetailedTVC: UITableViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var disciplineLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var studentLabel: UILabel!
    @IBOutlet weak var noteTV: UITextView!
    @IBOutlet weak var repeatLabel: UILabel!
    @IBOutlet weak var notificationLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var paymentLabel: UILabel!
    
    var lesson: CalendarModel?
    private var paymentDate: String?
    private let networkManagerCalendar =  NetworkManagerCalendar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationController()
        fetchDetailedLesson(lessonId: lesson?.lessonId ?? 0)
    }
    
    deinit {
        print("deinit", LessonDetailedTVC.self)
    }
}

//MARK: Setup Screen
extension LessonDetailedTVC {
    func setupScreen(lesson: CalendarModel?) {
        nameLabel.text = lesson?.lessonName ?? ""
        placeLabel.text = lesson?.place ?? ""
        disciplineLabel.text = lesson?.discipline ?? ""
        timeLabel.text = "\(lesson?.timeStart ?? "") - \(lesson?.timeEnd ?? "")"
        dateLabel.text = "\(lesson?.dateStart ?? "") - \(lesson?.dateEnd ?? "")"
        studentLabel.text = "\(lesson?.studentName ?? "") - \(lesson?.studentSurname ?? "")"
        noteTV.text = lesson?.note ?? ""
        repeatLabel.text = lesson?.repeatLesson ?? ""
//        notificationLabel.text = lesson?.notificationType ?? ""
        priceLabel.text = "\(lesson?.price ?? 0)"
        paymentLabel.text = "\(lesson?.statusPay ?? 0)"
    }
    
    private func setNavigationController() {
        let navBar = self.navigationController?.navigationBar
        
        navBar?.setBackgroundImage(UIImage(), for: .default)
        navBar?.shadowImage = UIImage()
        navBar?.isTranslucent = true
        
        navigationItem.leftBarButtonItem?.title = "Назад"
        navigationItem.leftBarButtonItem?.tintColor = .white
        navigationItem.rightBarButtonItem?.tintColor = .white
        
        tableView.backgroundColor = .bgStudent
        
    }
}

//MARK: UITextViewDelegate
extension LessonDetailedTVC: UITextViewDelegate{
    func textView(_ textView: UITextView, shouldInteractWith URL: URL,
                  in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        UIApplication.shared.open(URL)
        return false
    }
}



//MARK: TableViewDelegate
extension LessonDetailedTVC {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 3:
            return UITableView.automaticDimension
        default:
            return super.tableView(tableView, heightForRowAt: indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = indexPath == [2,0] ? .bgStudent : .white
    }
}

// MARK: Navigation
extension LessonDetailedTVC {
    @IBAction func unwiSegueCurrentLesson(_ segue: UIStoryboardSegue) {

        if let desTVC = segue.source as? PaymentTVC {
        let textCollor: UIColor = desTVC.payment == "Не оплаченно" ? .systemRed : .systemGreen
        self.paymentLabel.textColor = textCollor
        self.paymentLabel.text = desTVC.payment
        self.paymentDate = desTVC.dateOfPaymentLabel.text
        }
        
        if let desTVC = segue.source as? AddOrEditLessonTVC {
            desTVC.saveLesson()
        }
        self.tableView.reloadData()
            
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "editLesson":
            guard let destVC = segue.destination as? UINavigationController,
                let targetController = destVC.topViewController as? AddOrEditLessonTVC else { return }
            targetController.lesson = lesson
            
        case "payment":
            guard let destVC = segue.destination as? PaymentTVC else { return }
            destVC.payment = paymentLabel.text ?? "Не оплаченно"
            destVC.paymentDate = paymentDate
        case .none:
            return
        case .some(_):
            return
        }
    }
}

//MARK: Network
extension LessonDetailedTVC {
    func fetchDetailedLesson(lessonId: Int) {
        networkManagerCalendar.fetchLesson(lessonId: lessonId) { [weak self]  (lesson, error) in
            guard let lesson = lesson else {
                print(error ?? "")
                DispatchQueue.main.async {
                    self?.simpleAlert(message: error ?? "")
                }
                return
            }
            DispatchQueue.main.async {
                self?.lesson = lesson
                self?.setupScreen(lesson: lesson)
                self?.tableView.reloadData()
            }
        }
    }
}

//MARK: Alert
extension LessonDetailedTVC  {
    func simpleAlert(message: String) {
        UIAlertController.simpleAlert(title:"Ошибка", msg:"\(message)", target: self)
    }
}
