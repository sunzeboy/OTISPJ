//
//  SZService.swift
//  OTIS_PJ
//
//  Created by sunze on 2017/2/21.
//  Copyright © 2017年 sunzeboy. All rights reserved.
//

import UIKit
import Moya

let networkPlugin1 = NetworkActivityPlugin { (change) -> () in
    
    print("networkPlugin \(change)")
    
    switch(change){
        
    case .ended:
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        
    case .began:
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
    }        
}

let headerFields: Dictionary<String, String> = [
    
    "epId": OTISConfig.employeeID(),
    
    "psd": OTISConfig.userPW()
]

let endpointClosure = { (target: SZService) -> Endpoint<SZService> in
    
    let url = target.baseURL.appendingPathComponent(target.path).absoluteString
    
    return Endpoint(url: url,
        sampleResponseClosure: {.networkResponse(200, target.sampleData)},
        method: target.method,
        parameters: target.parameters,
        parameterEncoding: target.parameterEncoding,
        httpHeaderFields: headerFields)
    
}

let myStubClosure = { (target: SZService) -> Moya.StubBehavior in
    
    return StubBehavior.delayed(seconds: 3)
    
}


//let apiProvider = MoyaProvider<SZService>(endpointClosure: endpointClosure,plugins:networkPlugin1)
let apiProvider = MoyaProvider<SZService>(stubClosure: myStubClosure,plugins: [networkPlugin1])


enum SZService {
    
    case categories(intfVer:String,dtVer:Int)
    case areas(intfVer:String,dtVer:Int)
    case mains(intfVer:String,dtVer:Int)
    case subs(intfVer:String,dtVer:Int)
    case defects(intfVer:String,dtVer:Int)

}

extension SZService: TargetType {

    var baseURL: URL { return URL(string: "http://192.168.30.61/LBS_Mobile2/")! }
    
    var path: String {
        switch self {
        case .categories:
            return "CallBack/CategoriesForOffline"
        case .areas:
            return "CallBack/AreasForOffline"
        case .mains:
            return "CallBack/MainsForOffline"
        case .subs:
            return "CallBack/SubsForOffline"
        case .defects:
            return "CallBack/DefectsForOffline"
        
        }
    }
    
    var method: Moya.Method {
        return .post
        
    }
    
    var parameters: [String: Any]? {
        switch self {
        
        case .categories(intfVer:let intfVer, dtVer:let dtVer),
             .areas(intfVer:let intfVer, dtVer:let dtVer),
             .mains (intfVer:let intfVer, dtVer:let dtVer),
             .subs(intfVer:let intfVer, dtVer:let dtVer),
             .defects(intfVer:let intfVer, dtVer:let dtVer):
            return ["intfVer": intfVer, "dtVer": dtVer]
            
        }
    }
    
    var parameterEncoding: ParameterEncoding {
        
        return JSONEncoding.default // Send parameters as JSON in request body
        
    }
    
