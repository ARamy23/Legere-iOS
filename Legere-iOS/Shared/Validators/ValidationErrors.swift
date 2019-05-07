//
//  ValidationErrors.swift
//  InstaMovies
//
//  Created by Ahmed Ramy on 12/16/18.
//  Copyright © 2018 Ahmed Ramy. All rights reserved.
//

import Foundation

enum ValidationError: Error {
    case unreachable
    case serverIsDown
    case invalidAPIKey
    case genericError
    case emptyValue(key: String)
    
    var message: String {
        switch self {
        case .unreachable: return "No Internet Connection, Please try again later"
        case .invalidAPIKey: return "Invalid API Key"
        case .serverIsDown: return "Server is currently down, Please try again later"
        case .genericError: return "Oops... Something went wrong"
        case .emptyValue(key: let key): return "Please fill in the \(key) value"
        }
    }
}

extension ValidationError: LocalizedError {
    public var errorDescription: String? {
        return self.message
    }
}
