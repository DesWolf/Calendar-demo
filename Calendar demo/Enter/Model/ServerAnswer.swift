//
//  ServerAnswer.swift
//  Calendar demo
//
//  Created by Максим Окунеев on 5/14/20.
//  Copyright © 2020 Максим Окунеев. All rights reserved.
//

import Foundation

struct ServerAuthorizationAnswer: Decodable {
    let message: String?
    let error: [ErrorType]?
    let teacherId: Int?
    let token: String?
}

struct ErrorType: Decodable {
    let email: String?
    let password: String?
    let confirmPassword: String?
}
