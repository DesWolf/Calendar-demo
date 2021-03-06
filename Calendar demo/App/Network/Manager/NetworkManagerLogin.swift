//
//  NetworkManagerLogin.swift
//  Calendar demo
//
//  Created by Максим Окунеев on 5/14/20.
//  Copyright © 2020 Максим Окунеев. All rights reserved.
//

import UIKit

enum NetworkResponse:String {
    case success = "200-299 Sucsess"
    case incorrectAPI = "403 incorrect API"
    case dataError = "400 Send data Error"
    case incorrectToken = "401 Token incorrect"
    case dataNotFound = "404-500 Data not found"
    case badRequest = "501-509 Bad request"
    case outdated = "600 The url you requested is outdated."
    case failed = "Network request failed."
    case noData = "Response returned with no data to decode."
    case unableToDecode = "We could not decode the response."
}

enum Result<String>{
    case success(String)
    case failure(String)
}

struct NetworkManagerLogin {
    static let environment : NetworkEnvironment = .production
    static let TeachOrgAPIKey = "924b4134faa490bc658c3847d96d375c"
    private let router = Router<LoginApi>()
    
    func registerUser(email: String, password: String, confirmPassword: String, completion: @escaping (_ message: ServerAuthorizationAnswer?,_ error: String?)->()){
        router.request(.registerUser(email: email, password: password, confirmPassword: confirmPassword)) { data, response, error in
            if error != nil {
                completion(nil, "Please check your network connection.")
            }
            if let response = response as? HTTPURLResponse {
                let result = self.handleNetworkResponse(response)
                switch result {
                case .success:
                    guard let responseData = data else {
                        completion(nil, NetworkResponse.noData.rawValue)
                        return
                    }
                    do {
                        let apiResponse = try JSONDecoder().decode(ServerAuthorizationAnswer.self, from: responseData)
                        completion(apiResponse,nil)
                    }catch {
                        print(error)
                        completion(nil, NetworkResponse.unableToDecode.rawValue)
                    }
                case .failure(let networkFailureError):
                    completion(nil, networkFailureError)
                }
            }
        }
    }
    
    func loginUser(email: String, password: String, completion: @escaping (_ message: ServerAuthorizationAnswer?,_ error: String?)->()){
        router.request(.loginUser(email: email, password: password)) { data, response, error in
            
            if error != nil {
                completion(nil, "Please check your network connection.")
            }
            
            if let response = response as? HTTPURLResponse {
                let result = self.handleNetworkResponse(response)
                switch result {
                case .success:
                    guard let responseData = data else {
                        completion(nil, NetworkResponse.noData.rawValue)
                        return
                    }
                    do {
                        let apiResponse = try JSONDecoder().decode(ServerAuthorizationAnswer.self, from: responseData)
                        completion(apiResponse,nil)
                    }catch {
                        print(error)
                        completion(nil, NetworkResponse.unableToDecode.rawValue)
                    }
                case .failure(let networkFailureError):
                    completion(nil, networkFailureError)
                }
            }
        }
    }
    fileprivate func handleNetworkResponse(_ response: HTTPURLResponse) -> Result<String>{
        switch response.statusCode {
        case 200...299: return .success(NetworkResponse.success.rawValue)
        case 400: return .success(NetworkResponse.dataError.rawValue)
        case 401: return .success(NetworkResponse.incorrectToken.rawValue)
        case 403: return .success(NetworkResponse.incorrectAPI.rawValue)
        case 404...500: return .failure(NetworkResponse.dataNotFound.rawValue)
        case 501...599: return .failure(NetworkResponse.badRequest.rawValue)
        case 600: return .failure(NetworkResponse.outdated.rawValue)
        default: return .failure(NetworkResponse.failed.rawValue)
        }
    }
}
