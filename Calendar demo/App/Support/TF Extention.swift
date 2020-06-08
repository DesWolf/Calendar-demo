//
//  String Extention.swift
//  Calendar demo
//
//  Created by Максим Окунеев on 5/26/20.
//  Copyright © 2020 Максим Окунеев. All rights reserved.
//

import UIKit

extension UITextField {
    func changeDoesNotLeadToEmptyString(replacingCharactersIn range: NSRange, with replacementString: String) -> Bool {
        return (!replacementString.isEmpty || range.length < (text ?? "").count)
    }
}
