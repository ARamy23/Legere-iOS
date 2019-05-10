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
    case genericError
    case notFound
    case notValid(reason: NotValidReason)
    case emptyValue(key: String)
    case notMatch(key: String)
    
    var message: String {
        switch self {
        case .unreachable: return "No Internet Connection, Please try again later"
        case .notFound: return "We couldn't find that"
        case .notValid(let reason):
            return reason.rawValue
        case .notMatch(key: let key): return "The \(key)s doesn't match each others"
        case .serverIsDown: return "Server is currently down, Please try again later"
        case .genericError: return "Oops... Something went wrong"
        case .emptyValue(key: let key): return "Please fill in the \(key) value"
        }
    }
    
    enum NotValidReason: String {
        case passwordTooShort = "Password can not be less than 6 characters."
        case passwordsNotMatching = "Passwords do not match each other, please double check and try again."
        case nameContainsNumbers = "Names doesn't contain numbers now, do they? 🤔"
        case nameContainsEmojis = "No you can't have emojis in your name 🌚"
        case usernameContainsSpaces = "Usernames can't contain spaces"
    }
}

extension ValidationError: LocalizedError {
    public var errorDescription: String? {
        return self.message
    }
}
