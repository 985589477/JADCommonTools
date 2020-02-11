//
//  JADStorage.swift
//  JADCommonTools
//
//  Created by iOS on 2020/1/2.
//  Copyright © 2020 LiXuan. All rights reserved.
//

import Foundation

class JADStorage {

    //示例
//    @JADStorageConfiguration(key: "key", defaultValue: "value")
//    var key: String?
    
    
    static let shared = JADStorage()

    //清除数据
    func clearAllUserDefaultsData(){
        UserDefaults.standard.dictionaryRepresentation()
        UserDefaults.standard.synchronize()
    }
}

@propertyWrapper
class JADStorageConfiguration<T> {

    var wrappedValue: T? {
        set { UserDefaults.standard.set(newValue, forKey: key)}
        get { return UserDefaults.standard.value(forKey: key) as? T ?? defaultValue}
    }
    
    private var key: String
    private var defaultValue: T
    
    init(key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }
}

