//
//  JADImagePicker.swift
//  JADCommonTools
//
//  Created by iOS on 2020/2/10.
//  Copyright © 2020 LiXuan. All rights reserved.
//

import UIKit
import Photos

class JADImagePicker: NSObject {
    
    public var result: ((_ result: JADImagePickerResult) -> Void)?
    
    private var photoConfig: JADImagePhotosConfiguration
    private var libraryConfig: JADImageLibraryConfiguration
    fileprivate var imagePicker: UIImagePickerController = UIImagePickerController()
    private var activityConfig: JADImagePickerConfiguration? {
        if photoConfig.isActivity { return photoConfig }
        if libraryConfig.isActivity { return libraryConfig }
        return nil
    }
    
    init(photos: JADImagePhotosConfiguration? = JADImagePhotosConfiguration(),
         library: JADImageLibraryConfiguration? = JADImageLibraryConfiguration()) {
        photoConfig = photos ?? JADImagePhotosConfiguration()
        libraryConfig = library ?? JADImageLibraryConfiguration()
        super.init()
    }
    
    @discardableResult
    private func activitySettings(_ configuration: JADImagePickerConfiguration?) -> Bool {
        guard let configuration = configuration else { return false }
        guard configuration.isValid else { print("当前设备不支持"); return false}
        imagePicker.allowsEditing = configuration.allowEditing
        imagePicker.delegate = self
        if let configuration = configuration as? JADImagePhotosConfiguration {
            imagePicker.cameraDevice = configuration.cameraDevice
        }
        return true
    }
    
    func open(sourceType: UIImagePickerController.SourceType, animated: Bool? = true) {
        sourceType == .camera ? (photoConfig.isActivity = true) : (libraryConfig.isActivity = true)
        if activityConfig?.isValid ?? false {
            imagePicker.sourceType = sourceType
        }
        if self.activitySettings(activityConfig) {
            JADTools.keyWindow?.rootViewController?.present(imagePicker, animated: animated ?? true, completion: nil)
        }
    }
    
    func dismiss(animated: Bool? = true) {
        JADTools.keyWindow?.rootViewController?.dismiss(animated: animated ?? true, completion: nil)
    }
}

class JADImagePickerResult {
    var originalImage: UIImage?
    var editedImage: UIImage?
    var info: [UIImagePickerController.InfoKey : Any]?
}

extension JADImagePicker: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let originalImage = info[.originalImage] as? UIImage
        let editedImage = info[.editedImage] as? UIImage
        if (activityConfig?.isNeedSaveAtAblum ?? false) && (activityConfig?.isValid ?? false) && UIImagePickerController.isValidSavedPhotosAlbum, let originalImage = originalImage {
            UIImageWriteToSavedPhotosAlbum(originalImage, self, Selector(("imageSave:error:contextInfo:")), nil)
        }
        let resultObj = JADImagePickerResult()
        resultObj.originalImage = originalImage
        resultObj.editedImage = editedImage
        resultObj.info = info
        
        result?(resultObj)
        picker.dismiss(animated: true, completion: nil)
    }
}

protocol JADImagePickerConfiguration {
    var isActivity: Bool { set get }
    var isValid: Bool { get }
    var allowEditing: Bool { set get }
    var isNeedSaveAtAblum: Bool { set get }
}


class JADImagePhotosConfiguration: JADImagePickerConfiguration {
    var isNeedSaveAtAblum: Bool = false
    
    var isActivity: Bool = false
    
    //默认后置摄像头
    var cameraDevice: UIImagePickerController.CameraDevice = .rear
    
    var isValid: Bool {
        return UIImagePickerController.isValidCamera && self.validCameraDevice
    }
    
    var allowEditing: Bool = true

    private var validCameraDevice: Bool {
        return self.cameraDevice == .rear ? UIImagePickerController.isValidCameraRear : UIImagePickerController.isValidCameraFront
    }
    
}

class JADImageLibraryConfiguration: JADImagePickerConfiguration {
    var isNeedSaveAtAblum: Bool = false
    
    var isActivity: Bool = false
    
    var isValid: Bool {
        return UIImagePickerController.isValidPhotoLibrary
    }
    
    var allowEditing: Bool = true
}

/// 相片选择器类型：相册 PhotoLibrary，图库 SavedPhotosAlbum，相机 Camera，前置摄像头 Front，后置摄像头 Rear
public enum UIImagePickerType:Int {
    /// 相册 PhotoLibrary
    case UIImagePickerTypePhotoLibrary = 1
    /// 图库 SavedPhotosAlbum
    case UIImagePickerTypeSavedPhotosAlbum = 2
    /// 相机 Camera
    case UIImagePickerTypeCamera = 3
    /// 前置摄像头 Front
    case UIImagePickerTypeCameraFront = 4
    /// 后置摄像头 Rear
    case UIImagePickerTypeCameraRear = 5
}

