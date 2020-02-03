//
//  String+JADCategory.swift
//  JADCommonTools
//
//  Created by iOS on 2020/1/2.
//  Copyright © 2020 LiXuan. All rights reserved.
//

import Foundation

enum JADTimestampLevel: Double {
    case second = 1.0 //秒
    case ms = 1000.0 //毫秒
}

///Substring
extension String {
    
    ///下标截取字符串 start + lenght = end
    ///example  let string = "abcdefg";     string[1,4];     log "bcd"
    subscript (_ start: Int,_ end: Int) -> Substring {
        let sIndex = self.index(self.startIndex, offsetBy: start)
        let eIndex = self.index(self.startIndex, offsetBy: end)
        return self[sIndex ..< eIndex]
    }
    ///prefix:从start向后截取      suffix:从end位置向前截取
    ///此方法提供范围内截取 同上面下标截取
    func subString(range: Range<Int>) -> Substring {
        let sIndex = self.index(self.startIndex, offsetBy: range.lowerBound)
        let eIndex = self.index(self.startIndex, offsetBy: range.upperBound)
        return self[sIndex ..< eIndex]
    }
}

extension String {
    
    ///时间戳
    func timeFormatterWithTimestamp(dateFormatter: String, level: JADTimestampLevel? = .ms) -> String {
        let timestamp: Double = Double(self)!
        let timeInterval: TimeInterval = TimeInterval(timestamp / (level?.rawValue ?? 1000.0))
        let date = NSDate(timeIntervalSince1970: timeInterval)
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormatter
        return formatter.string(from: date as Date)
    }
    
    ///base64加密
    func base64EncodedString() -> String? {
        if let data = self.data(using: String.Encoding.utf8) {
            return data.base64EncodedString(options: NSData.Base64EncodingOptions.init(rawValue: 0))
        }
        return nil
    }
    /// base64解码
    func base64DencodedString() -> String? {
        var string = self
        let remainder = string.count % 4
        if remainder > 0 {
            string = string.padding(toLength: string.count + 4 - remainder,
                                            withPad: "=",
                                            startingAt: 0)
        }
        if let data = Data(base64Encoded: string, options: .ignoreUnknownCharacters) {
            return String(data: data, encoding: .utf8)
        }
        return nil
    }
}
