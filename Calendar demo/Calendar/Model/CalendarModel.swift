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
    let studentName: String?
    let studentSurname: String?
    let dateStart: String?
    let dateEnd: String?
    let duration: [String]?
    let note: String?
    let price: Int?
    let discipline: String?
    let place: String?
    let statusPay: Bool?
}

struct Duration: Decodable, Comparable {
    let dateStart: String
    let dateEnd: String
    
static func < (lhs: Duration, rhs: Duration) -> Bool {
    if lhs.dateStart != rhs.dateStart {
        return lhs.dateStart < rhs.dateStart
    } else if lhs.dateStart != rhs.dateStart {
        return lhs.dateStart < rhs.dateStart
    } else {
        return lhs.dateStart < rhs.dateStart
    }
}
}
