//
//  IsValidPassowrd.swift
//
//  Created by Ahmed Meguid on 12/5/18.
//  Copyright © 2018 Ahmed Meguid. All rights reserved.
//

import Foundation

final public class IsValidPassword: BaseValidator {
    
    var value: String?
    var confirmValue: String?
    
    init(value: String?, confirmValue: String? = nil) {
        self.value = value
        self.confirmValue = confirmValue
    }
    
    public func orThrow() throws {
        if let value = value {
            if value.count < 6 {
                throw ValidationError.notValid(reason: .passwordTooShort)
            } else if let confirmValue = confirmValue, value != confirmValue {
                throw ValidationError.notValid(reason: .passwordsNotMatching)
            }
        }
    }
}