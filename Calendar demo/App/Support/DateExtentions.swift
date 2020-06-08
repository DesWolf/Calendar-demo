//
//  DateExtentions.swift
//  Calendar demo
//
//  Created by Максим Окунеев on 6/6/20.
//  Copyright © 2020 Максим Окунеев. All rights reserved.
//

import Foundation

extension Date {

    var currentMonth: Date {
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.year, .month], from: self)
        return  calendar.date(from: components)!
    }
    
    var monthMinusOne: Date {
        var components = DateComponents()
        components.month = -1
        components.day = -1
        return Calendar(identifier: .gregorian).date(byAdding: components, to: currentMonth)!
    }

    var monthPlusOne: Date {
        var components = DateComponents()
        components.month = 2
        components.day = 1
        return Calendar(identifier: .gregorian).date(byAdding: components, to: currentMonth)!
    }
    
//    func convertCVCalendarDate(format: String) -> String {
//        let date = Date()
//        let formatter = DateFormatter()
//        formatter.dateFormat = format
//
//        return formatter.string(from: date)
//    }
    
    func convertCVCalendarDate(date: String) -> String{
        var result = ""
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM, yyyy"
        if let date = formatter.date(from: date) {
            formatter.dateFormat = "yyyy-MM-dd"
            result = formatter.string(from: date)
        }
        return result
    }
}

