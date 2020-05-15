//
//  LoginEndPoint.swift
//  Calendar demo
//
//  Created by Максим Окунеев on 5/14/20.
//  Copyright © 2020 Максим Окунеев. All rights reserved.
//

import Foundation

public enum LoginApi {
    case registerUser(email: String, password: String, confirmPassword: String)
    case loginUser(email: String, password: String)
}

extension LoginApi: EndPointType {
  
    var environmentBaseURL : String {
        switch NetworkManagerMainData.environment {
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
            return .requestParametersAndHeaders(bodyParameters: [ "email": "\(email)",
                                                        "password": "\(password)",
                                                        "confirmPassword": "\(confirmPassword)"],
                                      bodyEncoding: .urlAndJsonEncoding,
                                      urlParameters: ["key": NetworkManagerLogin.TeachOrgAPIKey],
                additionHeaders: ["Content-Type":"application/json; charset=utf-8"])

        case .loginUser(let email, let password):
            return .requestParametersAndHeaders(bodyParameters: [ "email": "\(email)",
                                                        "password": "\(password)"],
                                    bodyEncoding: .urlAndJsonEncoding,
                                    urlParameters: ["key":NetworkManagerLogin.TeachOrgAPIKey],
            additionHeaders: ["Content-Type":"application/json; charset=utf-8"])
        }
    }
    
    var headers: HTTPHeaders? {
        return nil
    }
}

