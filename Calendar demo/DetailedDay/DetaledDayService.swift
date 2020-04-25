//
//  DetaledDayService.swift
//  Calendar demo
//
//  Created by Максим Окунеев on 4/25/20.
//  Copyright © 2020 Максим Окунеев. All rights reserved.
//


import UIKit


struct DetailedDayService {
    
    // MARK: Network
    static func fetchCalendar(completion: @escaping ([DayModel]) -> ()) {
        guard let url = URL(string: "http://5.63.154.6/api/lesson?key=0194f13efb8487de1fc1b99edb5f598d&date_start=2020-04-01&date_end=2020-04-30&teacher_id=5") else { return }
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
                DispatchQueue.main.async {
                    networkAlert()
                }
            }
        }.resume()
    }
    
    // MARK: Network Alert
    static func networkAlert() {
        let alertController = UIAlertController(title: "Error", message: "Network is unavaliable! Please try again later!", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        let rootViewController = UIApplication.shared.keyWindow?.rootViewController
        rootViewController?.present(alertController, animated: true, completion: nil)
    }
}
