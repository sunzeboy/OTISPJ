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
import SVProgressHUD


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
        SVProgressHUD.dismiss()
    case .began:
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        SVProgressHUD.show()
        SVProgressHUD.setDefaultMaskType(.clear)
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
    case addNewCallback(callbackNo: String, customerName: String , customerTel: String )
    //获取召修过程信息
    case getCallbackProcess(intCallbId: Int)
    //更新召修状态
    case saveCallBackStatus(callbackProcessInfo: CallbackProcessInfo)
    //获取召修详细信息
    case getCallBackDetailInfo(intCallbId: Int)
    //保存召修详细信息
    case saveCallBackDetail(callbackProcessInfo: CallbackProcessInfo)
    //关闭或者完成召修单
    case closeCallBack(callbackId: Int ,isComplete: Int,shutdownReason: String,closeTime: String)
    //取消召修单
    case cancelCallBack(callbackId: Int ,currentStatus: Int,cancelReason: String,cancelTime: String)
    //召修单停梯处理
    case stopEveCallBack(callbackId: Int, isStop: Int)
    //接单
    case acceptOrder(intCallbId: Int)
    //查看上次召修信息
    case getLastCallBackInfo(intCallbId: Int)
}

extension SZService: TargetType {

    var baseURL: URL { return URL(string: "http://192.168.30.61/LBS_Mobile2/")! }
//    var baseURL: URL { return URL(string: "http://192.168.30.61:8081/")! }

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
            
        case .getCallbackProcess:
            return "CallBack/GetCallbackProcess"
            
        case .saveCallBackStatus:
            return "CallBack/SaveCallBackStatus"
            
        case .getCallBackDetailInfo:
            return "CallBack/GetCallBackDetailInfo"
            
        case .saveCallBackDetail:
            return "CallBack/SaveCallBackDetail"
   
        case .closeCallBack:
            return "CallBack/CloseCallBack"
            
        case .cancelCallBack:
            return "CallBack/CancelCallBack"

        case .stopEveCallBack:
            return "CallBack/StopEveCallBack"
            
        case .acceptOrder:
            return "CallBack/AcceptOrder"
            
        case .getLastCallBackInfo:
            return "CallBack/GetLastCallBackInfo"
        

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
        case .getCallbackProcess(intCallbId : let intCallbId ):
            return ["intCallbId":intCallbId]
            
        case .saveCallBackStatus(callbackProcessInfo: let callbackProcessInfo):
            print(["strHttpReq":callbackProcessInfo.keyValues()])
            return ["strHttpReq":callbackProcessInfo.keyValues()]
            
        case .getCallBackDetailInfo(intCallbId : let intCallbId ):
            return ["intCallbId":intCallbId]
            
        case .saveCallBackDetail(callbackProcessInfo: let callbackProcessInfo):
            print(["strHttpReq":callbackProcessInfo.keyValues()])
            return ["strHttpReq":callbackProcessInfo.keyValues()]
            
        case .closeCallBack(callbackId: let callbackId, isComplete: let isComplete, shutdownReason: let shutdownReason, closeTime: let closeTime):
            return [
                    "strHttpReq":["callbackId":callbackId,
                                  "isComplete":isComplete,
                                  "shutdownReason":shutdownReason,
                                  "closeTime":closeTime]
                    ]
        case .cancelCallBack(callbackId: let callbackId, currentStatus: let currentStatus, cancelReason: let cancelReason, cancelTime: let cancelTime):
            return [
                "strHttpReq":["callbackId":callbackId,
                              "currentStatus":currentStatus,
                              "cancelReason":cancelReason,
                              "cancelTime":cancelTime]
                    ]
        case .stopEveCallBack(callbackId: let callbackId, isStop: let isStop):
            return [
                "strHttpReq":["callbackId":callbackId,
                              "isStop":isStop]
            ]
  
        case .acceptOrder(intCallbId : let intCallbId ):
            return ["intCallbId":intCallbId]
            
        case .getLastCallBackInfo(intCallbId : let intCallbId ):
            return ["intCallbId":intCallbId]
            
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

