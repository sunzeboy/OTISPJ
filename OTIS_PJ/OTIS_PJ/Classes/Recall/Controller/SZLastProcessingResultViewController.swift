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

    @IBOutlet weak var recallCategory: SZDropDownMenu!
    
    @IBOutlet weak var componentArea: SZDropDownMenu!
    
    @IBOutlet weak var mainComponent: SZDropDownMenu!
    
    @IBOutlet weak var secondaryPart: SZDropDownMenu!
    
    @IBOutlet weak var code: SZDropDownMenu!
    
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

        title = "上次召修处理信息"
        contentView.contentSize = CGSize(width: 0, height: 900)
        contentView.alwaysBounceVertical = true
        bottomView.actBlock = {(button:UIButton) -> Void in
            self.acceptOrder()
        }

    }
    
    func requestData() {
        apiProvider.request(.getLastCallBackInfo(intCallbId: intCallbId) ) { result in
            switch result {
            case let .success(moyaResponse):
                let json = JSON(data: moyaResponse.data)
                if json["errorCode"].int == 0 {

                    self.updateDataOnView(json: json)
                }
                
                
            case let .failure(error):
                print(error)
                
            }
            
        }
    }

    
    func updateDataOnView(json: JSON) {
        
        treatmentResultTV.text = json["results"].string
        closeInformationTV.text = json["pTrapInfo"].string
        failureCauseTV.text = json["faultCause"].string
        failurePhenomenonTV.text = json["faultPhenomenon"].string
        componentArea.contentTextField.text = json["faultPhenomenon"].string
        recallCategory.contentTextField.text = json["faultPhenomenon"].string
        mainComponent.contentTextField.text = json["faultPhenomenon"].string
        secondaryPart.contentTextField.text = json["faultPhenomenon"].string
        code.contentTextField.text = json["faultPhenomenon"].string
        
    }

    func acceptOrder() {
        apiProvider.request(.acceptOrder(intCallbId: intCallbId) ) { result in
            switch result {
            case let .success(moyaResponse):
                let json = JSON(data: moyaResponse.data)
                if json["errorCode"].int == 0 {
                    self.navigationController?.popViewController(animated: true)
                }
                
                
            case let .failure(error):
                print(error)
                
            }
            
        }
    }


}
