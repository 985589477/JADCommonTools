//
//  Tools.swift
//  JADCommonTools
//
//  Created by iOS on 2019/12/30.
//  Copyright © 2019 LiXuan. All rights reserved.
//

import UIKit

/// 常用的全局定义
class JADTools {

    @available(iOS 13.0, *)
    static var currentWindowScene: UIWindowScene? {
        let scenes = UIApplication.shared.connectedScenes.map({ $0 as? UIWindowScene})
        for scene in scenes {
            if scene?.activationState == .foregroundActive {
                return scene
            }
        }
        return nil
    }
    
    static var keyWindow: UIWindow? {
        if #available(iOS 13.0, *) {
            if let windows = self.currentWindowScene?.windows {
                for window in windows {
                    if window.isKeyWindow {
                        return window
                    }
                }
                return windows.first
            }
            return nil
        }
        return UIApplication.shared.keyWindow
    }
    
    @available(iOS 13.0, *)
    static var statusBarManager: UIStatusBarManager? {
        return currentWindowScene?.statusBarManager
    }
    
    static var version: String {
        guard let info = Bundle.main.infoDictionary else { return "1.0.0" }
        let version = info["CFBundleShortVersionString"] as? String
        return version ?? "1.0.0"
    }

    static var statusBarHeight: CGFloat {
        if #available(iOS 13.0, *) {
            return JADTools.statusBarManager?.statusBarFrame.size.height ?? 0
        }
        return UIApplication.shared.statusBarFrame.size.height
    }

    static var isIphoneX: Bool {
        return (statusBarHeight > 20) && !isPad
    }

    static var isPad: Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }

    //正常情况下安全区高度
    static var safeBottomHeight: CGFloat {
        return (isIphoneX ? 34.0 : 0.0)
    }

    //从底部约束view的时候安全区高度需要适配
    static var safeBottomMarge: CGFloat {
        return (isIphoneX ? 0.0 : 34.0)
    }

    static var navigationBarHeight: CGFloat {
        return 44
    }

    static var tabbarHeight: CGFloat {
        return 49
    }

    static var safeTabbarHeight: CGFloat {
        return self.tabbarHeight + safeBottomHeight
    }

    static var navigationHeight: CGFloat {
        return self.statusBarHeight + self.navigationBarHeight
    }
}

/// 适配不同屏幕的宽度显示
struct ScreenFix {
    enum DeviceType: CGFloat {
        case iphone375 = 375.0
        case iphone414 = 414.0
    }
    static var basicMode = DeviceType.iphone375
    
    var value: CGFloat = 0.0
    var rawValue: NSNumber = NSNumber(value: 0)
    
    //计算适应宽高
    static func scaling(width: CGFloat, height: CGFloat) -> (width: CGFloat , height: CGFloat) {
        let scale = width / height
        return (width, height / scale)
    }

    init(_ value: Int) {
        self.rawValue = NSNumber(value: calculate(value: Double(value)))
        self.value = CGFloat(rawValue.intValue)
    }
    
    init(_ value: Float) {
        self.rawValue = NSNumber(value: calculate(value: Double(value)))
        self.value = CGFloat(rawValue.floatValue)
    }
    
    init(_ value: Double) {
        self.rawValue = NSNumber(value: calculate(value: value))
        self.value = CGFloat(rawValue.doubleValue)
    }
    
    init(_ value: CGFloat) {
        self.rawValue = NSNumber(value: calculate(value: Double(value)))
        self.value = CGFloat(rawValue.doubleValue)
    }
    
    private func calculate(value: Double) -> Double {
        return Double(CGFloat(value) * UIScreen.main.bounds.width / ScreenFix.basicMode.rawValue)
    }
}
