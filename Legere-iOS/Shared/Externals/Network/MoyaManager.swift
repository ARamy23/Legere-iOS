//
//  MoyaManager.swift
//  Legere-iOS
//
//  Created by Ahmed Ramy on 5/4/19.
//  Copyright © 2019 Ahmed Ramy. All rights reserved.
//

import Foundation
import Moya
import Promises

class MoyaManager: NetworkProtocol {
    static var ongoingRequests = [Cancellable]()
    
    func callModel<T, U>(model: T.Type, api: U) -> Promise<T> where T : Decodable, T : Encodable, U : BaseTargetType {
        return Promise<T> { fullfil, reject in
            let provider = MoyaProvider<U>()
            provider.request(api) { (result) in
                switch result {
                case .success(let response):
                    do {
                        if let error = try? response.map(NetworkErrorResponse.self), error.reason != nil {
                            reject(error.handleError(from: response.statusCode))
                        }
                        let model = try response.map(T.self)
                        fullfil(model)
                    } catch let error {
                        print("=====Error After Network Request====")
                        print(error)
                        print("====================================")
                        reject(error)
                    }
                case .failure(let error):
                    reject(error)
                }
            }
        }
    }
}

enum NetworkError: Error {
    case networkFail(error: String)
    case notAuthorized
    case notFound
    
    var message: String {
        switch self {
        case .networkFail(error: let reason):
            return "Request Failed due to \(reason)"
        case .notAuthorized:
            return "Not Authorized? hmm, Interesting 🧐"
        case .notFound:
            return "Nope, Nothing, Sorry 😅"
        }
    }
}

extension NetworkError: LocalizedError {
    public var errorDescription: String? {
        return self.message
    }
}

struct NetworkErrorResponse: Codable {
    let error: Bool?
    let reason: String?
    
    func handleError(from code: Int) -> NetworkError {
        switch code {
        case 401:
            return .notAuthorized
        case 404:
            return .notFound
        default:
            return .networkFail(error: self.reason ?? "Something went wrong, try again maybe?")
        }
    }
}
