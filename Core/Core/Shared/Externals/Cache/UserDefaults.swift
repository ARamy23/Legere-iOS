//
//  UserDefaults.swift
//
//  Created by Ahmed Meguid on 12/4/18.
//  Copyright © 2018 Ahmed Meguid. All rights reserved.
//

import Foundation

final public class UserDefaultsManager: CacheProtocol {
    
    static public func getObject<T>(_ object: T.Type, key: CachingKey) -> T? where T : Decodable, T : Encodable {
        return getData(key: key)?[0].decode(object)
    }
    
    static public func getData(key: CachingKey) -> [Data]? {
        return UserDefaults.standard.data(forKey: key.rawValue).map({[$0]})
    }
    
    public func getObject<T>(_ object: T.Type, key: CachingKey) -> T? where T : Decodable, T : Encodable {
        if object is String.Type {
            return getString(key: key) as? T
        } else {
            return getData(key: key)?[0].decode(object)
        }
    }
    
    public func saveObject<T>(_ object: T, key: CachingKey) where T : Decodable, T : Encodable {
        if object is String {
            saveString(object as! String, key: key)
        } else {
            saveData(object.encode(), key: key)
        }
    }
    
    private func getString(key: CachingKey) -> String? {
        return UserDefaults.standard.string(forKey: key.rawValue)
    }
    
    public func getData(key: CachingKey) -> [Data]? {
        return UserDefaults.standard.data(forKey: key.rawValue).map({[$0]})
    }
    
    private func saveString(_ object: String, key: CachingKey) {
        UserDefaults.standard.set(object, forKey: key.rawValue)
    }
    
    public func saveData(_ data: Data?, key: CachingKey) {
        UserDefaults.standard.set(data, forKey: key.rawValue)
    }
    
    public func removeObject(key: CachingKey) {
        UserDefaults.standard.removeObject(forKey: key.rawValue)
    }
}
