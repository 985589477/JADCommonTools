//
//  UITextField+Rules.swift
//  MKTransfer
//
//  Created by iOS on 2019/9/2.
//  Copyright © 2019 Jason. All rights reserved.
//

import UIKit

protocol UITextFieldStrategy {
    func validate(with: UITextField) -> Bool
}

var rulesKey = "MKTextFieldRules"
extension UITextField {
    var rules: [UITextFieldStrategy]? {
        set {
            objc_setAssociatedObject(self, &rulesKey , newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, &rulesKey) as? [UITextFieldStrategy]
        }
    }
    
    func validate() -> Bool {
        guard let rules = self.rules else {
            return false
        }
        for rule in rules {
            let isOK = rule.validate(with: self)
            if !isOK {
                return  false
            }
        }
        return true
    }
    
}
