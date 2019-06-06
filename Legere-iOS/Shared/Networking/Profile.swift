//
//  Profile.swift
//  Legere-iOS
//
//  Created by Ahmed Ramy on 6/6/19.
//  Copyright © 2019 Ahmed Ramy. All rights reserved.
//

import Moya

enum ProfileService {
    case uploadProfilePicture(base64String: String)
}

extension ProfileService: BaseTargetType {
    var path: String {
        switch self {
        case .uploadProfilePicture:
            return "/api/users/\(UserDefaultsManager.getObject(User.self, key: .user)!.id!)/profile"
        }
    }
    
    var method: Method {
        switch self {
        case .uploadProfilePicture:
            return .put
        }
    }
    
    var task: Task {
        switch self {
        case .uploadProfilePicture(base64String: let string):
            return .requestParameters(parameters: ["profilePicture": string], encoding: JSONEncoding.default)
        }
    }
}
