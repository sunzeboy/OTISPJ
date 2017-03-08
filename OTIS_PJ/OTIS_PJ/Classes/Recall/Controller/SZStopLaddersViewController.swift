//
//  SZStopLaddersViewController.swift
//  OTIS_PJ
//
//  Created by sunze on 2017/2/21.
//  Copyright © 2017年 sunzeboy. All rights reserved.
//

import UIKit
import SwiftyJSON

class SZStopLaddersViewController: UIViewController,Emptyable {
    
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
        apiProvider.request(.getCallBackList(callback_pageIndex: 1)) { result in
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
                        self.view.addSubview(self.tableView)
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



extension SZStopLaddersViewController: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = SZMyselfCell.cellWithTableView(tableView)
        cell.myCallBackItem = dataArray[indexPath.row].dictionary!
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = SZLastProcessingResultViewController()
        let jsonData = dataArray[indexPath.row]
        vc.intCallbId = jsonData["callbackId"].int!
        navigationController?.pushViewController(vc, animated: true)
        
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}



