//
//  LoginEndPoint.swift
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

public enum LoginApi {
    case registerUser(email: String, password: String, confirmPassword: String)
    case loginUser(email: String, password: String)
}

extension LoginApi: EndPointType {
    
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
        case .registerUser(_,_,_):
            return "users/new"
        case .loginUser(_,_):
            return "users/login"
        }
    }
    
    var httpMethod: HTTPMethod {
        return .post
    }
    
    var task: HTTPTask {
        switch self {
        case .registerUser(let email, let password, let confirmPassword):
            return .requestParametersAndHeaders(bodyParameters: [   "email": "\(email)",
                                                                    "password": "\(password)",
                                                                    "confirm_password": "\(confirmPassword)"],
                                                bodyEncoding: .jsonEncoding,
                                                urlParameters: nil,
                                                additionHeaders: ["Content-Type":"application/json; charset=utf-8",
                                                                  "key": NetworkManagerLogin.TeachOrgAPIKey])
            
        case .loginUser(let email, let password):
            return .requestParametersAndHeaders(bodyParameters: [ "email": "\(email)",
                "password": "\(password)"],
                                                bodyEncoding: .jsonEncoding,
                                                urlParameters: nil,
                                                additionHeaders: ["Content-Type":"application/json; charset=utf-8",
                                                                  "key": NetworkManagerLogin.TeachOrgAPIKey])
        }
    }
    
    var headers: HTTPHeaders? {
        return nil
    }
}

