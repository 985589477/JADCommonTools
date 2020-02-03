//
//  MKKYCBaseCell.swift
//  SwiftForm
//
//  Created by 李璇 on 2019/10/1.
//  Copyright © 2019 Lxxxxx. All rights reserved.
//

import UIKit

class JADFormBaseCell: UITableViewCell {
    var row: JADFormRow!
    
    required init(reuseIdentifier: String) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
