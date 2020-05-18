//
//  DataEndPoint.swift
//  Calendar demo
//
//  Created by Максим Окунеев on 5/14/20.
//  Copyright © 2020 Максим Окунеев. All rights reserved.
//

import Foundation

enum NetworkEnvironment {
    case qa
    case production
    case staging
}

public enum StudentsApi {
    case students(teacherId: String)
    case newStudent(teacherId: String,
                    name: String,
                    surname: String,
                    phone: String,
                    email: String,
                    currentDiscipline: String,
                    note: String)
    case showStudent(studentId: String)
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
        case .newStudent(_, _, _, _, _, _, _):
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
        case .students( let teacherId):
            return .requestParameters(bodyParameters: nil,
                                      bodyEncoding: .urlEncoding,
                                      urlParameters: ["key": NetworkManagerLogin.TeachOrgAPIKey,
                                                      "teacherId": "\(teacherId)"])
            
        case .showStudent(let studentId):
            return .requestParameters(bodyParameters: nil,
                                      bodyEncoding: .urlEncoding,
                                      urlParameters: ["key": NetworkManagerLogin.TeachOrgAPIKey])
            
        case .newStudent(let teacherId, let name, let surname, let phone, let email, let currentDiscipline, let note):
            return .requestParametersAndHeaders(bodyParameters: ["teacherId": "\(teacherId)",
                                                                "name":"\(name)",
                                                                "surname":"\(surname)",
                                                                "phone":"\(phone)",
                                                                "email":"\(email)",
                                                                "currentDiscipline":"\(currentDiscipline)",
                                                                "note":"\(note)"],
                                                bodyEncoding: .urlAndJsonEncoding,
                                                urlParameters: ["key": NetworkManagerLogin.TeachOrgAPIKey],
                                                additionHeaders: ["Content-Type":"application/json; charset=utf-8"])
        }
    }
    
    var headers: HTTPHeaders? {
        return nil
    }
}

