//
//  JADStorage.swift
//  JADCommonTools
//
//  Created by iOS on 2020/1/2.
//  Copyright © 2020 LiXuan. All rights reserved.
//

import Foundation

final class JADStorageKey<T>: JADStorageKeys { }

class JADStorageKeys: RawRepresentable, Hashable {
    let rawValue: String
    
    required init!(rawValue: String) {
        self.rawValue = rawValue
    }
    
    convenience init(_ key: String) {
        self.init(rawValue: key)
    }
    
    var hashValue: Int {
        return rawValue.hashValue
    }
}

extension JADStorage {
    subscript(key: JADStorageKey<Any>) -> Any? {
        get { return defaults.object(forKey: key.rawValue) }
        set { defaults.set(newValue, forKey: key.rawValue) }
    }
    
    subscript(key: JADStorageKey<URL>) -> URL? {
        get { return defaults.url(forKey: key.rawValue) }
        set { defaults.set(newValue, forKey: key.rawValue) }
    }
    
    subscript(key: JADStorageKey<[Any]>) -> [Any]? {
        get { return defaults.array(forKey: key.rawValue) }
        set { defaults.set(newValue, forKey: key.rawValue) }
    }
    
    subscript(key: JADStorageKey<[String: Any]>) -> [String: Any]? {
        get { return defaults.dictionary(forKey: key.rawValue) }
        set { defaults.set(newValue, forKey: key.rawValue) }
    }
    
    subscript(key: JADStorageKey<String>) -> String? {
        get { return defaults.string(forKey: key.rawValue) }
        set { defaults.set(newValue, forKey: key.rawValue) }
    }
    
    subscript(key: JADStorageKey<[String]>) -> [String]? {
        get { return defaults.stringArray(forKey: key.rawValue) }
        set { defaults.set(newValue, forKey: key.rawValue) }
    }
    
    subscript(key: JADStorageKey<Data>) -> Data? {
        get { return defaults.data(forKey: key.rawValue) }
        set { defaults.set(newValue, forKey: key.rawValue) }
    }
    
    subscript(key: JADStorageKey<Bool>) -> Bool {
        get { return defaults.bool(forKey: key.rawValue) }
        set { defaults.set(newValue, forKey: key.rawValue) }
    }
    
    subscript(key: JADStorageKey<Int>) -> Int {
        get { return defaults.integer(forKey: key.rawValue) }
        set { defaults.set(newValue, forKey: key.rawValue) }
    }
    
    subscript(key: JADStorageKey<Float>) -> Float {
        get { return defaults.float(forKey: key.rawValue) }
        set { defaults.set(newValue, forKey: key.rawValue) }
    }
    
    subscript(key: JADStorageKey<Double>) -> Double {
        get { return defaults.double(forKey: key.rawValue) }
        set { defaults.set(newValue, forKey: key.rawValue) }
    }
}

class JADStorage: NSObject {
    
    static let shared = JADStorage()
    
    let defaults = UserDefaults.standard
    
    private override init() {
        super.init()
        registerDefaultPreferences()
    }
    
    private func registerDefaultPreferences() {
        let defaultValues: [String: Any] = defaultPreferences.reduce([:]) {
            var dictionary = $0
            dictionary[$1.key.rawValue] = $1.value
            return dictionary
        }
        defaults.register(defaults: defaultValues)
    }
    
    //初始化
    let defaultPreferences: [JADStorageKeys: Any] = [:]
    
    //清除数据
    func clearAllUserDefaultsData(){
        _ = defaults.dictionaryRepresentation()
        defaults.synchronize()
    }
    
}
