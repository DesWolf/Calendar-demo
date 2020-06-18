//
//  ServerAnsverModel.swift
//  Calendar demo
//
//  Created by Максим Окунеев on 6/17/20.
//  Copyright © 2020 Максим Окунеев. All rights reserved.
//

import Foundation

struct ServerAnswerModel: Decodable {
    let message: String?
    let studentId: String?
    let lessonId: String?
}