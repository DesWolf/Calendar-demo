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
    
    var lesson: LessonModel?
    private var paymentDate: String?
    private let networkManagerCalendar =  NetworkManagerCalendar()
    
    public var onEditButtonTap: ((LessonModel) -> (Void))?
    public var onBackButtonTap: (() -> (Void))?
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationController()
        setupScreen(lesson: lesson)
        
        print(lesson)
        
        
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
        
        let lessonStart = Date().convertStrToDate(str: "\(lesson?.dateStart ?? "2020-01-01") \(lesson?.timeStart ?? "00:00:00")")
        let lessonEnd = Date().convertStrToDate(str: "\(lesson?.dateStart ?? "2020-01-01") \(lesson?.timeStart ?? "00:00:00")")
        let endRepeat = Date().convertStrToDate(str: "\(lesson?.endRepeat ?? "2020-01-01 00:00:00 +0000")")
        
        nameLabel.text = lesson?.lessonName ?? ""
        placeLabel.text = lesson?.place ?? ""
        disciplineLabel.text = lesson?.discipline ?? ""
        timeLabel.text =  "с \(Date().time(str: "\(lessonStart)")) до \(Date().time(str: "\(lessonEnd)"))"
        dateLabel.text = Date().fullScreenDate(str: "\(lessonStart)")
        studentLabel.text = "\(lesson?.studentName ?? "") - \(lesson?.studentSurname ?? "")"
        noteTV.text = lesson?.note ?? ""
        repeatLabel.text = lesson?.endRepeat != nil ? "до \(Date().date(str: "\(endRepeat)"))" : "Нет"
        priceLabel.text = "\(lesson?.price ?? 0) руб."
        paymentLabel.text = lesson?.statusPay == 0 ? "Не оплаченно" : "Оплаченно"
    }
    
    private func setNavigationController() {
        let navBar = self.navigationController?.navigationBar
        let navHeight = UIApplication.shared.statusBarFrame.height + navBar!.frame.height
        
        navBar?.setBackgroundImage(UIImage(), for: .default)
        navBar?.shadowImage = UIImage()
        navBar?.isTranslucent = true
        
        navigationItem.leftBarButtonItem?.title = "Назад"
        navigationItem.leftBarButtonItem?.tintColor = .white
        navigationItem.rightBarButtonItem?.tintColor = .white
        
        
        
        UIColor.setGradientToTableView(tableView: tableView, height: Double(navHeight))
        tableView.backgroundColor = .clear
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
            cell.backgroundColor = .bgStudent
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
        let textCollor: UIColor = desTVC.payment == "Не оплаченно" ? .systemRed : .systemGreen
        self.paymentLabel.textColor = textCollor
        self.paymentLabel.text = desTVC.payment
        self.paymentDate = desTVC.dateOfPaymentLabel.text
        
        lesson?.statusPay = desTVC.payment == "Не оплачено" ?  0 : 1
        lesson?.paymentDate = paymentDate
        changeLesson(lesson: lesson!)
        self.tableView.reloadData()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
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
    
    private func changeLesson(lesson: LessonModel) {
        networkManagerCalendar.changeLesson(lessonId: lesson.lessonId ?? 0,
                                            name: lesson.lessonName ?? "",
                                            place: lesson.place ?? "",
                                            studentId: lesson.studentId ?? 0,
                                            discipline: lesson.discipline ?? "",
                                            dateStart: lesson.dateStart ?? "",
                                            timeStart: lesson.timeStart ?? "",
                                            dateEnd: lesson.dateEnd ?? "",
                                            timeEnd: lesson.timeEnd ?? "",
                                            repeatedly: lesson.repeatedly ?? "",
                                            endRepeat: lesson.endRepeat ?? "",
                                            price: lesson.price ?? 0,
                                            note: lesson.note ?? "",
                                            statusPay: lesson.statusPay ?? 0,
                                            paymentDate: lesson.paymentDate ?? "")
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
