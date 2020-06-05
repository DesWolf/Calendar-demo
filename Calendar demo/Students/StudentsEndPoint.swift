//
//  DataEndPoint.swift
//  Calendar demo
//
//  Created by Максим Окунеев on 5/14/20.
//  Copyright © 2020 Максим Окунеев. All rights reserved.
//

import Foundation
import SwiftKeychainWrapper

public enum StudentsApi {
    case students
    
    case showStudent(studentId: Int)
    
    case addStudent(studentId: Int,
                    name: String,
                    surname: String,
                    disciplines: [String],
                    phone: String,
                    email: String,
                    note: String)
    
    case changeStudent(studentId: Int,
                    name: String,
                    surname: String,
                    disciplines: [String],
                    phone: String,
                    email: String,
                    note: String)
    
    case deleteStudent(studentId: Int)
}

extension StudentsApi: EndPointType {
    
    var environmentBaseURL : String {
        switch NetworkManagerStudents.environment {
        case .qa: return "http://f0435023.xsph.ru/api/students/"
        case .production: return "http://f0435023.xsph.ru/api/students/"
        case .staging: return "http://f0435023.xsph.ru/api/students/"
        }
    }
    
    var baseURL: URL {
        guard let url = URL(string: environmentBaseURL) else { fatalError("baseURL could not be configured.")}
        return url
    }
    
    var path: String {
        switch self {
        case .students:
            return "show"
        case .showStudent(let studentId):
            return "\(studentId)"
        case .addStudent( _, _, _, _, _, _, _):
            return "add"
        case .changeStudent( _, _, _, _, _, _, _):
            return "update"
        case .deleteStudent(_):
            return "delete"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .students:
            return .get
        case .showStudent(_):
            return .get
        case .addStudent(_, _, _, _, _, _, _):
            return .post
        case .changeStudent( _, _, _, _, _, _, _):
            return .patch
        case .deleteStudent(_):
            return .delete
        }
    }
    
    var task: HTTPTask {
        let teacheId = "\(KeychainWrapper.standard.string(forKey: "teacherId")!)"
        switch self {
        case .students:
            return .requestParametersAndHeaders(bodyParameters: nil,
                                                bodyEncoding: .urlEncoding,
                                                urlParameters: ["teacherId": teacheId],
                                                additionHeaders: headers)
        case .showStudent(let studentId):
            return .requestParametersAndHeaders(bodyParameters: nil,
                                                bodyEncoding: .urlEncoding,
                                                urlParameters: ["studentId": studentId],
                                                additionHeaders: headers)
            
        case .addStudent(let studentId,
                         let name,
                         let surname,
                         let disciplines,
                         let phone,
                         let email,
                         let note):
            return .requestParametersAndHeaders(bodyParameters: ["teacherId": teacheId,
                                                                "studentId": studentId,
                                                                "name": name,
                                                                "surname": surname,
                                                                "disciplines": disciplines,
                                                                "phone": phone,
                                                                "email": email,
                                                                "note": note],
                                                bodyEncoding: .jsonEncoding,
                                                urlParameters: nil,
                                                additionHeaders: headers)
            
        case .changeStudent(let studentId,
                            let name,
                            let surname,
                            let disciplines,
                            let phone,
                            let email,
                            let note):
            return .requestParametersAndHeaders(bodyParameters: ["teacherId": teacheId,
                                                                "studentId": studentId,
                                                                "name": name,
                                                                "surname": surname,
                                                                "disciplines": disciplines,
                                                                "phone": phone,
                                                                "email": email,
                                                                "note": note],
                                                bodyEncoding: .jsonEncoding,
                                                urlParameters: nil,
                                                additionHeaders: headers)
        case .deleteStudent(let studentId):
            return .requestParametersAndHeaders(bodyParameters: ["teacherId": teacheId,
                                                                "studentId": studentId],
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

