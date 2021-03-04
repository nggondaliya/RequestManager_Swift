//
//  ViewController.swift
//  Alamofire5_Demo
//
//  Created by Nirav Gondaliya on 12/05/20.
//  Copyright © 2020 Nirav Gondaliya. All rights reserved.
//

import UIKit
import ObjectMapper

class ViewController: UIViewController {

    var cityList : [CityModel]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        RequestManager.getCityList(endPoint: "get_city") { (responseObject, success, urlResponse) in
            
            if success {
                if let responseObject = responseObject as? [String : Any] {
                    if let cityArray = responseObject["city"] as? [[String : Any]] {
                        self.cityList = Mapper<CityModel>().mapArray(JSONArray: cityArray)
                        
                        for city in self.cityList! {
                            print(city.name!)
                        }
                    }
                }
                
            }else {
                print("Error message...")
            }
        }
    }

}

