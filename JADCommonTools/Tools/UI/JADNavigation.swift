//
//  JADNavigation.swift
//  JADCommonTools
//
//  Created by iOS on 2020/1/2.
//  Copyright © 2020 LiXuan. All rights reserved.
//

import UIKit

protocol MKNavigationAPI {
    var navigationFullHeight: CGFloat { get }
}

protocol MKDefaultNavigationAPI: MKNavigationAPI {
    var leftItems:[UIView]? { set get }
    var leftItem: UIView? { set get }
    
    var rightItems:[UIView]? { set get }
    var rightItem: UIView? { set get }
    
    var titleItem: UIView? { set get }
    
    var title: String? { set get }
    var backImage: String { set get }
}

/// 默认的Navigation
class MKDefaultNavigation: UIView, MKDefaultNavigationAPI {
    private enum MKHandleLayout {
        case left
        case center
        case right
    }
    
    var navigationFullHeight: CGFloat {
        return JADTools.navigationHeight
    }
    
    var leftItems: [UIView]? {
        didSet {
            guard let leftItems = self.leftItems else { return }
            self.handleComponentLayout(items: leftItems, layoutType: .left)
        }
    }
    var leftItem: UIView? {
        didSet {
            guard let leftItem = self.leftItem else { return }
            self.handleComponentLayout(items: [leftItem], layoutType: .left)
        }
    }
    var rightItems: [UIView]? {
        didSet {
            guard let rightItems = self.rightItems else { return }
            self.handleComponentLayout(items: rightItems, layoutType: .right)
        }
    }
    var rightItem: UIView? {
        didSet {
            guard let rightItem = self.rightItem else { return }
            self.handleComponentLayout(items: [rightItem], layoutType: .right)
        }
    }
    var titleItem: UIView? {
        didSet {
            guard let titleItem = self.titleItem else { return }
            self.handleComponentLayout(items: [titleItem], layoutType: .center)
        }
    }
    
    var title: String? {
        didSet {
            if self.classForCoder == MKDefaultNavigation.classForCoder() {
                self.defaultTitleLabel.text = self.title
            }
        }
    }
    var backImage: String = "ic_top_goback" {
        didSet {
            self.defaultLeftImageView.image = UIImage.init(named: self.backImage)
        }
    }
    
    private var navigationBarView: UIView = UIView()
    private var leftView: UIView = UIView()
    private var rightView: UIView = UIView()
    private var titleView: UIView = UIView()
    
    private var defaultTitleLabel: UILabel = UILabel()
    private var defaultLeftImageView: UIImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.zPosition = 999
        self.createComponent()
    }
    
    private func handleComponentLayout(items: [UIView], layoutType: MKHandleLayout) {
        if items.count == 0 { return }
        
        let space: CGFloat = 8.0
        switch layoutType {
        case .center:
            guard let titleView = items.first else { return }
            self.titleView.addSubview(titleView)
            titleView.snp.makeConstraints { (make) in
                make.left.top.bottom.right.equalTo(self.titleView)
            }
        case .left:
            var xMerge: CGFloat = 0.0
            for item in items {
                self.leftView.addSubview(item)
                item.snp.makeConstraints { (make) in
                    make.left.equalTo(self.leftView).offset(xMerge)
                    make.width.height.equalTo(24)
                    make.centerY.equalTo(self.leftView)
                }
                xMerge += (24 + space)
            }
        case .right:
            var xMerge: CGFloat = 0.0
            for item in items {
                self.rightView.addSubview(item)
                item.snp.makeConstraints { (make) in
                    make.right.equalTo(self.rightView).offset(-xMerge)
                    make.height.equalTo(24)
                    make.centerY.equalTo(self.rightView)
                }
                item.setContentHuggingPriority(.required, for: .horizontal)
                xMerge += (24 + space)
            }
        }
    }
    
    private func createComponent() {
        self.addSubview(self.navigationBarView)
        self.navigationBarView.addSubview(self.leftView)
        self.navigationBarView.addSubview(self.titleView)
        self.navigationBarView.addSubview(self.rightView)
        
        defaultTitleLabel.font = UIFont(name: "PingFangSC-Regular", size: 16)
        defaultTitleLabel.textAlignment = .center
        defaultLeftImageView.isUserInteractionEnabled = true
        defaultLeftImageView.image = UIImage(named: self.backImage)
        self.titleItem = self.defaultTitleLabel
        self.leftItem = self.defaultLeftImageView
        
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.navigationBarView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self)
            make.top.equalToSuperview().offset(JADTools.statusBarHeight)
            make.height.equalTo(JADTools.navigationBarHeight)
        }
        self.leftView.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(18)
            make.top.bottom.equalTo(self.navigationBarView)
            make.width.equalTo(75)
        }
        self.rightView.snp.makeConstraints { (make) in
            make.right.equalTo(self).offset(-18)
            make.top.bottom.equalTo(self.navigationBarView)
            make.width.equalTo(75)
        }
        self.titleView.snp.makeConstraints { (make) in
            make.left.equalTo(self.leftView.snp.right).offset(8)
            make.right.equalTo(self.rightView.snp.left).offset(-8)
            make.top.bottom.equalTo(self.navigationBarView)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
