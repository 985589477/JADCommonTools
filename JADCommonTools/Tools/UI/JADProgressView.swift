//
//  JADProgressView.swift
//  JADTransfer
//
//  Created by iOS on 2019/9/4.
//  Copyright © 2019 Jason. All rights reserved.
//

import UIKit

protocol JADProgressViewAPI {
    //设置进度 0.0 - 1.0
    var progress: TimeInterval { set get }
    //单色
    var progressColor: UIColor? { set get }
    //渐变进度条颜色 传CGColor
    var progressColors: [Any]? { set get }
    //渐变location，默认为0,1
    var progressLocations: [NSNumber]? { set get }
    //重制进度
    func resetProgress()
}

class JADProgressView: UIView, JADProgressViewAPI {
    var progress: TimeInterval = 0.0 {
        didSet {
            UIView.animate(withDuration: 0.2) {
                if self.progress <= 0 {
                    self.gradientLayer.frame = CGRect.zero
                } else if self.progress > 0 && self.progress < 1 {
                    self.gradientLayer.frame = CGRect(x: 0, y: 0, width: self.frame.width * CGFloat(self.progress), height: self.frame.height)
                } else {
                    self.gradientLayer.frame = self.bounds
                }
            }
        }
    }
    var progressColor: UIColor? {
        didSet {
            self.gradientLayer.backgroundColor = self.progressColor?.cgColor
        }
    }
    
    var progressColors: [Any]? {
        didSet {
            self.gradientLayer.colors = self.progressColors
        }
    }
    
    var progressLocations: [NSNumber]? {
        didSet {
            self.gradientLayer.locations = self.progressLocations
        }
    }
    
    private var gradientLayer: CAGradientLayer = CAGradientLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.groupTableViewBackground
        gradientLayer.frame = CGRect.zero
        gradientLayer.backgroundColor = self.backgroundColor?.cgColor
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        self.layer.addSublayer(gradientLayer)

    }
    
    func resetProgress() {
        self.progress = 0.0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
