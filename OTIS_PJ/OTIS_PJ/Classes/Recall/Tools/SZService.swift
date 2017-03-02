//
//  SZService.swift
//  OTIS_PJ
//
//  Created by sunze on 2017/2/21.
//  Copyright © 2017年 sunzeboy. All rights reserved.
//

import UIKit
import Moya
import SwiftyJSON

//private func ruquestParameters(p:[String: Any]) -> [String: Any]? {
//    return [
//        
//        "strHttpReq" : ["head":["employeeID": OTISConfig.employeeID(),
//                                "password": OTISConfig.userPW(),
//                                "ver": "LBS_V10.0.0"],
//                        "body":p]
//        ]
//}


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
    
    "employeeID": OTISConfig.employeeID(),
    
    "password": OTISConfig.userPW(),
    
    "ver": "LBS_V10.0.0"
]

let endpointClosure = { (target: SZService) -> Endpoint<SZService> in
    
    let url = target.baseURL.appendingPathComponent(target.path).absoluteString
    
    return Endpoint(url: url,
        sampleResponseClosure: {.networkResponse(200, target.sampleData)},
        method: target.method,
        parameters: target.parameters,
        parameterEncoding: target.parameterEncoding,
        httpHeaderFields:headerFields)
    
}

let myStubClosure = { (target: SZService) -> Moya.StubBehavior in
    
    return StubBehavior.delayed(seconds: 1)
    
}


let apiProvider = MoyaProvider<SZService>(endpointClosure: endpointClosure,plugins:[networkPlugin1])
//let apiProvider = MoyaProvider<SZService>(stubClosure: myStubClosure,plugins: [networkPlugin1])


enum SZService {
    
    case categories(dtVer:Int)
    case areas(dtVer:Int)
    case mains(dtVer:Int)
    case subs(dtVer:Int)
    case defects(dtVer:Int)
    //0：本人召修  1：停梯召修
    case getCallBackList(callback_pageIndex:Int)
    //新增召修
    case addNewCallback(callbackNo:String, customerName:String , customerTel:String )

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
            
        case .getCallBackList:
            return "CallBack/GetCallBackList"
            
        case .addNewCallback:
            return "CallBack/AddNewCallback"
 

        }
    }
    
    var method: Moya.Method {
        return .post
        
    }
    
    var parameters: [String: Any]? {
        switch self {
            
        case .categories(dtVer:let dtVer),
             .areas(dtVer:let dtVer),
             .mains (dtVer:let dtVer),
             .subs(dtVer:let dtVer),
             .defects(dtVer:let dtVer):
//            let pa  = ruquestParameters(p: ["dtVer":dtVer])
//            print(pa ?? "")
            return ["dtVer":dtVer]
            
        case .getCallBackList(callback_pageIndex: let pageIndex):
            return ["callback_pageIndex":pageIndex]
            
        case .addNewCallback(callbackNo: let callbackNo, customerName: let customerName , customerTel: let customerTel):
            return [
                "strHttpReq":["callbackNo":callbackNo,
                            "customerName":customerName,
                            "customerTel":customerTel]
            ]
            

        }
    }
    
    var parameterEncoding: ParameterEncoding {
        
        return JSONEncoding.default // Send parameters as JSON in request body
        
    }
    
    var sampleData: Data {
        
        switch self {
            
        case .categories:
            return try! readJson2Data(fileName: "categories")
            
        case .areas:
            return try! readJson2Data(fileName: "areas")

        case .mains:
            return try! readJson2Data(fileName: "mains")

        case .subs:
            return try! readJson2Data(fileName: "subs")

        case .defects:
            return try! readJson2Data(fileName: "defects")
            
        default:
            return Data()

        }
    }
    
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

private func readJson2Data(fileName:String) throws -> Data {

    let path = Bundle.main.path(forResource: fileName, ofType: "json")
    
    return try Data(contentsOf: URL(fileURLWithPath: path!))
    
}

