//
//  MeetingCell.swift
//  Calendar demo
//
//  Created by Максим Окунеев on 4/21/20.
//  Copyright © 2020 Максим Окунеев. All rights reserved.
//

import UIKit

class MeetingCell: UITableViewCell {

    @IBOutlet var timeOfMeetingLabel: UILabel!
    @IBOutlet var lessonLabel: UILabel!
    @IBOutlet var taskImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    
    @IBAction func taskAction(_ sender: Any) {
        endLessonAlert()
    }
    func configere(with meeting: DayModel) {
        let startTime = "\(meeting.duration?.dateStart[11..<16] ?? "10:00")"
        let endTime = "\(meeting.duration?.dateEnd[11..<16] ?? "11:00")"

        self.timeOfMeetingLabel.text = "\(startTime)-\(endTime)"
        self.nameLabel.text = "\(meeting.studentId ?? "")"
        self.lessonLabel.text = "Французский"
    }
}


//MARK: AlertControllers
extension  MeetingCell {
    
     private func endLessonAlert() {
        let alertController = UIAlertController(title: "Урок окончен?", message: "", preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Да", style: .default, handler: { (UIAlertAction) in
            self.sucsessEndAlert()
        }))
        alertController.addAction(UIAlertAction(title: "Не проводился", style: .destructive, handler: { (UIAlertAction) in
            self.unSucsessEndAlert()
          }))
        let rootViewController = UIApplication.shared.keyWindow?.rootViewController
        rootViewController?.present(alertController, animated: true, completion: nil)
    }
    
     private func sucsessEndAlert() {
        let alertController = UIAlertController(title: "Урок оплачен?", message: "", preferredStyle: .alert)

        alertController.addAction(UIAlertAction(title: "Нет, добавить в отчет", style: .default, handler: { (UIAlertAction) in
            self.taskImageView.image = #imageLiteral(resourceName: "taskDone")
             }))
        alertController.addAction(UIAlertAction(title: "Да, отправить чек на оплату", style: .default, handler: { (UIAlertAction) in
            self.taskImageView.image = #imageLiteral(resourceName: "taskDone")
             }))
        alertController.addAction(UIAlertAction(title: "Отмена", style: .destructive, handler: { (UIAlertAction) in
            
            }))
        let rootViewController = UIApplication.shared.keyWindow?.rootViewController
        rootViewController?.present(alertController, animated: true, completion: nil)
    }
    
    private func unSucsessEndAlert() {
    let alertController = UIAlertController(title: "Перенести?", message: "", preferredStyle: .alert)

    alertController.addAction(UIAlertAction(title: "Да", style: .default, handler: { (UIAlertAction) in
        
         }))
    alertController.addAction(UIAlertAction(title: "Отмена", style: .destructive, handler: { (UIAlertAction) in
        
        }))
    let rootViewController = UIApplication.shared.keyWindow?.rootViewController
    rootViewController?.present(alertController, animated: true, completion: nil)
}

}

// MARK: Network
    func sendrequest(completion: @escaping ([DayModel]) -> ()) {
       guard let url = URL(string: "http://5.63.154.6/api/pay?key=0194f13efb8487de1fc1b99edb5f598d&date_start=2020-04-01&date_end=2020-04-30&teacher_id=5") else { return }
       URLSession.shared.dataTask(with: url) { (data, responce, error) in
           if let data = data {
               do {
                   let decoder = JSONDecoder()
                   decoder.keyDecodingStrategy = .convertFromSnakeCase
                   let jsonData = try decoder.decode([DayModel].self, from: data)
                   DispatchQueue.main.async {
                       completion(jsonData)
                   }
               } catch let error {
                   DispatchQueue.main.async {
                       print ("Error serialization JSON", error)
                       completion([])
                   }
               }
           } else {
           }
       }.resume()
   }
