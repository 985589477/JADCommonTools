//
//  UIColor+JADCategory.swift
//  JADCommonTools
//
//  Created by iOS on 2019/12/31.
//  Copyright © 2019 LiXuan. All rights reserved.
//

import UIKit

typealias JADColorAdapter = (UITraitCollection?) -> UIColor

extension UIColor {
    class func adapterColor(_ dynamicProvider: @escaping JADColorAdapter) -> UIColor {
        if #available(iOS 13.0, *) {
            return UIColor(dynamicProvider: dynamicProvider)
        } else {
            return dynamicProvider(nil)
        }
    }
    
    class func hex(_ hexString: String) -> UIColor {
        return self.hex(hexString, 1)
    }
    
    class func hex(_ hex: CUnsignedLongLong) -> UIColor {
        return self.hex(hex, 1)
    }
    
    class func hex(_ hexString: String,_ alpha: CGFloat) -> UIColor {
        var hex: String = hexString
        if hexString.hasPrefix("#") {
            let index = hexString.index(hexString.startIndex, offsetBy: 1)
            hex = String(hexString[index...])
        }
        let scanner = Scanner(string: hex)
        var hexValue: CUnsignedLongLong = 0
        scanner.scanHexInt64(&hexValue)
        return self.hex(hexValue, alpha)
    }
    
    class func hex(_ hex: CUnsignedLongLong,_ alpha: CGFloat) -> UIColor {
        let red: CGFloat = CGFloat((hex & 0xff0000) >> 16)
        let green: CGFloat = CGFloat((hex & 0x00ff00) >> 8)
        let blue: CGFloat = CGFloat((hex & 0x0000ff))
        return UIColor(red: red / 255.0, green: green / 255.0, blue: blue / 255.0, alpha: alpha)
    }
    
}
