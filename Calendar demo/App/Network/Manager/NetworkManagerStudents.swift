//
//  NetworkManagerMainData.swift
//  Calendar demo
//
//  Created by Максим Окунеев on 5/14/20.
//  Copyright © 2020 Максим Окунеев. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

struct NetworkManagerStudents {
    static let environment : NetworkEnvironment = .production
    private let router = Router<StudentsApi>()


    func fetchStudentsList(completion: @escaping (_ contacts: [StudentModel]?,_ error: String?)->()){
        router.request(.students) { data, response, error in
            
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
                        let apiResponse = try JSONDecoder().decode([StudentModel].self, from: responseData)
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
    
    func fetchStudent(studentId: Int, completion: @escaping (_ contacts: StudentModel?,_ error: String?)->()){
        router.request(.showStudent(studentId: studentId)) { data, response, error in
            
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
                        let apiResponse = try JSONDecoder().decode(StudentModel.self, from: responseData)
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
    
    func addStudent(studentId: Int,
                    name: String,
                    surname: String,
                    disciplines: [String],
                    phone: String,
                    email: String,
                    note: String,
                    completion: @escaping (_ message: ServerAnswerModel?,_ error: String?)->()){
        router.request(.addStudent( studentId: studentId,
                                    name: name,
                                    surname: surname,
                                    disciplines: disciplines,
                                    phone: phone,
                                    email: email,
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
    
    func changeStudent(studentId: Int,
                    name: String,
                    surname: String,
                    disciplines: [String],
                    phone: String,
                    email: String,
                    note: String,
                    completion: @escaping (_ message: ServerAnswerModel?,_ error: String?)->()){
        router.request(.changeStudent( studentId: studentId,
                                    name: name,
                                    surname: surname,
                                    disciplines: disciplines,
                                    phone: phone,
                                    email: email,
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

        
        func deleteStudent(studentId: Int, completion: @escaping (_ message: ServerAnswerModel?,_ error: String?)->()){
                router.request(.deleteStudent(studentId: studentId)) { data, response, error in
            
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
