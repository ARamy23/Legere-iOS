//
//  IsValidName.swift
//  Legere-iOS
//
//  Created by Ahmed Ramy on 5/4/19.
//  Copyright © 2019 Ahmed Ramy. All rights reserved.
//

import Foundation

final class IsValidName: BaseValidator {
    
    var value: String?
    
    init(value: String?) {
        self.value = value
    }
    
    func orThrow() throws {
        if let value = value {
            if value.isAlphaNumeric {
                throw ValidationError.notValid(reason: .nameContainsNumbers)
            } else if value.containEmoji {
                throw ValidationError.notValid(reason: .nameContainsEmojis)
            }
        }
    }
}
