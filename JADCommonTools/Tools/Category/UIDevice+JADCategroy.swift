//
//  UIDevice+categroy.swift
//  MKTransfer
//
//  Created by iOS on 2019/10/8.
//  Copyright © 2019 Jason. All rights reserved.
//

import UIKit

extension UIDevice {
    
    static func platformString() -> String {  
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { (identifier, element) in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }

        if identifier == "iPhone1,1"    { return "iPhone 1G" }
        if identifier == "iPhone1,2"    { return "iPhone 3G" }
        if identifier == "iPhone2,1"    { return "iPhone 3GS" }
        if identifier == "iPhone3,1"    { return "iPhone 4 (GSM)" }
        if identifier == "iPhone3,3"    { return "iPhone 4 (CDMA)" }
        if identifier == "iPhone4,1"    { return "iPhone 4S" }
        if identifier == "iPhone5,1"    { return "iPhone 5 (GSM)" }
        if identifier == "iPhone5,2"    { return "iPhone 5 (CDMA)" }
        if identifier == "iPhone5,3"    { return "iPhone 5c" }
        if identifier == "iPhone5,4"    { return "iPhone 5c" }
        if identifier == "iPhone6,1"    { return "iPhone 5s" }
        if identifier == "iPhone6,2"    { return "iPhone 5s" }
        if identifier == "iPhone7,1"    { return "iPhone 6 Plus" }
        if identifier == "iPhone7,2"    { return "iPhone 6" }
        if identifier == "iPhone8,1"    { return "iPhone 6s" }
        if identifier == "iPhone8,2"    { return "iPhone 6s Plus" }
        if identifier == "iPhone8,4"    { return "iPhone SE" }
        if identifier == "iPhone9,1"    { return "iPhone 7" }
        if identifier == "iPhone9,2"    { return "iPhone 7 Plus" }
        if identifier == "iPhone9,3"    { return "iPhone 7" }
        if identifier == "iPhone9,4"    { return "iPhone 7 Plus" }
        if identifier == "iPhone10,1"   { return "iPhone 8" }
        if identifier == "iPhone10,4"   { return "iPhone 8" }
        if identifier == "iPhone10,2"   { return "iPhone 8 Plus" }
        if identifier == "iPhone10,5"   { return "iPhone 8 Plus" }
        if identifier == "iPhone10,3"   { return "iPhone X" }
        if identifier == "iPhone10,6"   { return "iPhone X" }
        if identifier == "iPhone11,2"   { return "iPhone XS" }
        if identifier == "iPhone11,4"   { return "iPhone XS Max" }
        if identifier == "iPhone11,6"   { return "iPhone XS Max CN" }
        if identifier == "iPhone11,8"   { return "iPhone XR" }
        if identifier == "iPhone12,1"   { return "iPhone 11" }
        if identifier == "iPhone12,3"   { return "iPhone 11 Pro" }
        if identifier == "iPhone12,5"   { return "iPhone 11 Pro Max" }
        
        
        if identifier == "iPod1,1"      { return "iPod Touch 1G" }
        if identifier == "iPod2,1"      { return "iPod Touch 2G" }
        if identifier == "iPod3,1"      { return "iPod Touch 3G" }
        if identifier == "iPod4,1"      { return "iPod Touch 4G" }
        if identifier == "iPod5,1"      { return "iPod Touch 5G" }
        if identifier == "iPod7,1"      { return "iPod Touch 6G" }
        if identifier == "iPod9,1"      { return "iPod Touch 7G" }
        
        
        if identifier == "iPad1,1"      { return "iPad" }
        if identifier == "iPad2,1"      { return "iPad 2 (WiFi)" }
        if identifier == "iPad2,2"      { return "iPad 2 (GSM)" }
        if identifier == "iPad2,3"      { return "iPad 2 (CDMA)" }
        if identifier == "iPad2,4"      { return "iPad 2 (WiFi)" }
        if identifier == "iPad2,5"      { return "iPad Mini (WiFi)" }
        if identifier == "iPad2,6"      { return "iPad Mini (GSM)" }
        if identifier == "iPad2,7"      { return "iPad Mini (CDMA)" }
        if identifier == "iPad3,1"      { return "iPad 3 (WiFi)" }
        if identifier == "iPad3,2"      { return "iPad 3 (CDMA)" }
        if identifier == "iPad3,3"      { return "iPad 3 (GSM)" }
        if identifier == "iPad3,4"      { return "iPad 4 (WiFi)" }
        if identifier == "iPad3,5"      { return "iPad 4 (GSM)" }
        if identifier == "iPad3,6"      { return "iPad 4 (CDMA)" }
        if identifier == "iPad4,1"      { return "iPad Air (WiFi)" }
        if identifier == "iPad4,2"      { return "iPad Air (GSM)" }
        if identifier == "iPad4,3"      { return "iPad Air (CDMA)" }
        if identifier == "iPad4,4"      { return "iPad Mini Retina (WiFi)" }
        if identifier == "iPad4,5"      { return "iPad Mini Retina (Cellular)" }
        if identifier == "iPad4,7"      { return "iPad Mini 3 (WiFi)" }
        if identifier == "iPad4,8"      { return "iPad Mini 3 (Cellular)" }
        if identifier == "iPad4,9"      { return "iPad Mini 3 (Cellular)" }
        if identifier == "iPad5,1"      { return "iPad Mini 4 (WiFi)" }
        if identifier == "iPad5,2"      { return "iPad Mini 4 (Cellular)" }
        if identifier == "iPad5,3"      { return "iPad Air 2 (WiFi)" }
        if identifier == "iPad5,4"      { return "iPad Air 2 (Cellular)" }
        if identifier == "iPad6,3"      { return "iPad Pro 9.7-inch (WiFi)" }
        if identifier == "iPad6,4"      { return "iPad Pro 9.7-inch (Cellular)" }
        if identifier == "iPad6,7"      { return "iPad Pro 12.9-inch (WiFi)" }
        if identifier == "iPad6,8"      { return "iPad Pro 12.9-inch (Cellular)" }
        if identifier == "iPad6,11"     { return "iPad 5 (WiFi)" }
        if identifier == "iPad6,12"     { return "iPad 5 (Cellular)" }
        if identifier == "iPad7,1"      { return "iPad Pro 12.9-inch (WiFi)" }
        if identifier == "iPad7,2"      { return "iPad Pro 12.9-inch (Cellular)" }
        if identifier == "iPad7,3"      { return "iPad Pro 10.5-inch (WiFi)" }
        if identifier == "iPad7,4"      { return "iPad Pro 10.5-inch (Cellular)" }
        if identifier == "iPad7,5"      { return "iPad 6 (WiFi)" }
        if identifier == "iPad7,6"      { return "iPad 6 (Cellular)" }
        if identifier == "iPad8,1"      { return "iPad Pro 3rd Gen 11-inch (WiFi)" }
        if identifier == "iPad8,2"      { return "iPad Pro 3rd Gen 11-inch (WiFi)" } // 1TB
        if identifier == "iPad8,3"      { return "iPad Pro 3rd Gen 11-inch (Cellular)" }
        if identifier == "iPad8,4"      { return "iPad Pro 3rd Gen 11-inch (Cellular)" } // 1TB
        if identifier == "iPad8,5"      { return "iPad Pro 3rd Gen 12.9-inch (WiFi)" }
        if identifier == "iPad8,6"      { return "iPad Pro 3rd Gen 12.9-inch (WiFi)" } // 1TB
        if identifier == "iPad8,7"      { return "iPad Pro 3rd Gen 12.9-inch (Cellular)" }
        if identifier == "iPad8,8"      { return "iPad Pro 3rd Gen 12.9-inch (Cellular)" } // 1TB
        if identifier == "iPad11,1"      { return "iPad Mini 5 (WiFi)" }
        if identifier == "iPad11,2"      { return "iPad Mini 5" }
        if identifier == "iPad11,3"      { return "iPad Air 3 (WiFi)" }
        if identifier == "iPad11,4"      { return "iPad Air 3" }
        
        if identifier == "i386"         { return UIDevice.current.model }
        if identifier == "x86_64"       { return UIDevice.current.model }
        
        return ""
        
    }
    
}
