//
//  NetworkManagerStatistic.swift
//  Calendar demo
//
//  Created by Максим Окунеев on 6/17/20.
//  Copyright © 2020 Максим Окунеев. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

struct NetworkManagerStatistic {
    static let environment : NetworkEnvironment = .production
    private let router = Router<StatisticApi>()
    
    
    func fetchStatistic(startDate: String,
                       endDate: String,
                       completion: @escaping (_ contacts: StatisticModel?,_ error: String?)->()){
        router.request(.statistic(startDate: startDate, endDate: endDate)) { data, response, error in
            
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
                        let apiResponse = try JSONDecoder().decode(StatisticModel.self, from: responseData)
//
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
        case 403: return .success(NetworkResponse.incorrectAPI.rawValue)
        case 404...500: return .failure(NetworkResponse.dataNotFound.rawValue)
        case 501...599: return .failure(NetworkResponse.badRequest.rawValue)
        case 600: return .failure(NetworkResponse.outdated.rawValue)
        default: return .failure(NetworkResponse.failed.rawValue)
        }
    }
}
