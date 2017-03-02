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

class SZRecallViewController: SZPageViewController,BottomOperationable {

    var btns: [BtnModel] {
        
        return [BtnModel(title: "新增", picname: "add")];
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "召修"
        bottomView.actBlock = { (button:UIButton) -> Void in
            self.navigationController?.pushViewController(SZAddRecallViewController(), animated: true)
        }
                

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
                
                
            case let .failure(error):
                print(error)
                
            }
            
        }
        
        
        
        
        apiProvider.request(.areas(dtVer: Defaults[.areasVer])) { result in
            switch result {
            case let .success(moyaResponse):
                
                let json = JSON(data: moyaResponse.data)
                if json["errorCode"].int == 0 {
                    let ver = json["data"]["version"]
                    let data = json["data"]["areasLst"]
                    if ver.intValue != Defaults[.categoriesVer]  {
                        ComponentArea.storage(jsonData: data)
                        Defaults[.areasVer] = ver.intValue
                    }
                    print(data)
                }
                
            case let .failure(error):
                print(error)
                
            }
            
        }
        
        
        
        
        apiProvider.request(.mains(dtVer:  Defaults[.mainsVer])) { result in
            switch result {
            case let .success(moyaResponse):
                
                let json = JSON(data: moyaResponse.data)
                if json["errorCode"].int == 0 {
                    let ver = json["data"]["version"]
                    let data = json["data"]["mainsLst"]
                    if ver.intValue != Defaults[.categoriesVer]  {
                        MainComponent.storage(jsonData: data)
                        Defaults[.mainsVer] = ver.intValue
                    }
                    print(data)
                }
                
            case let .failure(error):
                print(error)
                
            }
            
        }
        
        
        apiProvider.request(.subs(dtVer: Defaults[.subsVer])) { result in
            switch result {
            case let .success(moyaResponse):
                
                let json = JSON(data: moyaResponse.data)
                if json["errorCode"].int == 0 {
                    let ver = json["data"]["version"]
                    let data = json["data"]["subsLst"]
                    if ver.intValue != Defaults[.categoriesVer]  {
                        SubComponent.storage(jsonData: data)
                        Defaults[.subsVer] = ver.intValue
                    }
                    print(data)
                }
                
            case let .failure(error):
                print(error)
                
            }
            
        }
        
        
        
        apiProvider.request(.defects(dtVer: Defaults[.defectsVer])) { result in
            switch result {
            case let .success(moyaResponse):
                
                let json = JSON(data: moyaResponse.data)
                if json["errorCode"].int == 0 {
                    let ver = json["data"]["ver"]
                    let data = json["data"]["defectsLst"]
                    if ver.intValue != Defaults[.categoriesVer]  {
                        Defect.storage(jsonData: data)
                        Defaults[.defectsVer] = ver.intValue
                    }
                    print(data)
                }
                
            case let .failure(error):
                print(error)
                
            }
            
        }

    }
    
//    func actBlock(button:UIButton) -> Void {
//        
//        navigationController?.pushViewController(SZAddRecallViewController(), animated: true)
//    }
    
}
