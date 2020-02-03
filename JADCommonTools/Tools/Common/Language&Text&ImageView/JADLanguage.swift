//
//  MKLanguage.swift
//  MKTransfer
//
//  Created by iOS on 2019/8/29.
//  Copyright © 2019 Jason. All rights reserved.
//

import Foundation

//国际化语言 类
enum JADLanguageType: String {
    case chinese = "zh-Hans"
    case japanese = "ja"
    case english = "en"
    
    init?(language: String?) {
        if language?.hasPrefix("en") ?? false {
            self = .english
        } else if language?.hasPrefix("zh") ?? false {
            self = .chinese
        } else if language?.hasPrefix("ja") ?? false {
            self = .japanese
        } else {
            return nil
        }
    }
}

class JADLanguage {
    static let JADLanguageChangedNotification = Notification.Name("JADLanguageChangedNotification")

    static var currentLanguageType: JADLanguageType? {
        let currentLanguage = UserDefaults.standard.value(forKey: JADLanguage.languageKey) as! String
        return JADLanguageType(language: currentLanguage)
    }
    
    static let languageKey = "languageKey"
    static var languageBundle: Bundle? {
        let currentLanguage = UserDefaults.standard.value(forKey: JADLanguage.languageKey) as! String
        let path = Bundle.main.path(forResource: currentLanguage, ofType: "lproj") ?? ""
        return Bundle.init(path: path) ?? nil
    }
    
    class func key(_ key: String?) -> String {
        return JADLanguage.languageBundle?.localizedString(forKey: key ?? "", value: nil, table: "Localizations") ?? "语言丢失"
    }

    class func initialize(defaultLanguage: JADLanguageType?) {
        let currentLanguage = UserDefaults.standard.value(forKey: JADLanguage.languageKey)
        guard let _ : String = currentLanguage as? String else {
            let language = Locale.preferredLanguages.first
            let systemLanguage = JADLanguageType.init(language: language) ?? JADLanguageType.english
            JADLanguage.setCurrentLanguage(defaultLanguage ?? systemLanguage)
            return
        }
    }
    
    class func setCurrentLanguage(_ language: JADLanguageType) {
        UserDefaults.standard.set(language.rawValue, forKey: JADLanguage.languageKey)
        UserDefaults.standard.synchronize()
        
        NotificationCenter.default.post(name: JADLanguage.JADLanguageChangedNotification, object: nil)
    }
    
}

/**************************使用扩展示例******************************/

/*
配合自定义plist文件使用
extension JADLanguage {
    class func getSupportLanguageList() -> [JADSupportLanguage]? {
        guard let path = Bundle.main.path(forResource: "MKSupportLanguage", ofType: "plist") else { return nil
        }
        let listArray = NSArray(contentsOfFile: path)
        let key: String = UserDefaults.standard.object(forKey: JADLanguage.languageKey) as? String ?? "en"
        return listArray?.map({ (data) -> JADSupportLanguage in
            let language: [String: String] = data as! [String : String]
            let isSelected = language["code"] == key
            return JADSupportLanguage(data: JSON(language), selected: isSelected)
        })
    }

    class func getCurrentLanguageObject() -> JADSupportLanguage? {
        let array = self.getSupportLanguageList()?.filter({ (data) -> Bool in
            return data.isSelected
        })
        return array?.first
    }
}

struct JADSupportLanguage {
    var code: String?               //国际化code   zh-Hans  en  ja 等
    var languageNameKey: String?
    var countryFlag: String?        //国家的国旗
    var isSelected: Bool = false

    init(data: JSON, selected: Bool) {
        self.code = data["code"].string
        self.languageNameKey = data["languageNameKey"].string
        self.countryFlag = data["countryFlag"].string
        self.isSelected = selected
    }
}
*/
