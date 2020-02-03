//
//  JADThemeAdapter.swift
//  JADCommonTools
//
//  Created by iOS on 2019/12/31.
//  Copyright © 2019 LiXuan. All rights reserved.
//

import UIKit

class JADColor {
    static var contentColor: JADColorAdapter = { (trait) -> UIColor in
        if #available(iOS 12.0, *) {
            if trait?.userInterfaceStyle == .dark {
                return UIColor.yellow
            }
        }
        return UIColor.red
    }
}
