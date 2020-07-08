//
//  CalendarEndPoint.swift
//  Calendar demo
//
//  Created by Максим Окунеев on 6/4/20.
//  Copyright © 2020 Максим Окунеев. All rights reserved.
//

import Foundation
import SwiftKeychainWrapper

public enum CalendarApi {
    case calendar(startDate: String, endDate: String)
    
    case showLesson(lessonId: Int)
    
    case addLesson(name: String,
        place: String,
        studentId: Int,
        discipline: String,
        startDate: String,
        endDate: String,
        repeatedly: String,
        endRepeat: String,
        price: Int,
        note: String)
    
    case changeLesson(lessonId: Int,
        name: String,
        place: String,
        studentId: Int,
        discipline: String,
        startDate: String,
        endDate: String,
        repeatedly: String,
        endRepeat: String,
        price: Int,
        note: String,
        payStatus: Int,
        paymentDate: String)
    
    case deleteLesson(lessonId: Int)
}

extension CalendarApi: EndPointType {
    
    var environmentBaseURL : String {
        switch NetworkManagerStudents.environment {
        case .qa: return "http://f0435023.xsph.ru/api/lessons/"
        case .production: return "http://f0435023.xsph.ru/api/lessons/"
        case .staging:  return "http://f0435023.xsph.ru/api/lessons/"
        }
    }
    
    var baseURL: URL {
        guard let url = URL(string: environmentBaseURL) else { fatalError("baseURL could not be configured.")}
        return url
    }
    
    var path: String {
        switch self {
        case .calendar:
            return "show"
        case .showLesson(let studentId):
            return "\(studentId)"
        case .addLesson( _, _, _, _, _, _, _, _, _, _):
            return "add"
        case .changeLesson(_, _, _, _, _, _, _, _, _, _, _, _, _):
            return "update"
        case .deleteLesson(_):
            return "delete"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .calendar:
            return .get
        case .showLesson(_):
            return .get
        case .addLesson(_, _, _, _, _, _, _, _, _, _):
            return .post
        case .changeLesson(_, _, _, _, _, _, _, _, _, _, _, _, _):
            return .patch
        case .deleteLesson(_):
            return .delete
        }
    }
    
    var task: HTTPTask {
        let teacheId = "\(KeychainWrapper.standard.string(forKey: "teacherId")!)"
        
        switch self {
        case .calendar(let dateStart, let dateEnd):
            return .requestParametersAndHeaders(bodyParameters: nil,
                                                bodyEncoding: .urlEncoding,
                                                urlParameters: ["teacher_id": teacheId,
                                                                "start_date": dateStart,
                                                                "end_date": dateEnd],
                                                additionHeaders: headers)
        case .showLesson(let lessonId):
            return .requestParametersAndHeaders(bodyParameters: nil,
                                                bodyEncoding: .urlEncoding,
                                                urlParameters: ["lesson_id": lessonId],
                                                additionHeaders: headers)
            
        case .addLesson(
            let name,
            let place,
            let studentId,
            let discipline,
            let startDate,
            let endDate,
            let repeatedly,
            let endRepeat,
            let price,
            let note):
            return .requestParametersAndHeaders(bodyParameters: [ "teacher_id": teacheId,
                                                                  "name": name,
                                                                  "place": place,
                                                                  "student_id": studentId,
                                                                  "discipline": discipline,
                                                                  "start_date": startDate,
                                                                  "end_date": endDate,
                                                                  "repeatedly": repeatedly,
                                                                  "end_repeat": endRepeat,
                                                                  "price": price,
                                                                  "note": note ],
                                                bodyEncoding: .jsonEncoding,
                                                urlParameters: nil,
                                                additionHeaders: headers)
        case .changeLesson(let lessonId,
                           let name,
                           let place,
                           let studentId,
                           let discipline,
                           let dateStart,
                           let dateEnd,
                           let repeatedly,
                           let endRepeat,
                           let price,
                           let note,
                           let payStatus,
                           let paymentDate):
            return .requestParametersAndHeaders(bodyParameters: ["teacher_id": teacheId,
                                                                 "lesson_id": lessonId,
                                                                 "name": name,
                                                                 "place": place,
                                                                 "student_id": studentId,
                                                                 "discipline": discipline,
                                                                 "start_date": dateStart,
                                                                 "end_date": dateEnd,
                                                                 "repeatedly": repeatedly,
                                                                 "end_repeat": endRepeat,
                                                                 "price": price,
                                                                 "note": note,
                                                                 "pay_status": payStatus,
                                                                 "payment_date": paymentDate],
                                                bodyEncoding: .jsonEncoding,
                                                urlParameters: nil,
                                                additionHeaders: headers)
            
        case .deleteLesson(let lessonId):
            return .requestParametersAndHeaders(bodyParameters: ["teacher_id": teacheId,
                                                                 "lesson_id": lessonId],
                                                bodyEncoding: .jsonEncoding,
                                                urlParameters: nil,
                                                additionHeaders: headers)
        }
    }
    
    var headers: HTTPHeaders? {
        return ["key": NetworkManagerLogin.TeachOrgAPIKey,
                "token": KeychainWrapper.standard.string(forKey: "accessToken")!]
    }
}
