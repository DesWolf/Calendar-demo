//
//  StudentModel.swift
//  Calendar demo
//
//  Created by Максим Окунеев on 4/21/20.
//  Copyright © 2020 Максим Окунеев. All rights reserved.
//

import Foundation

struct User: Decodable {
    let id: Int
    let name: String
}

struct Message: Decodable {
    let message: String
}
