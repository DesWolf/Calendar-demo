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
    case newStudent(studentId: String,
                    name: String,
                    surname: String,
                    disciplines: [String],
                    phone: String,
                    email: String,
                    note: String)
    case showStudent(studentId: Int)
}

extension StudentsApi: EndPointType {
    
    var environmentBaseURL : String {
        switch NetworkManagerStudents.environment {
        case .qa: return "http://f0435023.xsph.ru/api/"
        case .production: return "http://f0435023.xsph.ru/api/"
        case .staging: return "http://f0435023.xsph.ru/api/"
        }
    }
    
    var baseURL: URL {
        guard let url = URL(string: environmentBaseURL) else { fatalError("baseURL could not be configured.")}
        return url
    }
    
    var path: String {
        switch self {
        case .students:
            return "students/show"
        case .showStudent(let studentId):
            return "students/\(studentId)"
        case .newStudent( _, _, _, _, _, _, _):
            return "students/add"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .students:
            return .get
        case .showStudent(_):
            return .get
        case .newStudent(_, _, _, _, _, _, _):
            return .post
        }
    }
    
    var task: HTTPTask {
        switch self {
        case .students:
            return .requestParametersAndHeaders(bodyParameters: nil,
                                      bodyEncoding: .urlEncoding,
                                      urlParameters: ["teacherId": KeychainWrapper.standard.string(forKey: "teacherId")!],
                                      additionHeaders: headers)
        case .showStudent(let studentId):
            return .requestParametersAndHeaders(bodyParameters: nil,
                                      bodyEncoding: .urlEncoding,
                                      urlParameters: ["studentId": studentId],
                                      additionHeaders: headers)
            
        case .newStudent(let studentId, let name, let surname, let disciplines, let phone, let email, let note):
            return .requestParametersAndHeaders(bodyParameters: ["teacherId": "\(KeychainWrapper.standard.string(forKey: "accessToken")!)",
                                                                "studentId": "\(studentId)",
                                                                "name":"\(name)",
                                                                "surname":"\(surname)",
                                                                "disciplines":"\(disciplines)",
                                                                "phone":"\(phone)",
                                                                "email":"\(email)",
                                                                "note":"\(note)"],
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

