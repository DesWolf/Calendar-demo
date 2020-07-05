//
//  NetworkManagerCalendar.swift
//  Calendar demo
//
//  Created by Максим Окунеев on 6/4/20.
//  Copyright © 2020 Максим Окунеев. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

struct NetworkManagerCalendar {
    static let environment : NetworkEnvironment = .production
    private let router = Router<CalendarApi>()
    
    
    func fetchCalendar(startDate: String,
                       endDate: String,
                       completion: @escaping (_ contacts: [LessonModel]?,_ error: String?)->()){
        router.request(.calendar(startDate: startDate, endDate: endDate)) { data, response, error in
            
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
                        let apiResponse = try JSONDecoder().decode([LessonModel].self, from: responseData)
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
    
    func fetchLesson(lessonId: Int, completion: @escaping (_ contacts: LessonModel?,_ error: String?)->()){
        router.request(.showLesson(lessonId: lessonId)) { data, response, error in
            
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
                        let apiResponse = try JSONDecoder().decode(LessonModel.self, from: responseData)
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
    
    func addLesson(name: String,
                   place: String,
                   studentId: Int,
                   discipline: String,
                   startDate: String,
                   endDate: String,
                   repeatedly: String,
                   endRepeat: String,
                   price: Int,
                   note: String,
                   completion: @escaping (_ message: ServerAnswerModel?,_ error: String?)->()){
        router.request(.addLesson(name: name,
                                  place: place,
                                  studentId: studentId,
                                  discipline: discipline,
                                  startDate: startDate,
                                  endDate: endDate,
                                  repeatedly: repeatedly,
                                  endRepeat: endRepeat,
                                  price: price,
                                  note: note))
        { data, response, error in
            
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
                        let apiResponse = try JSONDecoder().decode(ServerAnswerModel.self, from: responseData)
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
    
    func changeLesson(lessonId: Int,
                      name: String,
                      place: String,
                      studentId: Int,
                      discipline: String,
                      startDate: String,
                      endDate: String,
                      repeatedly: String,
                      endRepeat: String,
                      price: Int,
                      note: String,
                      payStatus: Int,
                      paymentDate: String,
        completion: @escaping (_ message: ServerAnswerModel?,_ error: String?)->()){
        router.request(.changeLesson(lessonId: lessonId,
                                     name: name,
                                     place: place,
                                     studentId: studentId,
                                     discipline: discipline,
                                     startDate: startDate,
                                     endDate: endDate,
                                     repeatedly: repeatedly,
                                     endRepeat: endRepeat,
                                     price: price,
                                     note: note,
                                     payStatus: payStatus,
                                     paymentDate: paymentDate))
        { data, response, error in
            
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
                        let apiResponse = try JSONDecoder().decode(ServerAnswerModel.self, from: responseData)
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
    
    func deleteLesson(lessonId: Int, completion: @escaping (_ message: ServerAnswerModel?,_ error: String?)->()){
        router.request(.deleteLesson(lessonId: lessonId)) { data, response, error in
            
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
                        let apiResponse = try JSONDecoder().decode(ServerAnswerModel.self, from: responseData)
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
        case 200...299: return .success
        case 400: return .failure(NetworkResponse.dataError.rawValue)
        case 403: return .failure(NetworkResponse.incorrectAPI.rawValue)
        case 404...500: return .failure(NetworkResponse.dataNotFound.rawValue)
        case 501...599: return .failure(NetworkResponse.badRequest.rawValue)
        case 600: return .failure(NetworkResponse.outdated.rawValue)
        default: return .failure(NetworkResponse.failed.rawValue)
        }
    }
}
