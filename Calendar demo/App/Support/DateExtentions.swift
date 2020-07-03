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

//    func month(date: Date) -> String {
//       let dateFormatter = DateFormatter()
//       dateFormatter.dateFormat = "MMMM"
//       return dateFormatter.string(from: date)
//   }
    
//    func monthMinusOne(date: Date) -> Date {
//        var components = DateComponents()
//        components.month = -1
//        components.day = -1
//        return Calendar(identifier: .gregorian).date(byAdding: components, to: date)!
//    }
//
    func monthPlusOne(date: Date) -> Date {
        var components = DateComponents()
        components.month = 1
        components.day = 1
        return Calendar(identifier: .gregorian).date(byAdding: components, to: date)!
    }
    
   
    
    func convertStrToDate(str: String) -> Date {
        let dateFormatter = DateFormatter()
        switch str.count {
        case 10:
            dateFormatter.dateFormat = "dd.MM.yyyy"
        case 25:
           dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ssZ"
        default:
             dateFormatter.dateFormat = "dd MMMM, yyyy"
        }
        
        guard let date = dateFormatter.date(from: str) else {
            return Date()
        }
        return date
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
    
    func time(str: String) -> String {
        return convertStrDate(date: str,
                              formatFrom: "yyyy-MM-dd HH:mm:ssZ",
                              formatTo: "HH:mm")
    }
    
    func date(str: String) -> String {
        return convertStrDate(date: str,
                              formatFrom: "yyyy-MM-dd HH:mm:ssZ",
                              formatTo: "dd.MM.YY")
    }
    
    func fullScreenDate(str: String) -> String {
        return convertStrDate(date: str,
                              formatFrom: "yyyy-MM-dd HH:mm:ssZ",
                              formatTo: "EEEE, MMM d, yyyy")
}
}
