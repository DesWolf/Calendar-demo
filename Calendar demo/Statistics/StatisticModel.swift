//
//  StatisticModel.swift
//  Calendar demo
//
//  Created by Максим Окунеев on 7/15/20.
//  Copyright © 2020 Максим Окунеев. All rights reserved.
//

import Foundation

struct StatisticModel: Decodable {
    
    let payTotal: Int?
    let notPayTotal: Int?
    let countLessonPay: Int?
    let countLessonNotPay: Int?
    let countLessonTotal: Int?

}
