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

public enum DataApi {
    case contacts
    case addUser(login: String, password: String)
    //    case albums
    //    case photos(albumId: Int)
    //    case photoImage(imageUrl: String)
}

extension DataApi: EndPointType {
    
    var environmentBaseURL : String {
        switch NetworkManagerMainData.environment {
        case .qa: return "https://jsonplaceholder.typicode.com/"
        case .production: return "https://jsonplaceholder.typicode.com/"
        case .staging: return "https://jsonplaceholder.typicode.com/"
        }
    }
    
    var baseURL: URL {
        guard let url = URL(string: environmentBaseURL) else { fatalError("baseURL could not be configured.")}
        return url
    }
    
    var path: String {
        switch self {
        case .contacts:
            return "users"
        case .addUser(_,_):
            return "users"
            //        case .albums:
            //            return "albums"
            //        case .photos(_):
            //            return "photos"
            //        case .photoImage(let imageUrl):
            //            return "\(imageUrl)"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .contacts:
            return .get
        case .addUser(login: _, password: _):
            return .post
        }
    }
        
        var task: HTTPTask {
            switch self {
            case .addUser(let name, let password):
                return .requestParameters(bodyParameters: ["title": "\(name)", "body": "\(password)", "userId": "1"],
                                          bodyEncoding: .jsonEncoding,
                                          urlParameters: nil)
                //        case .photos(let albumId):
                //            return .requestParameters(bodyParameters: nil,
                //                                      bodyEncoding: .urlEncoding,
            //                                      urlParameters: ["albumId": albumId])
            default:
                return .request
            }
        }
        
        var headers: HTTPHeaders? {
            return nil
        }
}
