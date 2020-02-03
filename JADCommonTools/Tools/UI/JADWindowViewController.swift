//
//  JADWindowViewController.swift
//  JADTransfer
//
//  Created by iOS on 2019/9/8.
//  Copyright © 2019 Jason. All rights reserved.
//

import UIKit

class JADWindowViewController: UIViewController {
    var windowLevel: UIWindow.Level?
    var window: UIWindow?
    fileprivate var backgroundView: UIView?
    fileprivate var maskView: JADMaskView?

    init(_ windowLevel: UIWindow.Level?,_ backgroundView: UIView?,_ maskView: JADMaskView?) {
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .overFullScreen
        self.modalTransitionStyle = .crossDissolve
        self.backgroundView = backgroundView
        self.windowLevel = windowLevel
        self.window = UIWindow.init(frame: UIScreen.main.bounds)
        self.window?.windowLevel = windowLevel ?? UIWindow.Level.normal
        self.backgroundView = backgroundView
        self.maskView = maskView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.frame = UIScreen.main.bounds
        self.view.addSubview(backgroundView ?? JADNormalBackgroundView())
        if let maskView = maskView {
            maskView.frame = self.view.bounds
            self.view.addSubview(maskView)
        }
        self.window?.rootViewController = self
    }

    func install(becomeKey: Bool) {
        guard let window = window else { return }
        if becomeKey {
            window.makeKeyAndVisible()
        } else {
            window.isHidden = false
        }
    }
    
    func uninstall() {
        window?.isHidden = true
        window = nil
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class JADNormalBackgroundView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
