//
//  Array+JADCategory.swift
//  JADCommonTools
//
//  Created by iOS on 2020/1/2.
//  Copyright © 2020 LiXuan. All rights reserved.
//

import Foundation

extension Array where Element: Equatable {
    //数组元素去重
    mutating func removeDuplicates() {
        var result = [Element]()
        for value in self {
            if !result.contains(value) {
                result.append(value)
            }
        }
        self = result
    }
}
