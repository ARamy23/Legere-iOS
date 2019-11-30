//
//  Codable+Helpers.swift
//
//  Created by Ahmed Meguid on 12/5/18.
//  Copyright © 2018 Ahmed Meguid. All rights reserved.
//

import Foundation

public extension Encodable {
    public func asDictionary() -> [String: Any] {
        let serialized = (try? JSONSerialization.jsonObject(with: self.encode(), options: .allowFragments)) ?? nil
        return serialized as? [String: Any] ?? [String: Any]()
    }
    
    public func encode() -> Data {
        return (try? JSONEncoder().encode(self)) ?? Data()
    }
}

public extension Data {
    public func decode<T: Codable>(_ object: T.Type) -> T? {
        return (try? JSONDecoder().decode(T.self, from: self))
    }
}
