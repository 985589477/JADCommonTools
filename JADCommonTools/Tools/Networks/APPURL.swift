//
//  APPURL.swift
//  JADCommonTools
//
//  Created by iOS on 2020/1/2.
//  Copyright © 2020 LiXuan. All rights reserved.
//

import Foundation

enum AppURLType: String {
    case developer = "test"
    case product = "api"
}

class APPURL {
    //单例
    static let main = APPURL()
    
    //存储主URL
    var mainURL: AppURLType?
    
    func setMainUrl(_ type: AppURLType) -> Void {
        self.mainURL = type
    }
    
}
