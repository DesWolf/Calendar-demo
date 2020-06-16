//
//  CalendarModel.swift
//  Calendar demo
//
//  Created by Максим Окунеев on 4/24/20.
//  Copyright © 2020 Максим Окунеев. All rights reserved.
//

import Foundation

struct CalendarModel: Decodable {
    let lessonId: Int?
    let lessonName: String?
    let place: String?
    let studentId: Int?
    let studentName: String?
    let studentSurname: String?
    let discipline: String?
    let dateStart: String?
    let timeStart: String?
    let duration: [String]?
    let dateEnd: String?
    let timeEnd:  String?
    let repeatLesson: String?
    let endRepeatLesson: String?
    let price: Int?
//    let notificationType: String?
    let note: String?
    let statusPay: Int?
    let paymentDate: String?
}


