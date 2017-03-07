//
//  SZRecallViewController.swift
//  OTIS_PJ
//
//  Created by sunze on 2017/2/21.
//  Copyright © 2017年 sunzeboy. All rights reserved.
//

import UIKit
import SwiftyUserDefaults
import SwiftyJSON
import IQKeyboardManagerSwift

class SZRecallViewController: SZPageViewController {


    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        downloadDatas()
        
        IQKeyboardManager.sharedManager().enable = true
        IQKeyboardManager.sharedManager().shouldResignOnTouchOutside = true
        title = "召修"
                

    }
    
    
    
    override func setupChildVces() {
        let subVc1 = SZMyselfViewController()
        subVc1.title = "本人召修"
        addChildViewController(subVc1)
        
        let subVc2 = SZStopLaddersViewController()
        subVc2.title = "停梯工单"
        addChildViewController(subVc2)
    }

    
    
    func downloadDatas() {
        
        if Defaults[.categoriesVer] == 0 {
            Defaults[.categoriesVer] = -1
        }
        apiProvider.request(.categories(dtVer: Defaults[.categoriesVer])) { result in
            switch result {
            case let .success(moyaResponse):
                let json = JSON(data: moyaResponse.data)
                if json["errorCode"].int == 0 {
                    let ver = json["data"]["version"]
                    let data = json["data"]["categoriesLst"]
                    if ver.intValue != Defaults[.categoriesVer]  {
                        RecallCategory.storage(jsonData: data)
                        Defaults[.categoriesVer] = ver.intValue
                    }
                    print(data)
                }
                
                
            case .failure(_):
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: k_noNetwork), object: self, userInfo: nil)
                
            }
            
        }
        
        
        
        if Defaults[.areasVer] == 0 {
            Defaults[.areasVer] = -1
        }
        apiProvider.request(.areas(dtVer: Defaults[.areasVer])) { result in
            switch result {
            case let .success(moyaResponse):
                
                let json = JSON(data: moyaResponse.data)
                if json["errorCode"].int == 0 {
                    let ver = json["data"]["version"]
                    let data = json["data"]["areasLst"]
                    if ver.intValue != Defaults[.areasVer]  {
                        ComponentArea.storage(jsonData: data)
                        Defaults[.areasVer] = ver.intValue
                    }
                    print(data)
                }
                
            case .failure(_):
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: k_noNetwork), object: self, userInfo: nil)
                
            }
            
        }
        
        
        
        if Defaults[.mainsVer] == 0 {
            Defaults[.mainsVer] = -1
        }
        apiProvider.request(.mains(dtVer:  Defaults[.mainsVer])) { result in
            switch result {
            case let .success(moyaResponse):
                
                let json = JSON(data: moyaResponse.data)
                if json["errorCode"].int == 0 {
                    let ver = json["data"]["version"]
                    let data = json["data"]["mainsLst"]
                    if ver.intValue != Defaults[.mainsVer]  {
                        MainComponent.storage(jsonData: data)
                        Defaults[.mainsVer] = ver.intValue
                    }
                    print(data)
                }
                
            case .failure(_):
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: k_noNetwork), object: self, userInfo: nil)
                
            }
            
        }
        
        if Defaults[.subsVer] == 0 {
            Defaults[.subsVer] = -1
        }
        apiProvider.request(.subs(dtVer: Defaults[.subsVer])) { result in
            switch result {
            case let .success(moyaResponse):
                
                let json = JSON(data: moyaResponse.data)
                if json["errorCode"].int == 0 {
                    let ver = json["data"]["version"]
                    let data = json["data"]["subsLst"]
                    if ver.intValue != Defaults[.subsVer]  {
                        SubComponent.storage(jsonData: data)
                        Defaults[.subsVer] = ver.intValue
                    }
                    print(data)
                }
                
            case .failure(_):
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: k_noNetwork), object: self, userInfo: nil)
                
            }
            
        }
        
        
        if Defaults[.defectsVer] == 0 {
            Defaults[.defectsVer] = -1
        }
        apiProvider.request(.defects(dtVer: Defaults[.defectsVer])) { result in
            switch result {
            case let .success(moyaResponse):
                
                let json = JSON(data: moyaResponse.data)
                if json["errorCode"].int == 0 {
                    let ver = json["data"]["ver"]
                    let data = json["data"]["defectsLst"]
                    if ver.intValue != Defaults[.defectsVer]  {
                        Defect.storage(jsonData: data)
                        Defaults[.defectsVer] = ver.intValue
                    }
                    print(data)
                }
                
            case .failure(_):
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: k_noNetwork), object: self, userInfo: nil)
                
            }
            
        }

    }
    
    
}
