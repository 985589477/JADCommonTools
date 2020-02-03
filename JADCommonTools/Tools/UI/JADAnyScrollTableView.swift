//
//  JADAnyScrollTableView.swift
//  JADTransfer
//
//  Created by iOS on 2019/10/24.
//  Copyright © 2019 Jason. All rights reserved.
//

import UIKit

class JADAnyScrollTableView: UITableView, UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
}
