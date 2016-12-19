//
//  ValidationManager.swift
//  StrategyPatternDemo
//
//  Created by ZHOU DENGFENG on 19/12/16.
//  Copyright © 2016 ZHOU DENGFENG DEREK. All rights reserved.
//

import Foundation

enum ValidationType: Int {
    case Email = 0
    case Password
    case State
    case Address
    case PhoneNumber
    case PostalCode
}

class ValidationManager {
    
    var validators: [Validator] = [EmailValidator(), PasswordValidator()]
    
    func validationForText(text: String?, withValidationType validationType: ValidationType) -> Bool {
        return validators[validationType.rawValue].isValid(text: text)
    }
}
