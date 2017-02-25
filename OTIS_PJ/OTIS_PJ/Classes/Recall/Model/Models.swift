//
//  Models.swift
//  OTIS_PJ
//
//  Created by sunze on 2017/2/21.
//  Copyright © 2017年 sunzeboy. All rights reserved.
//

import UIKit
import SwiftyJSON

struct MyselfModel {
    
}

public protocol Mapable {
    
    init?(jsonData:JSON)
}


struct Areas: Mapable {
    var areas : [AreaItem]?
    
    init?(jsonData: JSON) {
        for (_,subJson):(String, JSON) in jsonData {
            self.areas?.append(AreaItem(jsonData: subJson)!)
        }
        
    }
}

struct AreaItem: Mapable {
    var areaNameZh : String?
    var areaID : Int?
    var areaName : String?
    var areaShortName : String?
    init?(jsonData: JSON) {
        self.areaNameZh = jsonData["areaNameZh"].string
        self.areaID = jsonData["areaID"].int
        self.areaName = jsonData["areaName"].string
        self.areaShortName = jsonData["areaShortName"].string

    }
    
}
