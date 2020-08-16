//
//  StatisticEndPoint.swift
//  Calendar demo
//
//  Created by Максим Окунеев on 6/17/20.
//  Copyright © 2020 Максим Окунеев. All rights reserved.
//

import Foundation
import SwiftKeychainWrapper

public enum StatisticApi {
    case statistic(startDate: String, endDate: String)
}

extension StatisticApi: EndPointType {
    
    var environmentBaseURL : String {
        switch NetworkManagerStudents.environment {
        case .qa: return "http://f0435023.xsph.ru/api/payment/"
        case .production: return "http://f0435023.xsph.ru/api/payment/"
        case .staging:  return "http://f0435023.xsph.ru/api/payment/"
        }
    }
    
    var baseURL: URL {
        guard let url = URL(string: environmentBaseURL) else { fatalError("baseURL could not be configured.")}
        return url
    }
    
    var path: String {
        switch self {
        case .statistic:
            return "show"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .statistic:
            return .get
        }
    }
    
    var task: HTTPTask {
        let teacheId = "\(KeychainWrapper.standard.string(forKey: "teacherId")!)"
        
        switch self {
        case .statistic(let dateStart, let dateEnd):
            return .requestParametersAndHeaders(bodyParameters: nil,
                                                bodyEncoding: .urlEncoding,
                                                urlParameters: ["teacher_id": teacheId,
                                                                "start_date": dateStart,
                                                                "end_date": dateEnd],
                                                additionHeaders: headers)
            
        }
    }
    
    var headers: HTTPHeaders? {
        return ["key": NetworkManagerLogin.TeachOrgAPIKey,
                "token": KeychainWrapper.standard.string(forKey: "accessToken")!]
    }
}
