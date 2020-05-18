//
//  StudentModel.swift
//  Calendar demo
//
//  Created by Максим Окунеев on 4/21/20.
//  Copyright © 2020 Максим Окунеев. All rights reserved.
//

import Foundation

struct Student: Decodable {
    let studentId: String
    let name: String?
    let surname: String?
    let phone: String?
    let email: String?
    let currentDiscipline: String?
    let disciplines: [String?]
    let note: String?
}



