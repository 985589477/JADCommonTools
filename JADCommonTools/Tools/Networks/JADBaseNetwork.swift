//
//  JADBaseNetwork.swift
//  JADTransfer
//
//  Created by iOS on 2019/8/27.
//  Copyright © 2019 Jason. All rights reserved.
//

import Foundation
import Alamofire

typealias NetworkComplatedClosure = ((_ data:[String: Any]?,_ error: Error?) -> Void)
class JADBaseNetwork {
    
    static let shared = JADBaseNetwork()
    
    var headers: [String: String]
    
    init() {
        headers = [
            "deviceType": "2",
            "version": JADTools.version
        ]
    }
    
    func request(url: String, method: HTTPMethod, parameter: [String: Any]?, sign: String? = "" , queue: DispatchQueue?, group: DispatchGroup?,_ complated: NetworkComplatedClosure?) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        self.headers["sign"] = sign
        let currentLanguage = UserDefaults.standard.value(forKey: JADLanguage.languageKey)
        self.headers["Accept-Language"] = "\(currentLanguage ?? "en");q=0.9"
        
        self.requestBody(url: url, method: method, parameter: parameter, queue: queue, group: group, complated)

//        DispatchQueue.global().async {
//            if url == APPURL.main.URL_refreshToken {
//                if PreferenceManager.shared[PreferenceKeys.token] != nil {
//                    self.headers["token"] = PreferenceManager.shared[PreferenceKeys.token]!
//                }
//                self.requestBody(url: url, method: method, parameter: parameter, queue: queue, group: group, complated)
//            } else {
//                JADTokenPasrsing.refreshTokenIntercept { (isSuccess) in
//                    //写在里面是因为刷新token会有可能存入新token
//                    if PreferenceManager.shared[PreferenceKeys.token] != nil {
//                        self.headers["token"] = PreferenceManager.shared[PreferenceKeys.token]!
//                    }
//                    self.requestBody(url: url, method: method, parameter: parameter, queue: queue, group: group, complated)
//                }
//            }
//        }
    }
    
    private func requestBody(url: String, method: HTTPMethod, parameter: [String: Any]?, sign: String? = "" , queue: DispatchQueue?, group: DispatchGroup?,_ complated: NetworkComplatedClosure?) {
        group?.enter()
        Alamofire.request(url, method: method, parameters: parameter, encoding: URLEncoding.default, headers: self.headers).validate(contentType: ["multipart/form-data","application/json","text/html"]).responseJSON(queue: queue, options: .mutableContainers, completionHandler: { (response) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            print(response)
            print(url)
            complated?(response.result.value as? [String : Any], response.error)
            group?.leave()
        })
    }
    
    func uploadImage( url: String, parameter:[String: Any]?, image: UIImage, sign: String? = "",_ progress: ((_ progress: Double) -> Void)?,_ complated: NetworkComplatedClosure?) -> Void {
        
        guard let imageData = image.jpegData(compressionQuality: 0.5) else { return }
        self.headers["sign"] = sign

        Alamofire.upload(multipartFormData: { (data) in
            for (key, value) in parameter ?? [String : Any]() {
                guard let value = value as? String else { return }
                data.append((value.data(using: String.Encoding.utf8)!), withName: key)
            }
            data.append(imageData, withName: "file", fileName: "file"+".jpeg", mimeType: "image/jpeg")
        }, usingThreshold: SessionManager.multipartFormDataEncodingMemoryThreshold,
           to: URL(string: url)!,
           method: .post,
           headers: self.headers){ (result) in
            switch result {
            case .success(let upload, _, _):
                //上传进度
                upload.uploadProgress(queue: DispatchQueue.main) { uploadProgress in
                    progress?(uploadProgress.fractionCompleted)
                }
                //json处理
                upload.responseJSON { response in
                    print(url)
                    complated?(response.result.value as? [String : Any], response.error)
                }
            case .failure(let encodingError):
                complated?(nil, encodingError)
            }
        }
    }
}
