//
//  StudentModel.swift
//  Calendar demo
//
//  Created by Максим Окунеев on 4/21/20.
//  Copyright © 2020 Максим Окунеев. All rights reserved.
//

import Foundation

struct StudentModel: Decodable {
    let studentId: Int?
    let name: String?
    let surname: String?
    var disciplines: [String]?
    let phone: String?
    let email: String?
    let note: String?
}
