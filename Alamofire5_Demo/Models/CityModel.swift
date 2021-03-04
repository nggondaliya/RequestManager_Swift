//
//  CityModel.swift
//  Alamofire5_Demo
//
//  Created by Nirav Gondaliya on 15/05/20.
//  Copyright © 2020 Nirav Gondaliya. All rights reserved.
//

import Foundation
import ObjectMapper

class CityModel: Mappable {
    
    var name : String?
    var id : Int64?
    var image : String?
    var dominant_color : String?
    var latitude : String?
    var longitude : String?
    var status : String?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        name <- map["name"]
        id <- map["id"]
        image <- map["image"]
        dominant_color <- map["dominant_color"]
        latitude <- map["latitude"]
        longitude <- map["longitude"]
        status <- map["status"]
    }
}
