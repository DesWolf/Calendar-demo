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
    
    @IBOutlet weak var nameBackView: UIView!
    @IBOutlet weak var studentBackView: UIView!
    @IBOutlet weak var lessonBackView: UIView!
    @IBOutlet weak var repeatbackView: UIView!
    @IBOutlet weak var notificationBackView: UIView!
    @IBOutlet weak var priceBackView: UIView!
    @IBOutlet weak var statusPaymentBackView: UIView!
    @IBOutlet weak var commentBackView: UIView!
    
    var lesson: LessonModel?
    
    private let networkManagerCalendar = NetworkManagerCalendar()
    
    public var onEditButtonTap: ((LessonModel) -> (Void))?
    public var onBackButtonTap: (() -> (Void))?
    
    struct Constant {
        static let nameAndPlace         = IndexPath(row: 0, section: 0)
        static let studentDiscipline    = IndexPath(row: 1, section: 0)
        static let repeatNotification   = IndexPath(row: 2, section: 0)
        static let price                = IndexPath(row: 3, section: 0)
        static let comment              = IndexPath(row: 4, section: 0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationController()
        setupScreen(lesson: lesson)
        setCellBackView()
        
//        print(String(describing: lesson))
    }
    
    @IBAction private func tapOnBackButton(_ sender: Any) {
        self.onBackButtonTap?()
    }
    
    @IBAction private func tapOnEditButton(_ sender: Any) {
        if lesson == nil {
            simpleAlert(message: "Нет интернет соединения, попробуйте позже")
        } else {
            self.onEditButtonTap?(lesson!)
        }
    }
}

//MARK: Setup Screen
extension LessonDetailedTVC {
    func setupScreen(lesson: LessonModel?) {
        
        let name                = lesson?.lessonName == "" ? "Без названия" : lesson?.lessonName
        let startTime           = Date().str(str: lesson?.startDate, to: .time)
        let endTime             = Date().str(str: lesson?.endDate, to: .time)
        let date                = Date().str(str: lesson?.startDate, to: .fullDateTime)
        let endDate             = Date().str(str: lesson?.endDate, to: .date)
        
        nameLabel.text          = name ?? "Без названия"
        placeLabel.text         = lesson?.place ?? ""
        disciplineLabel.text    = lesson?.discipline ?? ""
        timeLabel.text          = "с \(startTime) до \(endTime)"
        dateLabel.text          = date
        studentLabel.text       = "\(lesson?.studentName ?? "") \(lesson?.studentSurname ?? "")"
        noteTV.text             = lesson?.note ?? ""
        repeatLabel.text        = lesson?.repeatedly == "weekly" ? "до \(endDate)" : "Нет"
        priceLabel.text         = "\(lesson?.price ?? 0) руб."
        paymentLabel.text       = lesson?.payStatus == 0 ? "Не оплаченно" : "Оплаченно"
        paymentLabel.textColor  = lesson?.payStatus == 0 ? .systemRed : .systemGreen
        
        
    }
    
    private func setCellBackView() {
        let mass = [nameBackView, studentBackView, lessonBackView, repeatbackView, notificationBackView, priceBackView, statusPaymentBackView, commentBackView]
        
        for elem in mass {
            guard let elem = elem else { return }
            UIView().didDeselect(view: elem)
        }
    }
    
    private func setNavigationController() {
        navigationItem.leftBarButtonItem?.title = "Назад"
        navigationItem.leftBarButtonItem?.tintColor = .appBlue
        navigationItem.rightBarButtonItem?.tintColor = .appBlue
        UINavigationBar().set(controller: self)
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
        let student = IndexPath(row: 1, section: 0)
        let note = IndexPath(row: 0, section: 3)
        
        switch indexPath {
        case student:
            return lesson?.studentId == nil ? 0 : super.tableView(tableView, heightForRowAt: indexPath)
        case note:
            return lesson?.note == nil ? 0 : UITableView.automaticDimension
        default:
            return super.tableView(tableView, heightForRowAt: indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let payment = IndexPath(row: 0, section: 2)
        switch indexPath {
        case payment:
            cell.backgroundColor = .appBlueDark
        default:
            break
        }
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

// MARK: Navigation
extension LessonDetailedTVC {
    @IBAction func unwiSegueCurrentLesson(_ segue: UIStoryboardSegue) {
        
        guard let desTVC = segue.source as? PaymentTVC else { return }
        
        paymentLabel.textColor      = desTVC.payment == 0 ? .systemRed : .systemGreen
        paymentLabel.text           = desTVC.payment == 0 ? "Не оплаченно" : "Оплаченно"
        lesson?.payStatus           = desTVC.payment
        lesson?.paymentDate         = desTVC.dateOfPaymentLabel.text
        
        changeLesson(lesson: lesson!)
        self.tableView.reloadData()
        
        let nav = self.navigationController?.navigationBar
        nav?.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "payment" {
            guard let destVC = segue.destination as? PaymentTVC else { return }
            destVC.payment =  lesson?.payStatus
            destVC.paymentDate = lesson?.paymentDate
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
    
    private func changeLesson(lesson: LessonModel) {
        networkManagerCalendar.changeLesson(lessonId    : lesson.lessonId ?? 0,
                                            name        : lesson.lessonName ?? "",
                                            place       : lesson.place ?? "",
                                            studentId   : lesson.studentId ?? 0,
                                            discipline  : lesson.discipline ?? "",
                                            startDate   : lesson.startDate ?? "",
                                            endDate     : lesson.endDate ?? "",
                                            repeatedly  : lesson.repeatedly ?? "",
                                            endRepeat   : lesson.endRepeat ?? "",
                                            price       : lesson.price ?? 0,
                                            note        : lesson.note ?? "",
                                            payStatus   : lesson.payStatus ?? 0,
                                            paymentDate : lesson.paymentDate ?? "")
        { [weak self]  (responce, error)  in
            guard let responce = responce else {
                print(error ?? "")
                DispatchQueue.main.async {
                    self?.simpleAlert(message: error ?? "")
                }
                return
            }
            print("change:",responce.message ?? "")
        }
    }
}

//MARK: Alert
extension LessonDetailedTVC  {
    func simpleAlert(message: String) {
        UIAlertController.simpleAlert(title:"Ошибка", msg:"\(message)", target: self)
    }
}
