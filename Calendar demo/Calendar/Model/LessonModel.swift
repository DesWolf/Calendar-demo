//
//  CalendarModel.swift
//  Calendar demo
//
//  Created by Максим Окунеев on 4/24/20.
//  Copyright © 2020 Максим Окунеев. All rights reserved.
//

import Foundation

struct LessonModel: Decodable {
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
    let repeatedly: String?
    let endRepeat: String?
    let price: Int?
    let note: String?
    var statusPay: Int?
    var paymentDate: String?
}


