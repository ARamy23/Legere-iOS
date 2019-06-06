//
//  Profile.swift
//  Legere-iOS
//
//  Created by Ahmed Ramy on 6/6/19.
//  Copyright © 2019 Ahmed Ramy. All rights reserved.
//

import Moya

enum ProfileService {
    case getProfile
    case uploadProfilePicture(base64String: String)
}

extension ProfileService: BaseTargetType {
    var path: String {
        switch self {
        case .getProfile:
            return "/api/users/profile"
        case .uploadProfilePicture:
            return "/api/users/\(UserDefaultsManager.getObject(User.self, key: .user)!.id!)/profilePicture"
        }
    }
    
    var method: Method {
        switch self {
        case .getProfile:
            return .get
        case .uploadProfilePicture:
            return .put
        }
    }
    
    var task: Task {
        switch self {
        case .getProfile:
            return .requestPlain
        case .uploadProfilePicture(base64String: let string):
            return .requestParameters(parameters: ["profilePicture": string], encoding: JSONEncoding.default)
        }
    }
}
