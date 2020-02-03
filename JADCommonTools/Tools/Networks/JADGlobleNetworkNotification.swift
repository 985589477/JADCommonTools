//
//  File.swift
//  JADTransfer
//
//  Created by iOS on 2019/8/28.
//  Copyright © 2019 Jason. All rights reserved.
//

import UIKit
import Alamofire

class JADGlobleNetworkNotification {
    static let `default` = JADGlobleNetworkNotification()
    var isNetworkActive: Bool?
    typealias SetClosure = ((Bool) -> Void)
    private var closure: [UInt: SetClosure] = [UInt: SetClosure]()
    
    func register(_ status:NetworkReachabilityManager.NetworkReachabilityStatus) {
        var active = false
        switch status {
        case .notReachable:
            active = false
        default:
            active = true
        }
        if self.isNetworkActive == active {
            return
        }
        self.isNetworkActive = active
        
        for (_ , closure) in self.closure {
            closure(self.isNetworkActive ?? false)
        }
    }
    
    func add(_ observer:AnyObject ,_ closure: SetClosure?) -> Void {
        guard let setClosure = closure else { return }
        let key = unsafeBitCast(observer, to: UInt.self)
        self.closure[key] = setClosure
    }
    
    func remove(_ observer:AnyObject) -> Void {
        let key = unsafeBitCast(observer, to: UInt.self)
        self.closure.removeValue(forKey: key)
    }
}
