//
//  DateExtentions.swift
//  Calendar demo
//
//  Created by Максим Окунеев on 6/6/20.
//  Copyright © 2020 Максим Окунеев. All rights reserved.
//

import Foundation

extension Date {
    
    var month: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM YYYY"
        return dateFormatter.string(from: self)
    }
    
    var secondsFromGMT: Int { return TimeZone.current.secondsFromGMT() }
    
    
    public func monthMinusOne(str: String) -> Date {
        let date = convertStrToDate(str: str)
        
        var components = DateComponents()
        components.month = -1
        components.day = -7
        return Calendar(identifier: .gregorian).date(byAdding: components, to: date)!
    }
    
    public func monthPlusOne(str: String) -> Date {
        let date = convertStrToDate(str: str)
        
        var components = DateComponents()
        components.month = 1
        components.day = 7
        return Calendar(identifier: .gregorian).date(byAdding: components, to: date)!
    }
    
    
    
    public func convertStrToDate(str: String?) -> Date {
        var newStr = str ?? "\(Date())"
        let dateFormatter = DateFormatter()
        
        switch newStr.count {
        case 10:
            dateFormatter.dateFormat = "dd.MM.yyyy"
        case 19:
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        case 25:
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ssZ"
        default:
            newStr = newStr + getCurrentTime()
            dateFormatter.dateFormat = "dd MMMM, yyyy HH:mm:ssZ"
            
        }
        
        guard let date = dateFormatter.date(from: newStr) else {
            return Date()
        }
        return date
    }
    
    private func getCurrentTime() -> String {
        let date = "\(Date())"
        var  result = ""
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ssZ"
        
        if let date = dateFormatter.date(from: date) {
            dateFormatter.timeZone = TimeZone.current
            dateFormatter.dateFormat = "HH:mm:ssZ"
            
            result = dateFormatter.string(from: date)
            print(result)
        }
        return " " + result
    }
    
    public func convertStrDate(date: String, formatFrom: String, formatTo: String) -> String {
        var result = date
        let formatter = DateFormatter()
        formatter.dateFormat = formatFrom //"dd MMMM, yyyy"
        guard var date = formatter.date(from: date) else { return "Wrong format" }
        formatter.dateFormat = formatTo //"yyyy-MM-dd"
        
        result = formatter.string(from: checkFive(date: date))
        
        return result
    }
    
    func checkFive(date: Date) -> Date {
        var date = date
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        let hour = calendar.component(.hour, from: date)
        var minutes = calendar.component(.minute, from: date)
        
        if minutes % 5 != 0 {
            
            while minutes % 5 > 0 {
                minutes += 1
            }
        }
        
        let dateComponents = DateComponents(calendar: calendar, year: year, month: month, day: day, hour: hour, minute: minutes)
        date = calendar.date(from: dateComponents) ?? Date()
        
        return date
    }
    
    public func time(str: String?) -> String {
        let newStr = str ?? "\(Date())"
        let formatFrom = newStr.count == 19 ? "yyyy-MM-dd HH:mm:ss" : "yyyy-MM-dd HH:mm:ssZ"
        
        return convertStrDate(date: newStr, formatFrom: formatFrom,  formatTo: "HH:mm")
    }
    
    public func date(str: String?) -> String {
        let newStr = str ?? "\(Date())"
        let formatFrom = newStr.count == 19 ? "yyyy-MM-dd HH:mm:ss" : "yyyy-MM-dd HH:mm:ssZ"
        
        return convertStrDate(date: newStr, formatFrom: formatFrom, formatTo: "dd.MM.YY")
    }
    
    public func fullDate(str: String?) -> String {
        let newStr = str ?? "\(Date())"
        let formatFrom = newStr.count == 19 ? "yyyy-MM-dd HH:mm:ss" : "yyyy-MM-dd HH:mm:ssZ"
        
        return convertStrDate(date: newStr, formatFrom: formatFrom, formatTo: "dd.MM.yyyy hh:mm")
    }
    
    
    public func fullScreenDate(str: String?) -> String {
        let newStr = str ?? "\(Date())"
        let formatFrom = newStr.count == 19 ? "yyyy-MM-dd HH:mm:ss" : "yyyy-MM-dd HH:mm:ssZ"
        
        return convertStrDate(date: newStr, formatFrom: formatFrom, formatTo: "EEEE, d MMMM, yyyy")
    }
}
