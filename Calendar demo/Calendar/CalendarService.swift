//
//  CalendarService.swift
//  Calendar demo
//
//  Created by Максим Окунеев on 4/24/20.
//  Copyright © 2020 Максим Окунеев. All rights reserved.
//

import Foundation
import Moya

enum CalendarService {
    case createMeeting(teacherId: Int, startDate: String, endDate: String)
    case readMeeting
    case updateMeeting(teacherId: Int, startDate: String, endDate: String)
    case deleteMeeting(teacherId: Int)
}

extension CalendarService: TargetType {
    var baseURL: URL {
        return URL(string: "http://5.63.154.6/api/lesson?key=0194f13efb8487de1fc1b99edb5f598d&date_start=2020-04-01&date_end=2020-04-30&teacher_id=5")!
    }
    
    var path: String {
        switch self {
        case .readMeeting, .createMeeting(_,_,_):
            return ""
        case .updateMeeting(let id, _, _), .deleteMeeting(let id):
            return "/users/\(id)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .createMeeting(_, _, _):
            return .post
        case . readMeeting:
            return .get
        case .updateMeeting(_, _, _):
            return .put
        case .deleteMeeting(_):
            return .delete
        }
    }
    
    var sampleData: Data {
        switch self {
        case .createMeeting(let teacherId, let startDate, let endDate):
            return "{'teacher_id': \(teacherId), 'date_start':'\(startDate)','date_end':'\(endDate)'}".data(using: .utf8)!
        case .readMeeting:
            return Data()
        case .updateMeeting(let id, let startDate, let endDate):
            return "{'teacher_id':'\(id)', 'date_start':'\(startDate)', 'date_end':'\(endDate)'}".data(using: .utf8)!
        case .deleteMeeting(let id):
            return "{'teacher_id':'\(id)'}".data(using: .utf8)!
        }
    }
    
    var task: Task {
        switch self {
        case .readMeeting, .deleteMeeting(_):
            return .requestPlain
        case .createMeeting(let teacherId, let startDate, let endDate):
            return .requestParameters(parameters: ["teacherId" : teacherId, "date_start" : startDate, "date_end": endDate], encoding: JSONEncoding.default)
        case .updateMeeting(let id, let startDate, let endDate):
            return .requestParameters(parameters: ["teacher_id" : id, "date_start": startDate, "date_end": endDate], encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String : String]? {
            return ["Cookie" : "__cfduid=d38bf4696d0aaeaf921bb39f3b576ce9e1587634381"]
    }
}
