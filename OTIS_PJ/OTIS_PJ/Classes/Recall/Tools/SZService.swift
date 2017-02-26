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
            return try! readJson2Data(fileName: "categories")
            
        case .areas:
            return try! readJson2Data(fileName: "areas")

        case .mains:
            return try! readJson2Data(fileName: "mains")

        case .subs:
            return try! readJson2Data(fileName: "subs")

        case .defects:
            return try! readJson2Data(fileName: "defects")
            
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

