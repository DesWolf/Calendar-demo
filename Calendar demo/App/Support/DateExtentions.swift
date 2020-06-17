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
    
    func convertStrToDate(str: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter.date(from: str)!
    }
    
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
    
    func convertStrDate(date: String, formatFrom: String, formatTo: String) -> String {
        var result = ""
        let formatter = DateFormatter()
        formatter.dateFormat = formatFrom //"dd MMMM, yyyy"
        guard let date = formatter.date(from: date) else { return "Wrong format" }
        formatter.dateFormat = formatTo //"yyyy-MM-dd"
        result = formatter.string(from: date)
        
        return result
    }
}

