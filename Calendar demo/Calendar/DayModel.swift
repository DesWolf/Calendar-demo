//
//  dayModel.swift
//  Calendar demo
//
//  Created by Максим Окунеев on 4/24/20.
//  Copyright © 2020 Максим Окунеев. All rights reserved.
//

import Foundation

struct DayModel: Decodable{
    var lesson_id: String?
    var date_start: String?
    var date_end: String?
    var student_id: String?
}


