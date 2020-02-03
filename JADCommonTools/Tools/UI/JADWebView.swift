//
//  JADWebView.swift
//  JADTransfer
//
//  Created by iOS on 2019/9/24.
//  Copyright © 2019 Jason. All rights reserved.
//

import UIKit
import WebKit

protocol JADWebViewCategoryDelegate {
    func htmlProgress(progress: TimeInterval?)
}

class JADWebView: WKWebView {
    
    var categoryDelegate: JADWebViewCategoryDelegate?
    
    private var scriptHandleDictionary = [String: (NSObject, Selector)]()
    
    convenience init() {
        self.init(frame: CGRect.zero, configuration:JADWebViewDefaultConfiguration())
    }
    
    override init(frame: CGRect, configuration: WKWebViewConfiguration) {
        super.init(frame: frame, configuration: configuration)
        self.addObserver(self, forKeyPath: "estimatedProgress", options: [.new], context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            categoryDelegate?.htmlProgress(progress: change?[NSKeyValueChangeKey.newKey] as? TimeInterval)
        }
    }
    
    func addJsTarget(target: NSObject, selector: Selector, name: String) -> Void {
        scriptHandleDictionary[name] = (target, selector)
        self.configuration.userContentController.add(self, name: name)
    }
    
    func removeAllhandleMessages() {
        for scriptHandle in scriptHandleDictionary {
            self.configuration.userContentController.removeScriptMessageHandler(forName: scriptHandle.key)
        }
        scriptHandleDictionary.removeAll()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        self.removeObserver(self, forKeyPath: "estimatedProgress", context: nil)
    }
    
}

extension JADWebView: WKScriptMessageHandler {
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        guard let (object, selector) = scriptHandleDictionary[message.name] else { return }
        object.perform(selector, with: message.body)
    }
    
}


class JADWebViewDefaultConfiguration: WKWebViewConfiguration {
    
    override init() {
        super.init()
        self.preferences.minimumFontSize = 10
        self.preferences.javaScriptEnabled = true
        self.preferences.javaScriptCanOpenWindowsAutomatically = false
        self.processPool = WKProcessPool()
        self.userContentController = WKUserContentController()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