    var sampleData: Data {
        
        switch self {
        case .categories:
           
            return try! JSONSerialization.data(withJSONObject: [
                "errorCode": 0,
                "message": "操作成功！",
                "data": [
                    "categoriesLst": [[
                        "categoryId": 1,
                        "categoryName": "停梯ELEVATOR STOPPED",
                        "categoryShortName": "A",
                        "categoryNameZh": "A-停梯"
                        ], [
                            "categoryId": 2,
                            "categoryName": "运行中出现的故障(需调整)PERFORMANCE DETERIORATION",
                            "categoryShortName": "B",
                            "categoryNameZh": "B-运行中出现的故障(需调整)"
                        ], [
                            "categoryId": 3,
                            "categoryName": "轻微问题MINOR PROBLEMS",
                            "categoryShortName": "C",
                            "categoryNameZh": "C-轻微问题"
                        ], [
                            "categoryId": 4,
                            "categoryName": "用户或其它问题CUSTOMER OR OTHER",
                            "categoryShortName": "D",
                            "categoryNameZh": "D-用户或其它问题"
                        ], [
                            "categoryId": 5,
                            "categoryName": "乘客被困/安全问题TRAPPED PASSENGERS",
                            "categoryShortName": "X",
                            "categoryNameZh": "X-乘客被困/安全问题"
                        ]]
                ]
                ]
                , options: .prettyPrinted)
        case .areas:
            return try! JSONSerialization.data(withJSONObject: [
                "errorCode": 0,
                "message": "操作成功！",
                "data": [
                    "areasLst": [[
                    "areaID": 1,
                    "areaName": "机房MACHINE ROOM",
                    "areaShortName": "1",
                    "areaNameZh": "机房"
                    ], [
                    "areaID": 2,
                    "areaName": "井道HOISTWAY",
                    "areaShortName": "2",
                    "areaNameZh": "井道"
                    ], [
                    "areaID": 3,
                    "areaName": "轿厢CAR",
                    "areaShortName": "3",
                    "areaNameZh": "轿厢"
                    ], [
                    "areaID": 4,
                    "areaName": "扶梯/观光梯ESCALATOR/TRAV - O - LATOR",
                    "areaShortName": "4",
                    "areaNameZh": "扶梯/观光梯"
                    ], [
                    "areaID": 5,
                    "areaName": "外围设备PERIPHERAL DEVICES",
                    "areaShortName": "5",
                    "areaNameZh": "外围设备"
                    ], [
                    "areaID": 6,
                    "areaName": "杂项MISCELLANEOUS",
                    "areaShortName": "6",
                    "areaNameZh": "杂项"
                    ], [
                    "areaID": 7,
                    "areaName": "客户原因CUSTOMER REASON",
                    "areaShortName": "7",
                    "areaNameZh": "客户原因"
                    ]]
                ]
            ]
                , options: .prettyPrinted)
        case .mains:
            return try! JSONSerialization.data(withJSONObject: [
                "errorCode": 0,
                "message": "操作成功！",
                "data": [
                    "mainsLst": [[
                        "mainID": 1,
                        "mainCode": "1A",
                        "mainName": "控制柜 Controller",
                        "mainShortName": "",
                        "mainNameZh": "控制柜",
                        "areaID": 1
                        ], [
                            "mainID": 2,
                            "mainCode": "1B",
                            "mainName": "主机 Main Motor",
                            "mainShortName": "",
                            "mainNameZh": "主机",
                            "areaID": 1
                        ]]
                ]
                ]
                , options: .prettyPrinted)
        case .subs:
            return try! JSONSerialization.data(withJSONObject: [
                "errorCode": 0,
                "message": "操作成功！",
                "data": [
                    "subsLst": [[
                        "subID": 1,
                        "subCode": "0A",
                        "subName": "断路开关（空气开关）Broken Circuit Switch",
                        "subShortName": "",
                        "subNameZh": "断路开关（空气开关）",
                        "mainCode": "1A"
                        ], [
                            "subID": 2,
                            "subCode": "0B",
                            "subName": "电容器 Capacitor",
                            "subShortName": "",
                            "subNameZh": "电容器",
                            "mainCode": "1A"
                        ], [
                            "subID": 3,
                            "subCode": "0C",
                            "subName": "二极管 Diodes",
                            "subShortName": "",
                            "subNameZh": "二极管",
                            "mainCode": "1A"
                        ], [
                            "subID": 4,
                            "subCode": "0D",
                            "subName": "电子计时器Electronic Timer",
                            "subShortName": "",
                            "subNameZh": "电子计时器",
                            "mainCode": "1A"
                        ]]
                ]
                ]
                , options: .prettyPrinted)
        case .defects:
            return try! JSONSerialization.data(withJSONObject: [
                "errorCode": 0,
                "message": "操作成功！",
                "data": [
                    "defectsLst": [[
                        "defectID": 1,
                        "defectCode": "0A",
                        "defectName": "老化 Aging",
                        "defectShortName": "",
                        "defectNameZh": "老化",
                        "subCode": "0A"
                        ], [
                            "defectID": 2,
                            "defectCode": "0B",
                            "defectName": "接线问题 Bad connection",
                            "defectShortName": "",
                            "defectNameZh": "接线问题",
                            "subCode": "0A"
                        ], [
                            "defectID": 3,
                            "defectCode": "0C",
                            "defectName": "烧毁 Burn out",
                            "defectShortName": "",
                            "defectNameZh": "烧毁",
                            "subCode": "0A"
                        ]]
                ]
                ]
                , options: .prettyPrinted)
            
        }    }
    
    var task: Task {
        
        return .request
        
    }

}


// MARK: - Helpers
private extension String {
    var urlEscaped: String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
    
    var utf8Encoded: Data {
        return self.data(using: .utf8)!
    }
}



