//
//  JADMaskView.swift
//  JADTransfer
//
//  Created by iOS on 2019/9/8.
//  Copyright © 2019 Jason. All rights reserved.
//

import UIKit

class JADMaskView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(backgroundColor: UIColor, alpha: CGFloat, blurView: UIBlurEffect?) {
        self.init(frame: CGRect.zero)
        
        if let blurView = blurView {
            self.backgroundColor = backgroundColor
            self.installBlurView(blurView: blurView, alpha: alpha)
        } else {
            self.backgroundColor = backgroundColor.withAlphaComponent(alpha)
        }
    }
    
    private func installBlurView(blurView: UIBlurEffect?, alpha: CGFloat) {
        guard let blurView = blurView else { return }
        let visualEffect  = UIVisualEffectView(effect: blurView)
        visualEffect.frame = self.bounds
        visualEffect.alpha = alpha
        self.addSubview(visualEffect)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
