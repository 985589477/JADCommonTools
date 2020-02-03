//
//  JADFormTableView.swift
//  SwiftForm
//
//  Created by 李璇 on 2019/10/1.
//  Copyright © 2019 Lxxxxx. All rights reserved.
//

import UIKit

class JADFormTableView: UIView {
    
    var configuration: JADFormConfiguration
    var tableView: UITableView
    init(config: JADFormConfiguration) {
        configuration = config
        tableView = UITableView(frame: CGRect.zero, style: config.style)
        super.init(frame: CGRect.zero)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        self.addSubview(tableView)
    }
    
    override func layoutSubviews() {
        self.tableView.frame = self.bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension JADFormTableView: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return configuration.sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return configuration.sections[section].rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = configuration.sections[indexPath.section].rows[indexPath.row]
        let JADKYCClass = row.cell as! JADFormBaseCell.Type
        let identifier = NSStringFromClass(JADKYCClass)
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? JADFormBaseCell
        if cell == nil {
            cell = JADKYCClass.init( reuseIdentifier: identifier)
        }
        cell?.selectionStyle = .none
        cell?.row = row
        row.events[.load]?(cell!, row.extraData, indexPath)
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = configuration.sections[indexPath.section].rows[indexPath.row]
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        row.events[.didSelected]?(cell,row.extraData, indexPath)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let row = configuration.sections[indexPath.section].rows[indexPath.row]
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        row.events[.didDeselected]?(cell,row.extraData, indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let row = configuration.sections[indexPath.section].rows[indexPath.row]
        let height = row.heightEvents["height"]?(indexPath) ?? 0
        return height > 0 ? height : row.rowHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let configSection = configuration.sections[section]
        configSection.headerEvents[.load]?(configSection.sectionHeader, configSection.extraData, section)
        return configSection.sectionHeader
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let configSection = configuration.sections[section]
        let height = configSection.heightEvent[.headerHeight]?(section) ?? 0
        return height > 0 ? height : configSection.sectionHeaderHeight
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let configSection = configuration.sections[section]
        configSection.footerEvents[.load]?(configSection.sectionFooter, configSection.extraData, section)
        return configSection.sectionFooter
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let configSection = configuration.sections[section]
        let height = configSection.heightEvent[.footerHeight]?(section) ?? 0
        return height > 0 ? height : configSection.sectionFooterHeight
    }
    
}

