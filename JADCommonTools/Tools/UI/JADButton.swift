//
//  JADButton.swift
//  JADTransfer
//
//  Created by iOS on 2019/9/2.
//  Copyright © 2019 Jason. All rights reserved.
//

import UIKit

/**
 Button
 */
enum JADButtonStatus: String {
    case normal = "normal"      //正常状态
    case touching = "touching"  //正在按
    case disabled = "disabled"  //不可用
}

protocol JADButtonAPI {
    
    var cornerRadios: CGFloat { set get }
    
    //设置边框渐变色， status不同展示不同，不设置其他状态则只展示normal
    func setBorderGradient(_ borderWidth: CGFloat,_ colors: [Any],_ locations: [NSNumber],_ status: JADButtonStatus)
    
    //设置文字渐变色
    func setTextGradient(_ colors: [Any],_ locations: [NSNumber],_ status: JADButtonStatus)
    
    //设置背景渐变色
    func setBackgroundGradient(_ colors: [Any],_ locations: [NSNumber],_ status: JADButtonStatus)
}

class JADButton: UIButton, JADButtonAPI {
    
    var currentStatus: JADButtonStatus = .normal {
        didSet {
            self.changedStatus(self.currentStatus)
        }
    }
    
    var cornerRadios: CGFloat = 0.0
    
    override var isEnabled: Bool {
        didSet {
            self.currentStatus = self.isEnabled ? .normal : .disabled
        }
    }
    
    
    lazy var borderGradientLayer: CAGradientLayer = CAGradientLayer()
    private lazy var borderShapeLayer: CAShapeLayer? = {
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = UIColor.black.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        return shapeLayer
    }()
    private lazy var textGradientLayer: CAGradientLayer? = CAGradientLayer()
    private lazy var backgroundGradientLayer: CAGradientLayer? = CAGradientLayer()
    
    private var borderDictionary =  [String: (CGFloat, [Any], [NSNumber])]()
    private var textDictionary = [String: ([Any], [NSNumber])]()
    private var backgroundDictionary = [String: ([Any], [NSNumber])]()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func setBorderGradient(_ borderWidth: CGFloat ,_ colors: [Any], _ locations: [NSNumber], _ status: JADButtonStatus) {
        borderDictionary[status.rawValue] = (borderWidth, colors, locations)
    }
    
    func setTextGradient(_ colors: [Any], _ locations: [NSNumber], _ status: JADButtonStatus) {
        textDictionary[status.rawValue] = (colors, locations)
    }
    
    func setBackgroundGradient(_ colors: [Any], _ locations: [NSNumber], _ status: JADButtonStatus) {
        backgroundDictionary[status.rawValue] = (colors, locations)
    }
    
    func setBackgroundColor(_ color: UIColor,_ status: JADButtonStatus) {
        self.setBackgroundGradient([color.cgColor, color.cgColor], [0,1], status)
    }
    
    func setTextColor(_ color: UIColor,_ status: JADButtonStatus) {
        self.setTextGradient([color.cgColor, color.cgColor], [0,1], status)
    }
    
    func setBorderColor(_ borderWidth: CGFloat ,_ color: UIColor,_ status: JADButtonStatus) {
        self.setBorderGradient(borderWidth, [color.cgColor, color.cgColor], [0,1], status)
    }
    
    private func changedStatus(_ status: JADButtonStatus) {
        self.borderChangedStatus(status)
        self.textChangedStatus(status)
        self.backgroundChangedStatus(status)
    }
    
    private func borderChangedStatus(_ status: JADButtonStatus) {
        guard let (boderWidth, colors, locations) = borderDictionary[status.rawValue] else { return }
        self.borderGradientLayer.frame = self.bounds
        self.borderGradientLayer.colors = colors
        self.borderGradientLayer.locations = locations
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: UIRectCorner.allCorners, cornerRadii: CGSize(width: self.cornerRadios, height: cornerRadios))
        self.borderShapeLayer?.path = path.cgPath
        self.borderShapeLayer?.lineWidth = boderWidth
        self.borderGradientLayer.mask = self.borderShapeLayer
        self.layer.addSublayer(self.borderGradientLayer)
        self.borderGradientLayer.cornerRadius = cornerRadios
        self.clipsToBounds = true
    }
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        self.currentStatus = .touching
        return true
    }
    
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        self.currentStatus = .normal
    }
    
    
    private func textChangedStatus(_ status: JADButtonStatus) {
        guard let (colors, locations) = textDictionary[status.rawValue] else { return }
        self.textGradientLayer?.frame = self.bounds
        self.textGradientLayer?.colors = colors
        self.textGradientLayer?.locations = locations
        self.layer.addSublayer(self.textGradientLayer!)
        self.textGradientLayer?.mask = self.titleLabel?.layer
    }
    
    private func backgroundChangedStatus(_ status: JADButtonStatus) {
        guard let (colors, locations) = backgroundDictionary[status.rawValue] else { return }
        self.backgroundGradientLayer?.frame = self.bounds
        self.backgroundGradientLayer?.colors = colors
        self.backgroundGradientLayer?.locations = locations
        self.layer.insertSublayer(self.backgroundGradientLayer!, at: 0)
        self.backgroundGradientLayer? .cornerRadius = cornerRadios
        self.clipsToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.changedStatus(self.currentStatus)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
