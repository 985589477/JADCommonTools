//
//  JADHttpError.swift
//  JADTransfer
//
//  Created by iOS on 2019/8/28.
//  Copyright © 2019 Jason. All rights reserved.
//

import Foundation

protocol JADHTTPErorProtocol {
    var errorCode: JADHTTPErrorCode { get }
    var accordErrorType: JADHTTPAccordingErrorType { get }
    var errorMessage: String? { get }
}

class JADHTTPError: JADHTTPErorProtocol {
    var errorCode: JADHTTPErrorCode
    var accordErrorType: JADHTTPAccordingErrorType = .none
    var errorMessage: String?
    private var message: String?
    
    init?(_ error: Error?) {
        self.errorCode = JADHTTPErrorCode.systemErrorCode
        self.accordErrorType = self.getAccordErrorType()
        self.errorMessage = self.getErrorMessage()
    }
    
    init?(_ status: Int?,_ message: String?) {
        if status == 1 {  return nil  }
        self.message = message
        self.errorCode = JADHTTPErrorCode.init(rawValue: status ?? 0) ?? JADHTTPErrorCode.responseFailure
        self.accordErrorType = self.getAccordErrorType()
        self.errorMessage = self.getErrorMessage()
        self.catchError(errorCode)
    }
    
    private func getErrorMessage() -> String {
        switch self.errorCode {
        case .responseFailure:
            return self.message ?? ""
        default:
            return JADLanguage.key("system_serviceException")
        }
    }
    
    private func getAccordErrorType() -> JADHTTPAccordingErrorType {
        return .tips //目前都是需要提示的
    }
    
}
// status为1 是 成功
enum JADHTTPErrorCode: Int {
    case responseFailure = 0  //业务验证失败
    case responseServiceException = 2 //服务器异常 http 500
    case responseTimeout = -1 //登陆超时
    case responseVersionUpdate_strong = -2 //版本强制更新
    case responseSignFailure = -3 //签名失败
    case responseUnService = -4 //该服务已被禁用 http 503
    case responseServiceFrequent = -5 //请求过于频繁 http 502
    case responseVersionUpdate_weak = -6 // 有更新，但是不强制更新，只提示
    
    case systemErrorCode = -10001 //系统错误code
}

enum JADHTTPAccordingErrorType: Int {
    case none = 0 //什么都不做
    case tips //只提示
    case errerPage //进入对应的错误页面
}


extension JADHTTPError {
    func catchError(_ error: JADHTTPErrorCode) {
        if error == .responseTimeout {
//            JADStorage.shared.clearAllUserDefaultsData()
        }
    }
}
