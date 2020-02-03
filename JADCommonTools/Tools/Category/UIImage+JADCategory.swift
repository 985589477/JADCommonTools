//
//  UIImage+JADCategory.swift
//  JADCommonTools
//
//  Created by iOS on 2020/1/2.
//  Copyright © 2020 LiXuan. All rights reserved.
//

import UIKit

extension UIImage {
    
    //颜色生成图片
    static func imageWith(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    ///图片压缩
    func zip() -> UIImage {
        let imageSize = self.size
        var width = imageSize.width
        var height = imageSize.height
        if width > 1280 || height > 1280 {
            if (width>height) {
                let scale = height / width;
                width = 1280;
                height = width * scale;
            }else{
                let scale = width / height;
                height = 1280;
                width = height * scale;
            }
        } else if width > 1280 || height < 1280{
            let scale = height / width;
            width = 1280;
            height = width * scale;
            //3.宽小于1280高大于1280
        } else if width < 1280 || height > 1280{
            let scale = width / height;
            height = 1280;
            width = height * scale;
            //4.宽高都小于1280
        }
        UIGraphicsBeginImageContext(CGSize(width: width, height: height))
        self.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    /// 生成二维码
    ///
    /// - Parameters:
    ///   - content: 二维码内容
    ///   - logoImage: 中心展示的logo，如果不展示则不传入
    class func qrCode(content: String?, logoImage: UIImage? = nil) -> UIImage? {
        guard let stringData = content?.data(using: .utf8, allowLossyConversion: false) else { return nil}
        guard let filter = CIFilter(name: "CIQRCodeGenerator") else { return nil}
        filter.setDefaults()
        filter.setValue(stringData, forKey: "inputMessage")
        filter.setValue("H", forKey: "inputCorrectionLevel")
        let qrCIImage = filter.outputImage
        let colorFilter = CIFilter(name: "CIFalseColor")!
        colorFilter.setDefaults()
        colorFilter.setValue(qrCIImage, forKey: "inputImage")
        colorFilter.setValue(CIColor(red: 0, green: 0, blue: 0), forKey: "inputColor0")
        colorFilter.setValue(CIColor(red: 1, green: 1, blue: 1), forKey: "inputColor1")
        
        let codeImage = UIImage(ciImage: (colorFilter.outputImage!.transformed(by: CGAffineTransform(scaleX: 5, y: 5))))
        
        if let logoImage = logoImage {
            let rect = CGRect(x: 0, y: 0, width: codeImage.size.width, height: codeImage.size.height)
            UIGraphicsBeginImageContext(rect.size)
            codeImage.draw(in: rect)
            let avatarSize = CGSize(width: rect.size.width*0.25, height: rect.size.height*0.25)
            let x = (rect.width - avatarSize.width) * 0.5
            let y = (rect.height - avatarSize.height) * 0.5
            logoImage.draw(in: CGRect(x: x, y: y, width: avatarSize.width, height: avatarSize.height))
            let resultImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return resultImage
        }
        
        return codeImage
    }
    
    
    /// 生成条形码
    ///
    /// - Parameters:
    ///   - content: 内容
    ///   - width: 宽
    ///   - height: 高
    class func barCode(content: String?, width: CGFloat, height: CGFloat) -> UIImage? {
        guard let content = content else { return nil }
        
        if content.count > 0 && width > 0 && height > 0 {
            let inputData = content.data(using: .utf8)
            guard let filter = CIFilter(name: "CICode128BarcodeGenerator") else { return nil }
            filter.setValue(inputData, forKey: "inputMessage")
            guard var ciImage = filter.outputImage else { return nil }
            let scaleX = width/ciImage.extent.size.width
            let scaleY = height/ciImage.extent.size.height
            ciImage = ciImage.transformed(by: CGAffineTransform.init(scaleX: scaleX, y: scaleY))
            return UIImage(ciImage: ciImage)
        }
        return nil
    }
    
}

