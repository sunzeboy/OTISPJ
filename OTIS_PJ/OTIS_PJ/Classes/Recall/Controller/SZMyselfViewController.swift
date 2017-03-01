//
//  SZMyselfViewController.swift
//  OTIS_PJ
//
//  Created by sunze on 2017/2/21.
//  Copyright © 2017年 sunzeboy. All rights reserved.
//

import UIKit
import Moya
import SwiftyJSON
import SwiftyUserDefaults

class SZMyselfViewController: UIViewController {
    
    lazy var dataArray: [MyselfModel] = {
        let array = [MyselfModel]()
        return array
    }()
    lazy var tableView: UITableView = {
        let tView = UITableView(frame: self.view.bounds , style: .plain)
        tView.dataSource = self
        tView.delegate = self
        tView.contentInset = UIEdgeInsets(top: 90, left: 0, bottom: 0, right: 0)
        return tView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        dataArray.append(MyselfModel())
        dataArray.append(MyselfModel())
        dataArray.append(MyselfModel())
        
        
        
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
    


}


extension SZMyselfViewController: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = SZMyselfCell.cellWithTableView(tableView)

        return cell
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigationController?.pushViewController(SZRecallProcessViewController(), animated: true)

        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}
