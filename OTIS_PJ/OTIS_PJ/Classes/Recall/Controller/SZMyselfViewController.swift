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
    
    lazy var dataArray: [JSON] = {
        let array = [JSON]()
        return array
    }()
    lazy var tableView: UITableView = {
        let tView = UITableView(frame: self.view.bounds , style: .plain)
        tView.dataSource = self
        tView.delegate = self
        tView.contentInset = UIEdgeInsets(top: 90, left: 0, bottom: 0, right: 0)
        return tView
    }()
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        requestData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        
        
        
        
        
        
        
        
        
        
                

    }
    
    func requestData() {
        apiProvider.request(.getCallBackList(callback_pageIndex: 0)) { result in
            switch result {
            case let .success(moyaResponse):
                let json = JSON(data: moyaResponse.data)
                if json["errorCode"].int == 0 {
                    self.dataArray = json["data"]["callbackLst"].arrayValue
                    self.tableView.reloadData()
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
        cell.myCallBackItem = dataArray[indexPath.row].dictionary!
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
