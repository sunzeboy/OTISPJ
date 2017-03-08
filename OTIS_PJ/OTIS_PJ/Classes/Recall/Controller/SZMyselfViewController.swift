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

class SZMyselfViewController: UIViewController,BottomOperationable,Emptyable {
    
    var btns: [BtnModel] {
        
        return [BtnModel(title: "新增", picname: "add")];
    }
    
    
    lazy var dataArray: [JSON] = {
        let array = [JSON]()
        return array
    }()
    lazy var tableView: UITableView = {
        let tView = UITableView(frame: self.view.bounds , style: .plain)
        tView.dataSource = self
        tView.delegate = self
        tView.contentInset = UIEdgeInsets(top: 90, left: 0, bottom: bottomViewH, right: 0)
        return tView
    }()
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        requestData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        
        bottomView.actBlock = { (button:UIButton) -> Void in
            self.navigationController?.pushViewController(SZAddRecallViewController(), animated: true)
        }
                

    }
    
    func requestData() {
        apiProvider.request(.getCallBackList(callback_pageIndex: 0)) { result in
            switch result {
            case let .success(moyaResponse):
                let json = JSON(data: moyaResponse.data)
                if json["errorCode"].int == 0 {
                    self.dataArray = json["data"]["callbackLst"].arrayValue
                    if self.dataArray.count == 0{
                        self.tableView.removeFromSuperview()
                        self.showEmptyDataStyle()

                    }else{
                        self.view.viewWithTag(k_nullViewTag)?.removeFromSuperview()
                        self.view.insertSubview(self.tableView, belowSubview: self.bottomView)
                        self.tableView.reloadData()
                    }
                    return
                }
                if let message = json["message"].string {
                    showAlert(dialogContents:"\(message)")
                }

                
            case .failure(_):
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: k_noNetwork), object: self, userInfo: nil)
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
        let vc = SZRecallProcessViewController()
        let jsonData = dataArray[indexPath.row]
        vc.intCallbId = jsonData["callbackId"].int!
        if let jsonStr = jsonData["callbackNo"].string {
            vc.isStopLadders = jsonStr.hasPrefix("T")
        }

        let state = jsonData["callbackStatus"].int
        
        if state == 0 {
            vc.state = .new
        }else if state == 1 {
            vc.state = .start
        }else if state == 2 {
            vc.state = .arrive
        }else if state == 3 {
            vc.state = .complete
        }
        
        
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
}
