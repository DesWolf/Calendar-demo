//
//  DateExtentions.swift
//  Calendar demo
//
//  Created by Максим Окунеев on 6/6/20.
//  Copyright © 2020 Максим Окунеев. All rights reserved.
//

import Foundation

enum StringDateType: String {
    case time = "HH:mm"
    case date = "dd.MM.YY"
    case dateTime = "dd.MM.yyyy HH:mm"
    case fullDateTime = "EEEE, d MMMM yyyy"
}


extension Date {
    
    var month: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM YYYY"
        return dateFormatter.string(from: self)
    }
    
    var secondsFromGMT: Int { return TimeZone.current.secondsFromGMT() }
    
    public func monthMinusOne(str: String) -> Date {
        let date = strToDate(str: str)
        
        var components = DateComponents()
        components.month = -1
        components.day = -7
        return Calendar(identifier: .gregorian).date(byAdding: components, to: date)!
    }
    
    public func monthPlusOne(str: String) -> Date {
        let date = strToDate(str: str)
        
        var components = DateComponents()
        components.month = 1
        components.day = 7
        return Calendar(identifier: .gregorian).date(byAdding: components, to: date)!
    }
    
    public func strToDate(str: String?) -> Date {
        var newStr = str ?? "\(Date())"
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale(identifier: "RU_RU")
        
        switch newStr.count {
        case 10:
            dateFormatter.dateFormat = "dd.MM.yyyy"
        case 19:
            newStr = newStr + "+0000"
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ssZ"
        case 25:
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ssZ"
        default:
            newStr = newStr + "+0000"
            dateFormatter.dateFormat = "dd MMMM, yyyy HH:mm:ssZ"
            
        }
        
        guard let date = dateFormatter.date(from: newStr) else {
            return Date()
        }
        return date
    }
    
    
    func str(str: String?, to: StringDateType) -> String {
        var newStr = str ?? "\(Date())"
        newStr = str?.count == 19 ? (newStr + "+0000") : newStr
        
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale(identifier: "RU_RU")
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ssZ"
        guard var date = dateFormatter.date(from: newStr) else { return "Wrong format" }
        dateFormatter.dateFormat = to.rawValue
        date = checkFive(date: date)
        
        return dateFormatter.string(from: date)
    }
    
    private func checkFive(date: Date) -> Date {
        var date = date
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        let hour = calendar.component(.hour, from: date)
        var minutes = calendar.component(.minute, from: date)
        
        if minutes % 5 != 0 {
            
            while minutes % 5 > 0 {
                    minutes -= 1
            }
        }
        let dateComponents = DateComponents(calendar: calendar, year: year, month: month, day: day, hour: hour, minute: minutes)
        date = calendar.date(from: dateComponents) ?? Date()
        
        return date
    }
}

