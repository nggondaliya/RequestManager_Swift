//
//  RequestManager.swift
//  Alamofire5_Demo
//
//  Created by Nirav Gondaliya on 12/05/20.
//  Copyright © 2020 Nirav Gondaliya. All rights reserved.
//

import Foundation

class RequestManager {
    
    static let shared = RequestManager()
    
    static func getCityList(endPoint : String, callBack : ResponseHandler) {
        
        let param = ["id" : "12345"]
        
        APIManager.sharedInstance.request(url: endPoint, method: .get, parameter: param, isInternetAlert: false, isServerAlert: false, callBack: callBack)
    }
    
}


