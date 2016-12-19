//
//  PasswordValidator.swift
//  StrategyPatternDemo
//
//  Created by ZHOU DENGFENG on 19/12/16.
//  Copyright © 2016 ZHOU DENGFENG DEREK. All rights reserved.
//

import Foundation

class PasswordValidator: Validator {
    func isValid(text: String?) -> Bool {
        let regEx = "[A-Z0-9a-z._%+-;/><#]{6,30}"
        if let text = text {
            let entryTest = NSPredicate(format: "SELF MATCHES %@", regEx)
            return entryTest.evaluate(with: text)
        }
        return false
    }
}
