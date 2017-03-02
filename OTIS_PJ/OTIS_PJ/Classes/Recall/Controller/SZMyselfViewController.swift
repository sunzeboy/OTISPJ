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
        
//        apiProvider.request(.getCallBackList(callback_pageIndex: 0)) { result in
//            switch result {
//            case let .success(moyaResponse):
//                let json = JSON(data: moyaResponse.data)
//                if json["errorCode"].int == 0 {
//                    let data = json["data"]["callbackLst"]
//
//                    print(data)
//                }
//                
//                
//            case let .failure(error):
//                print(error)
//                
//            }
//            
//        }
        
        
        
        apiProvider.request(.addNewCallback(callbackNo: "1234567", customerName: "fsaf", customerTel: "13162153278")) { result in
            switch result {
            case let .success(moyaResponse):
                let json = JSON(data: moyaResponse.data)
                if json["errorCode"].int == 0 {
                    let data = json["data"]["callbackLst"]
                    
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
