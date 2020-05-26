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
    let id: Int?
    let user: User?
    let token: String?
    let error: ServerAuthorizationError?
}

struct User: Decodable {
    let email: String?
    let password: String?
    let confirmPassword: String?
}

struct ServerAuthorizationError: Decodable {
    let email: String?
    let password: String?
    let confirmPassword: String?
    let active: Bool?
}

