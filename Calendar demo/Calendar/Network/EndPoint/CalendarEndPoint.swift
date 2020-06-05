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
    
    case addLesson(teacherId: String,
        name: String,
        studentId: String,
        dateStart: String,
        dateEnd: String,
        place: String,
        note: String,
        price: String,
        discipline: String)
    
    case changeLesson(teacherId: String,
        name: String,
        studentId: String,
        dateStart: String,
        dateEnd: String,
        place: String,
        note: String,
        price: String,
        discipline: String)
    
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
        case .addLesson(_, _, _, _, _, _, _, _, _):
            return "add"
        case .changeLesson(_, _, _, _, _, _, _, _, _):
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
        case .addLesson(_, _, _, _, _, _, _, _, _):
            return .post
        case .changeLesson(_, _, _, _, _, _, _, _, _):
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
                                                urlParameters: ["teacherId": teacheId,
                                                                "dateStart": dateStart,
                                                                "dateEnd": dateEnd],
                                                additionHeaders: headers)
        case .showLesson(let lessonId):
            return .requestParametersAndHeaders(bodyParameters: nil,
                                                bodyEncoding: .urlEncoding,
                                                urlParameters: ["lessonId": lessonId],
                                                additionHeaders: headers)
            
        case .addLesson(let teacherId,
                        let name,
                        let studentId,
                        let dateStart,
                        let dateEnd,
                        let place,
                        let note,
                        let price,
                        let discipline):
            return .requestParametersAndHeaders(bodyParameters: ["teacherId": teacheId,
                                                                 "name": name,
                                                                 "studentId": studentId,
                                                                 "dateStart": dateStart,
                                                                 "dateEnd": dateEnd,
                                                                 "place": place,
                                                                 "note": note,
                                                                 "price": price,
                                                                 "discipline": discipline],
                                                bodyEncoding: .jsonEncoding,
                                                urlParameters: nil,
                                                additionHeaders: headers)
        case .changeLesson(let teacherId,
                           let name,
                           let studentId,
                           let dateStart,
                           let dateEnd,
                           let place,
                           let note,
                           let price,
                           let discipline):
            return .requestParametersAndHeaders(bodyParameters: ["teacherId": teacheId,
                                                                 "name": name,
                                                                 "studentId": studentId,
                                                                 "dateStart": dateStart,
                                                                 "dateEnd": dateEnd,
                                                                 "place": place,
                                                                 "note": note,
                                                                 "price": price,
                                                                 "discipline": discipline],
                                                bodyEncoding: .jsonEncoding,
                                                urlParameters: nil,
                                                additionHeaders: headers)
            
        case .deleteLesson(let lessonId):
            return .requestParametersAndHeaders(bodyParameters: ["teacherId": teacheId,
                                                                "lessonId": lessonId],
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
