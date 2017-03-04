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

protocol Mapable {
    
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



enum CallbackStatus: Int {
    case new = 0
    case start
    case arrive
    case complete
    case save
    case next
    case cancel
}

//struct CallbackProcessInfo {
//    
//    /// <summary>召修ID</summary>
//    var  callbackId: Int?
//    /// <summary>召修编号</summary>
//    var  callbackNo:String?
//    /// <summary>电梯编号</summary>
//    var  unitNo:String?
//    /// <summary>客户名称</summary>
//    var  customerName:String?
//    /// <summary>客户电话</summary>
//    var  customerTel:String?
//    /// <summary>出发时间</summary>
//    var  setOffTime:String?
//    /// <summary>到达时间</summary>
//    var  arrivalSiteTime:String?
//    /// <summary>完成时间</summary>
//    var  finishTime:String?
//    /// <summary>放人时间</summary>
//    var  pTrapRelsTime:String?
//    /// <summary>到场经度</summary>
//    var  arrivalSiteLong:String?
//    /// <summary>到场纬度</summary>
//    var  arrivalSiteLat:String?
//    /// <summary>离场经度</summary>
//    var  finishSiteLong:String?
//    /// <summary>离场纬度</summary>
//    var  finishSiteLat:String?
//    /// <summary>召修状态</summary>
//    var  callbackStatus:CallbackStatus
//    
//    func keyValues() -> [String: Any] {
//        return [
//            "callbackId":callbackId ?? 0,
//            "callbackNo":callbackNo ?? "",
//            "unitNo":unitNo ?? "",
//            "customerName":customerName ?? "",
//            "customerTel":customerTel ?? "",
//            "setOffTime":setOffTime ?? "",
//            "arrivalSiteTime":arrivalSiteTime ?? "",
//            "pTrapRelsTime":pTrapRelsTime ?? "",
//            "arrivalSiteLong":arrivalSiteLong ?? "",
//            "arrivalSiteLat":arrivalSiteLat ?? "",
//            "finishSiteLong":finishSiteLong ?? "",
//            "finishSiteLat":finishSiteLat ?? "",
//            "callbackStatus":callbackStatus.rawValue
//        ]
//    }
//    
//}







