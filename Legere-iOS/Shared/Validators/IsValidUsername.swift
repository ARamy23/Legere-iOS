//
//  IsValidEmail.swift
//
//  Created by Ahmed Meguid on 12/5/18.
//  Copyright © 2018 Ahmed Meguid. All rights reserved.
//

import Foundation

final class IsValidUsername: BaseValidator {
    
    var value: String?
    
    init(value: String?) {
        self.value = value
    }
    
    func orThrow() throws {
        if let value = value, value.contains(" ") {
            throw ValidationError.notValid(reason: "Usernames can't contain spaces")
        }
    }
    
    func isValid(username: String) -> Bool {
        return (username.isAlphabetic || username.isAlphaNumeric) && !username.contains(" ")
    }
}
