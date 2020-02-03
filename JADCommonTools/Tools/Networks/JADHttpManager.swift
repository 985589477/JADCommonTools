//
//  JADHttpManager.swift
//  JADTransfer
//
//  Created by iOS on 2019/8/27.
//  Copyright © 2019 Jason. All rights reserved.
//

import Foundation
import SwiftyJSON

struct JADBaseModel {
    var status: Int?
    var message: String?
    var result: JSON?
    init(_ dictionary: JSON) {
        self.status = dictionary["status"].intValue
        self.message = dictionary["message"].stringValue
        self.result = JSON(dictionary["result"])
    }
}

typealias JADHTTPNoResultClosure = ((_ error: JADHTTPError?) -> Void)?
typealias JADHTTPClosure<T> = ((_ model: T?, _ error: JADHTTPError?) -> Void)?
typealias JADHTTPArrayClosure<T> = ((_ model: [T]?, _ error: JADHTTPError?) -> Void)?
typealias JADHTTPStringClosure = ((_ result: String?, _ error: JADHTTPError?) -> Void)?

class JADHttpManager {
    static let shared = JADHttpManager()
    //处理返回的数据对象
    func handleResponseData(_ responseData: [String: Any]?,_ responseError: Error?) -> (JADBaseModel?, JADHTTPError?) {
        guard let data = responseData else {
            return (nil, JADHTTPError(responseError))
        }
        let baseModel = JADBaseModel(JSON(data))
        return (baseModel, JADHTTPError(baseModel.status, baseModel.message))
    }
}
