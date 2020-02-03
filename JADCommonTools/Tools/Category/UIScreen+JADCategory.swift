//
//  UIScreen+JADCategory.swift
//  JADCommonTools
//
//  Created by iOS on 2020/1/2.
//  Copyright © 2020 LiXuan. All rights reserved.
//

import UIKit

extension UIScreen {
    
    var safeBounds: CGRect {
        let rect = CGRect(x: UIScreen.main.x, y: UIScreen.main.y, width: UIScreen.main.width, height: UIScreen.main.safeHeight)
        return rect
    }
    
    var x: CGFloat {
        return UIScreen.main.bounds.origin.x
    }
    
    var y: CGFloat {
        return UIScreen.main.bounds.origin.y
    }
    
    var width: CGFloat {
        return UIScreen.main.bounds.size.width
    }
    
    var height: CGFloat {
        return UIScreen.main.bounds.size.height
    }
    
    var safeHeight: CGFloat {
        return UIScreen.main.height - JADTools.safeBottomHeight
    }
}
