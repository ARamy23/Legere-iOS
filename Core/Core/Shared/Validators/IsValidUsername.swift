//
//  IsValidEmail.swift
//
//  Created by Ahmed Meguid on 12/5/18.
//  Copyright © 2018 Ahmed Meguid. All rights reserved.
//

import Foundation

final public class IsValidUsername: BaseValidator {
    
    var value: String?
    
    init(value: String?) {
        self.value = value
    }
    
    public func orThrow() throws {
        if let value = value, value.contains(" ") {
            throw ValidationError.notValid(reason: .usernameContainsSpaces)
        }
    }
    
    public func isValid(username: String) -> Bool {
        return (username.isAlphabetic || username.isAlphaNumeric) && !username.contains(" ")
    }
}
