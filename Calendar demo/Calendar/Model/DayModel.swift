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
    let note: String?
}

struct Duration: Decodable, Comparable {
    static func < (lhs: Duration, rhs: Duration) -> Bool {
        if lhs.dateStart != rhs.dateStart {
            return lhs.dateStart < rhs.dateStart
        } else if lhs.dateStart != rhs.dateStart {
            return lhs.dateStart < rhs.dateStart
        } else {
            return lhs.dateStart < rhs.dateStart
        }
    }
    
    let dateStart: String
    let dateEnd: String
}


