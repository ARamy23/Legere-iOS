//
//  NotOptional.swift
//
//  Created by Ahmed Meguid on 12/5/18.
//  Copyright © 2018 Ahmed Meguid. All rights reserved.
//

import Foundation

final class NotOptional: BaseValidator {
    
    var value: Any?
    var key: String
    
    init(value: Any?, key: String) {
        self.value = value
        self.key = key
    }
    
    func orThrow() throws {
        
        if let _ = value {
            return
        }
        throw ValidationError.emptyValue(key: key)
    }
}
