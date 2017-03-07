//
//  SZLastProcessingResultViewController.swift
//  OTIS_PJ
//
//  Created by sunze on 2017/3/6.
//  Copyright © 2017年 sunzeboy. All rights reserved.
//

import UIKit
import SwiftyJSON


class SZLastProcessingResultViewController: UIViewController,BottomOperationable {
    var btns: [BtnModel] {
        return [BtnModel(title: "接单", picname: "orders")];
    }
    var intCallbId: Int = 0
    
    @IBOutlet weak var fangRenTF: UITextField!

    @IBOutlet weak var recallCategory: UILabel!
    
    @IBOutlet weak var componentArea: UILabel!
    
    @IBOutlet weak var mainComponent: UILabel!
    
    @IBOutlet weak var secondaryPart: UILabel!
    
    @IBOutlet weak var code: UILabel!
    
    @IBOutlet weak var closeInformationTV: UITextView!
    
    @IBOutlet weak var failureCauseTV: UITextView!
    
    @IBOutlet weak var failurePhenomenonTV: UITextView!
    
    @IBOutlet weak var treatmentResultTV: UITextView!
    
    @IBOutlet weak var contentView: UIScrollView!
    
    override func viewWillAppear(_ animated: Bool) {
        
        requestData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        defaultConfiguration()
        
        title = "上次召修处理信息"
        contentView.contentSize = CGSize(width: 0, height: 900)
        contentView.alwaysBounceVertical = true
        bottomView.actBlock = {(button:UIButton) -> Void in
            self.acceptOrder()
        }

    }
    
    func defaultConfiguration() {

    }
    
    
    func requestData() {
        apiProvider.request(.getLastCallBackInfo(intCallbId: intCallbId) ) { result in
            switch result {
            case let .success(moyaResponse):
                let json = JSON(data: moyaResponse.data)
                if json["errorCode"].int == 0 {

                    self.updateDataOnView(json: json["data"])
                }
                
                
            case .failure(_):
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: k_noNetwork), object: self, userInfo: nil)
                
            }
            
        }
    }

    
    func updateDataOnView(json: JSON) {
        
        treatmentResultTV.text = json["results"].string
        closeInformationTV.text = json["pTrapInfo"].string
        failureCauseTV.text = json["faultCause"].string
        failurePhenomenonTV.text = json["faultPhenomenon"].string
        componentArea.text = json["areaName"].string
        recallCategory.text = json["categoryName"].string
        mainComponent.text = json["mainName"].string
        secondaryPart.text = json["subName"].string
        code.text = json["defectName"].string
    }

    func acceptOrder() {
        apiProvider.request(.acceptOrder(intCallbId: intCallbId) ) { result in
            switch result {
            case let .success(moyaResponse):
                let json = JSON(data: moyaResponse.data)
                if json["errorCode"].int == 0 {
                    self.navigationController?.popViewController(animated: true)
                }
                
                
            case .failure(_):
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: k_noNetwork), object: self, userInfo: nil)
                
            }
            
        }
    }


}
