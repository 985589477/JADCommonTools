//
//  JADFormTableView.swift
//  SwiftForm
//
//  Created by 李璇 on 2019/10/1.
//  Copyright © 2019 Lxxxxx. All rights reserved.
//

import UIKit

protocol JADFormModelProtocol {
    
    /// 一个模型可以有多个code，可理解为传给后台的字段 "name" = "xiaoming" "age" = "10" code的定义就可以为 ["name", "age"]
    var code: [String] { set get }
    
    /// 是否必传，如果设置是必传，则在validate中会校验是否有value
    var required: Bool { set get }
    
    /// 输出最终的结果参数
    var parameters: [String: Any] { set get }
}

class JADFormConfiguration {
    var sections = [JADFormSection]()
    var style: UITableView.Style
    
    init(style: UITableView.Style) {
        self.style = style
    }

    func addSection(section: JADFormSection) {
        sections.append(section)
    }
    
    func removeSection(section: JADFormSection) {
        guard let index = (sections.enumerated().filter { $0.element == section }.map{ $0.offset }.last) else { return }
        sections.remove(at: index)
    }
    
    func toParameters() -> [String: Any] {
        var parameters = [String: Any]()
        for section in sections {
            for row in section.rows {
                guard let model = row.extraData as? JADFormModelProtocol else { continue }
                for (key, value) in model.parameters {
                    parameters[key] = value
                }
            }
        }
        
        return parameters
    }
    
    func validate() -> Bool {
        for section in sections {
            for row in section.rows {
                guard let model = row.extraData as? JADFormModelProtocol else { continue }
                if model.required == true {
                    for code in model.code {
                        if (model.parameters[code] as? String)?.isEmpty ?? true {
                            return false
                        }
                    }
                }
            }
        }
        return true
    }
    
}

class JADFormSection: NSObject {
    
    enum JADFormSectionStatus {
        case load
        case didSeleted
    }
    
    enum JADFormSectionHeight {
        case headerHeight
        case footerHeight
    }
    
    var sectionHeaderHeight: CGFloat = 0
    var sectionHeader = UIView()
    var sectionFooterHeight: CGFloat = 0
    var sectionFooter = UIView()
    
    var extraData: Any?
    
    //加载的view，传入的数据，反悔的section下标
    typealias SectionEvent = ((UIView, Any?, Int) -> Void)
    var headerEvents = [JADFormSectionStatus: SectionEvent]()
    var footerEvents = [JADFormSectionStatus: SectionEvent]()
    typealias SectionHeightEvents = ((_ section: Int) -> CGFloat)
    var heightEvent = [JADFormSectionHeight: SectionHeightEvents]()
    
    var rows = [JADFormRow]()
    
    func registerHeaderEvent(status: JADFormSectionStatus, event: @escaping SectionEvent) {
        headerEvents[status] = event
    }
    
    func registerFooterEvent(status: JADFormSectionStatus, event: @escaping SectionEvent) {
        footerEvents[status] = event
    }
    
    func registerSectionHeight(type: JADFormSectionHeight, complated: @escaping SectionHeightEvents) {
        heightEvent[type] = complated
    }
    
    func addRow(row: JADFormRow) -> Void {
        rows.append(row)
    }
    
    func addRows(rows: [JADFormRow]) -> Void {
        self.rows.append(contentsOf: rows)
    }
    
    func removeRow(row: JADFormRow) -> Void {
        guard let index = (rows.enumerated().filter { $0.element == row }.map{ $0.offset }.last) else { return }
        rows.remove(at: index)
    }
    
    func removeRows(rows: [JADFormRow]) -> Void {
        for row in rows {
            guard let index = (self.rows.enumerated().filter { $0.element == row }.map{ $0.offset }.last) else { return }
            self.rows.remove(at: index)
        }
    }
    
    func removeRowsLast(offset: Int) -> Void {
        self.rows.removeLast(offset)
    }
}

//通过registerEvent来获取row的事件
class JADFormRow: NSObject {
    enum JADFormRowStatus: String {
        case load
        case didSelected
        case didDeselected
    }
    var rowHeight: CGFloat = 44
    var cell: AnyClass
    var extraData: Any?
    var events = [JADFormRowStatus: Event]()
    var heightEvents = [String: RowHeight]()
    var userEvent = JADUserEvent()
    
    typealias Event = ((UITableViewCell, Any?, IndexPath) -> Void)
    typealias RowHeight = ((_ indexPath: IndexPath) -> CGFloat)
    func registerEvent(status: JADFormRowStatus, event: @escaping Event) {
        events[status] = event
    }
    
    func registerRowHeight(completed: @escaping RowHeight) {
        heightEvents["height"] = completed
    }
    
    init(cell: AnyClass) {
        self.cell = cell
        super.init()
    }
}

/// 可以定义一些用户事件的实现
class JADEventRegister {}

/// 可以通过扩展方式为自己添加一些用户事件，使用闭包形式
class JADUserEvent: NSObject {}
