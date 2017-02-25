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
        
        let provider = MoyaProvider<SZService>()
        
        provider.request(.categories(intfVer: "LBS_V10.0.0", dtVer: -1)) { result in
            switch result {
            case let .success(moyaResponse):
                
                let json = JSON(data: moyaResponse.data)
                if json["errorCode"].int == 0 {
                let data = json["data"]["categoriesLst"]
                    print(data)
                }
                
            // do something with the response data or statusCode
            case let .failure(error):
                print(error)
                // this means there was a network failure - either the request
                // wasn't sent (connectivity), or no response was received (server
                // timed out).  If the server responds with a 4xx or 5xx error, that
                // will be sent as a ".success"-ful response.
            }
            print(result)
        }
        
        
        
        let provider2 = MoyaProvider<SZService>()
        provider2.request(.areas(intfVer: "LBS_V10.0.0", dtVer: -1)) { result in
            switch result {
            case let .success(moyaResponse):
                let json = JSON(data: moyaResponse.data)
                if json["errorCode"].int == 0 {
                    let data = json["data"]["areasLst"]
                    print(data)
                }
            // do something with the response data or statusCode
            case let .failure(error):
                print(error)
                // this means there was a network failure - either the request
                // wasn't sent (connectivity), or no response was received (server
                // timed out).  If the server responds with a 4xx or 5xx error, that
                // will be sent as a ".success"-ful response.
            }
            print(result)
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
