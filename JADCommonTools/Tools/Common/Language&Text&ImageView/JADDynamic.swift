//
//  DynamicText.swift
//  JADCommonTools
//
//  Created by iOS on 2019/12/30.
//  Copyright © 2019 LiXuan. All rights reserved.
//

import UIKit

let JADDynamicDidChanged = Notification.Name("JADDynamicDidChanged")

protocol JADDynamicProtocol {
    typealias DynamicProviderBlock = ((_ language: JADLanguageType?) -> String)
    var dynamicProvider: DynamicProviderBlock? { set get }
}

class JADDynamicText: JADDynamicProtocol {
    var dynamicProvider: JADDynamicText.DynamicProviderBlock?
    
    init(_ dynamicProvider: @escaping DynamicProviderBlock) {
        self.dynamicProvider = dynamicProvider
    }
}

class JADDynamicImage: JADDynamicProtocol {
    var dynamicProvider: JADDynamicText.DynamicProviderBlock?
    
    init(_ dynamicProvider: @escaping DynamicProviderBlock) {
        self.dynamicProvider = dynamicProvider
    }
}

extension UILabel {
    
    static private var dynamicTextKey = "dynamicTextKey"
    static private var dynamicCountKey = "dynamicCountKey"
    var dynamicText: JADDynamicProtocol? {
        set {
            let isAddObserver = (objc_getAssociatedObject(self, &UILabel.dynamicCountKey) as? Bool) ?? false
            if !isAddObserver {
                objc_setAssociatedObject(self, &UILabel.dynamicCountKey, true, .OBJC_ASSOCIATION_ASSIGN)
                NotificationCenter.default.addObserver(self, selector: #selector(observeTextChanged), name: JADDynamicDidChanged, object: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(observeTextChanged), name: JADLanguage.JADLanguageChangedNotification, object: nil)
            }
            objc_setAssociatedObject(self, &UILabel.dynamicTextKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            observeTextChanged()
        }
        get {
            return objc_getAssociatedObject(self, &UILabel.dynamicTextKey) as? JADDynamicProtocol
        }
    }
    
    @objc func observeTextChanged() {
        guard let dynamicText = dynamicText else { return }
        let language = UserDefaults.standard.string(forKey: JADLanguage.languageKey)
        self.text = dynamicText.dynamicProvider?(JADLanguageType.init(language: language))
    }
}

extension UIImageView {
    
    static private var dynamicImageKey = "dynamicImageKey"
    static private var dynamicCountKey = "dynamicCountKey"
    var dynamicImage: JADDynamicProtocol? {
        set {
            let isAddObserver = (objc_getAssociatedObject(self, &UIImageView.dynamicCountKey) as? Bool) ?? false
            if !isAddObserver {
                objc_setAssociatedObject(self, &UIImageView.dynamicCountKey, true, .OBJC_ASSOCIATION_ASSIGN)
                NotificationCenter.default.addObserver(self, selector: #selector(observeImageChanged), name: JADDynamicDidChanged, object: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(observeImageChanged), name: JADLanguage.JADLanguageChangedNotification, object: nil)
            }
            objc_setAssociatedObject(self, &UIImageView.dynamicImageKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            observeImageChanged()
        }
        get {
            return objc_getAssociatedObject(self, &UIImageView.dynamicImageKey) as? JADDynamicProtocol
        }
    }
    
    @objc func observeImageChanged() {
        guard let dynamicImage = dynamicImage else { return }
        let language = UserDefaults.standard.string(forKey: JADLanguage.languageKey)
        let imageNamed = dynamicImage.dynamicProvider?(JADLanguageType.init(language: language)) ?? ""
        self.image = UIImage(named: imageNamed)
    }
    
}

extension UIButton {
    static private var dynamicButtonKey = "dynamicImageKey"
    static private var dynamicCountKey = "dynamicCountKey"
    static private var dynamicStatusKey = "dynamicStatusKey"
    private var statusStorage: [String: JADDynamicText]? {
        set {
            objc_setAssociatedObject(self, &UIButton.dynamicStatusKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            var status = objc_getAssociatedObject(self, &UIButton.dynamicStatusKey)
            if status == nil {
                status = [String: JADDynamicText]()
                objc_setAssociatedObject(self, &UIButton.dynamicStatusKey, status, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
            return status as? [String : JADDynamicText]
        }
    }

    private func changedStatusString(status: UIControl.State) -> String {
        switch status {
            case .normal: return "normal"
            case .highlighted: return "highlighted"
            case .disabled: return "disabled"
            case .selected: return "selected"
            case .focused: return "focused"
            case .application: return "application"
            case .reserved: return "reserved"
            default: return ""
        }
    }
    
    func setDynamicTitle(_ title: JADDynamicText,for status: UIControl.State) {
        if statusStorage?.keys.count == 0 {
            NotificationCenter.default.addObserver(self, selector: #selector(observeButtonTextChanged), name: JADDynamicDidChanged, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(observeButtonTextChanged), name: JADLanguage.JADLanguageChangedNotification, object: nil)
        }
        let statusString = changedStatusString(status: status)
        statusStorage?[statusString] = title
        self.observeButtonTextChanged()
    }
    
    @objc func observeButtonTextChanged() {
        let language = UserDefaults.standard.string(forKey: JADLanguage.languageKey)
        self.setTitle(statusStorage?["normal"]?
            .dynamicProvider?(JADLanguageType.init(language: language)), for: .normal)
        
        self.setTitle(statusStorage?["highlighted"]?
            .dynamicProvider?(JADLanguageType.init(language: language)), for: .highlighted)
        
        self.setTitle(statusStorage?["disabled"]?
            .dynamicProvider?(JADLanguageType.init(language: language)), for: .disabled)
        
        self.setTitle(statusStorage?["selected"]?
            .dynamicProvider?(JADLanguageType.init(language: language)), for: .selected)
        
        self.setTitle(statusStorage?["focused"]?
            .dynamicProvider?(JADLanguageType.init(language: language)), for: .focused)
        
        self.setTitle(statusStorage?["application"]?
            .dynamicProvider?(JADLanguageType.init(language: language)), for: .application)
        
        self.setTitle(statusStorage?["reserved"]?
            .dynamicProvider?(JADLanguageType.init(language: language)), for: .reserved)
    }

}
