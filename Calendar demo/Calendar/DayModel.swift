//
//  dayModel.swift
//  Calendar demo
//
//  Created by Максим Окунеев on 4/24/20.
//  Copyright © 2020 Максим Окунеев. All rights reserved.
//

import Foundation

struct DayModel: Decodable{
    let date: String?
    let duration: Duration?
    let studentId: String?
}

struct Duration: Decodable {
    let dateStart: String
    let dateEnd: String
}


