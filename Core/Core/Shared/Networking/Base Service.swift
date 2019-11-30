//
//  Base Service.swift
//  Legere-iOS
//
//  Created by Ahmed Ramy on 5/4/19.
//  Copyright © 2019 Ahmed Ramy. All rights reserved.
//

import Moya

public protocol BaseTargetType: TargetType { }

public extension BaseTargetType {
    var baseURL: URL {
        return URL(string: "http://localhost:8080")!
    }
    
    var headers: [String: String]? {
        var headers: [String: String] = ["Content-type": "application/json"]
        if let token = UserDefaultsManager.getObject(Token.self, key: .token)?.token {
            headers["Authorization"] = "Bearer \(token)"
        }
        return headers
    }
    
    var sampleData: Data {
        return Data()
    }
}

// MARK: - Helper
public extension String {
    var urlEscaped: String {
        return addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
    
    var utf8Encoded: Data {
        return data(using: .utf8)!
    }
}

