//
//  APIManager.swift
//  Alamofire5_Demo
//
//  Created by Nirav Gondaliya on 12/05/20.
//  Copyright © 2020 Nirav Gondaliya. All rights reserved.
//

import Foundation
import Alamofire


typealias ResponseHandler = ((_ responseObject :  Any?, _ success : Bool, _ response : HTTPURLResponse?) -> Void)?

class APIManager: NSObject {
    
    var currentBaseURL = "<url>/"
    
    static let sharedInstance = APIManager()
    public var manager : Session?
    
    override init() {
        let configuration = URLSessionConfiguration.default
        manager = Alamofire.Session(configuration: configuration)
        super.init()
        }
    
    
    // MARK: -  Response Handler
    private func HandleResponse(response: DataResponse<Any, AFError>, isServerAlert: Bool, callBack: ResponseHandler) {
        switch (response.result) {
        case .success:
            if let result = response.value {
                    if let JSON = result as? [String: Any]  {
                        
                        // not contained success
                        if !JSON.keys.contains("success"){
                            if let callBack = callBack {
                                callBack(JSON, true, response.response)
                            }
                            return
                        }
                        
                        if JSON.bool(forKey: "success") {
                            if let callBack = callBack {
                                callBack(JSON, true, response.response)
                            }
                        }
                        else {
                            if isServerAlert {
                                //Display Server Alert Message
                                //JSON.string(forKey: "message")
                            }
                            if let callBack = callBack {
                                callBack(JSON , false , response.response)
                            }
                        }
                    }
            }
        case .failure(let error):
            print("Auth request failed with error:\n \(error)")
            print(String.init(data: response.data ?? Data(), encoding: .utf8) as Any)
            
            //Display Failure Alert Message
            //error.localizedDescription
            
            if let callBack = callBack {
                callBack(nil , false , response.response)
            }
            
            break
        }
    }
    
    
    // MARK: -  requestMethod
        func request(url: String, method : HTTPMethod, parameter: [String: Any]?,  isInternetAlert : Bool, isServerAlert : Bool,callBack : ResponseHandler) {
                        
            //Chheck Internet availability
            //If not then return
            //if let callBack = callBack{
            //    callBack(nil, false, nil)
            //}
            
            let headers = ["Content-Type" : "application/json"]
            
            print("##-URL-##\(currentBaseURL + url)")
            print("##-param-##\(String(describing: parameter))")
            print("##-header-##\(headers)")
            
            if method == .post{
                
                self.manager?.request(currentBaseURL + url, method: method, parameters: parameter, encoding: JSONEncoding.default, headers: HTTPHeaders(headers), interceptor: nil).responseJSON(completionHandler: { response in
                    
                    debugPrint("response:\(response)")
                    self.HandleResponse(response: response, isServerAlert: isServerAlert, callBack: callBack)
                    
                })
                
            }else{
                
                self.manager?.request(currentBaseURL + url, method: method, parameters: parameter, encoding: JSONEncoding.default, headers: HTTPHeaders(headers)).responseJSON
                    {[weak self] response in
                        debugPrint("response:\(response)")
                        print("response:\(response)")
                                                
                        self?.HandleResponse(response: response, isServerAlert: isServerAlert, callBack: callBack)
                }
            }
        }
    
    
    // MARK: -  Upload image or video
    func postImageWithParameter( url : String ,parameter: [String : Any]?, arrImage: [UIImage?]?, arrVideo: [URL]?, imageKey: String, isInternetAlert: Bool, isServerAlert: Bool, callback:  ResponseHandler) {
        
        let finalUrl = currentBaseURL + url
        
        let headers = HTTPHeaders(["Accept": "application/json",
                                   "Content-Type": "application/json" ])
        
        AF.upload(multipartFormData: { (multipartFormData) in
            
            
            // for multiple images
            if let arrImage = arrImage {
                for (index, image) in arrImage.enumerated() {
                    if image != nil {
                        multipartFormData.append(image!.jpegData(compressionQuality: 0.8)!, withName:  "\(imageKey)\(index + 1)", fileName: "image.jpg", mimeType: "image/jpeg")
                    }
                }
            }
            
            // for multiple videos
            if arrVideo != nil {
                for (_ , urll) in arrVideo!.enumerated() {
                    multipartFormData.append(urll, withName: imageKey, fileName: "video.mp4", mimeType: "video/mp4")
                }
            }
            
            if let arrPrams = parameter {
                for (key, value) in arrPrams {
                    if value is String {
                        
                        multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
                    }
                    else if value is Bool{
                        multipartFormData.append((value as AnyObject).description.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!, withName: key)
                    }
                }
            }
            
        }, to: finalUrl, usingThreshold: UInt64.init(), method: .post, headers: headers)
            
        .uploadProgress(queue: .main, closure: { progress in
            
            print("Upload Progress: \(progress.fractionCompleted)")
            
        })
            
        .responseJSON(completionHandler: { data in
            
            switch data.result {
                
            case .success(_):
                self.HandleResponse(response: data, isServerAlert: isServerAlert, callBack: callback)
                break
                
            case .failure(let endingError):
                print(endingError)
                
                if let callback = callback {
                    callback(nil, false, nil)
                }
                break
            }
        })
    }
    
}