extension UIImagePickerController {
    // MARK: - 设备使用有效性判断
    // 相册 PhotoLibrary，图库 SavedPhotosAlbum，相机 Camera，前置摄像头 Front，后置摄像头 Rear
    public class func isValidImagePickerType(type imagePickerType:UIImagePickerType) -> Bool {
        switch imagePickerType {
        case .UIImagePickerTypePhotoLibrary:
            if self.isValidPhotoLibrary {
                return true
            }
            return false
        case .UIImagePickerTypeSavedPhotosAlbum:
            if self.isValidSavedPhotosAlbum {
                return true
            }
            return false
        case .UIImagePickerTypeCamera:
            if self.isValidCameraEnable && self.isValidCamera {
                return true
            }
            return false
        case .UIImagePickerTypeCameraFront:
            if self.isValidCameraEnable && self.isValidCameraFront {
                return true
            }
            return false
        case .UIImagePickerTypeCameraRear:
            if self.isValidCamera && self.isValidCameraRear {
                return true
            }
            return false
        }
    }
    
    /// 相机设备是否启用
    public class var isValidCameraEnable: Bool {
        get {
            let cameraStatus =
                AVCaptureDevice.authorizationStatus(for: AVMediaType.audio)
            if cameraStatus == AVAuthorizationStatus.denied {
                return false
            }
            return true
        }
    }
    
    /// 相机Camera是否可用（是否有摄像头）
    public class var isValidCamera: Bool {
        get {
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera){
                return true
            }
            return false
        }
    }
    
    /// 前置相机是否可用
    public class var isValidCameraFront: Bool {
        get {
            if UIImagePickerController.isCameraDeviceAvailable(UIImagePickerController.CameraDevice.front){
                return true
            }
            return false
        }
    }
    
    /// 后置相机是否可用
    public class var isValidCameraRear: Bool {
        get {
            if UIImagePickerController.isCameraDeviceAvailable(UIImagePickerController.CameraDevice.rear){
                return true
            }
            return false
        }
    }
    
    /// 相册PhotoLibrary是否可用
    public class var isValidPhotoLibrary: Bool {
        get {
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) {
                return true
            }
            return false
        }
    }
    
    /// 图库SavedPhotosAlbum是否可用
    public class var isValidSavedPhotosAlbum: Bool {
        get {
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.savedPhotosAlbum) {
                return true
            }
            return false
        }
    }
    
}

extension UIImage {
    ///修复图片方向问题
    var fixImageOrientation: UIImage {
        if self.imageOrientation == .up {
            return self
        }
        var transform = CGAffineTransform.identity
        switch self.imageOrientation {
        case .down, .downMirrored:
            transform = transform.translatedBy(x: self.size.width, y: self.size.height)
            transform = transform.rotated(by: .pi)
            break
        case .left, .leftMirrored:
            transform = transform.translatedBy(x: self.size.width, y: 0)
            transform = transform.rotated(by: .pi / 2)
            break
        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: self.size.height)
            transform = transform.rotated(by: -.pi / 2)
            break
        default: break
        }
        switch self.imageOrientation {
        case .upMirrored, .downMirrored:
            transform = transform.translatedBy(x: self.size.width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
            break
        case .leftMirrored, .rightMirrored:
            transform = transform.translatedBy(x: self.size.height, y: 0);
            transform = transform.scaledBy(x: -1, y: 1)
            break
        default:
            break
        }
        let ctx = CGContext(data: nil, width: Int(self.size.width), height: Int(self.size.height), bitsPerComponent: self.cgImage!.bitsPerComponent, bytesPerRow: 0, space: self.cgImage!.colorSpace!, bitmapInfo: self.cgImage!.bitmapInfo.rawValue)
        ctx?.concatenate(transform)
        switch self.imageOrientation {
        case .left, .leftMirrored, .right, .rightMirrored:
            ctx?.draw(self.cgImage!, in: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(size.height), height: CGFloat(size.width)))
            break
        default:
            ctx?.draw(self.cgImage!, in: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(size.width), height: CGFloat(size.height)))
            break
        }
        let cgImage: CGImage = (ctx?.makeImage())!
        let image = UIImage(cgImage: cgImage)
        return image
    }
}
