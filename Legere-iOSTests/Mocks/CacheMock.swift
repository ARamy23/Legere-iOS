//
//  CacheMock.swift
//  Legere-iOSTests
//
//  Created by Ahmed Ramy on 5/7/19.
//  Copyright © 2019 Ahmed Ramy. All rights reserved.
//

import Foundation

@testable import Legere_iOS

class CacheMock: CacheProtocol {
    func getObject<T>(_ object: T.Type, key: CachingKey) -> T? where T : Decodable, T : Encodable {
        return dataStorage[key] as? T
    }
    
    func getData(key: CachingKey) -> [Data]? {
        return (dataStorage[key] as? Data).map({[$0]})
    }
    
    func saveData(_ data: Data?, key: CachingKey) {
        dataStorage[key] = data
    }
    
    var dataStorage: [CachingKey: Any] = [:]
    
    func getObject<T>(_ object: T, key: CachingKey) -> T? {
        return dataStorage[key] as? T
    }
    
    func saveObject<T>(_ object: T, key: CachingKey) {
        dataStorage[key] = object
    }
    
    func removeObject(key: CachingKey) {
        dataStorage.removeValue(forKey: key)
    }
}
