//
//  ViewController.swift
//  JADCommonTools
//
//  Created by iOS on 2019/12/30.
//  Copyright © 2019 LiXuan. All rights reserved.
//

import UIKit
import SnapKit
import Photos

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let string = "firstString"
        print(string.subString(range: Range(uncheckedBounds: (1,4))))

        let label = UILabel()
        label.textAlignment = .center
        //        label.dynamicText = JADDynamicText({ _ in JADLanguage.key("dynamicText") })
        
        label.dynamicText = JADDynamicText({ (language) -> String in
            if language == .english {
                return "我是英文"
            } else {
                return "我是中文"
            }
        })
        self.view.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(100)
            make.height.equalTo(20)
        }

        let button = UIButton()
        button.setTitle("修改国际化", for: .normal)
        button.addTarget(self, action: #selector(changedLocalized), for: .touchUpInside)
        self.view.addSubview(button)
        button.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(150)
            make.height.equalTo(30)
        }
        
        
        let imageView = UIImageView()
        imageView.dynamicImage = JADDynamicImage({ (language) -> String in
            return "en图片"
        })
        //        imageView.backgroundColor = UIColor.adapterColor({ (_) -> UIColor in
        //            return UIColor.yellow
        //        })
        imageView.backgroundColor = UIColor.adapterColor(JADColor.contentColor)
        self.view.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.height.equalTo(100)
            make.top.equalTo(button.snp.bottom).offset(20)
        }
        
        let languageButton = JADButton()
        languageButton.setTitleColor(UIColor.red, for: .normal)
        languageButton.setDynamicTitle(JADDynamicText({ (language) -> String in
            if language == .english {
                return "我是英文"
            } else {
                return "我是中文"
            }
        }), for: .normal)
        languageButton.setDynamicTitle(JADDynamicText({ (language) -> String in
            if language == .english {
                return "选中英文"
            } else {
                return "选中中文"
            }
        }), for: .selected)
        languageButton.setBackgroundColor(UIColor.yellow, .normal)
        languageButton.setBackgroundColor(UIColor.blue, .touching)
        languageButton.addTarget(self, action: #selector(clickLanguageButton(_:)), for: .touchUpInside)
        self.view.addSubview(languageButton)
        languageButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.height.equalTo(100)
            make.top.equalTo(imageView.snp.bottom).offset(20)
        }
        
    }
    
    @objc func clickLanguageButton(_ sender: UIButton) {
        let picker = JADImagePicker(library: JADImageLibraryConfiguration())
        picker.open(sourceType: .photoLibrary)
        picker.result = { (result) in
            result.originalImage
            result.editedImage
            result.info
        }
    }
    
    @objc func changedLocalized() {
        if JADLanguage.currentLanguageType == .english {
            JADLanguage.setCurrentLanguage(.chinese)
        } else {
            JADLanguage.setCurrentLanguage(.english)
        }
        
    }
}

