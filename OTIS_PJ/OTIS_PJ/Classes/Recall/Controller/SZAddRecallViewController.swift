//
//  SZAddRecallViewController.swift
//  OTIS_PJ
//
//  Created by sunze on 2017/2/21.
//  Copyright © 2017年 sunzeboy. All rights reserved.
//

import UIKit
import SwiftyJSON


class SZAddRecallViewController: UIViewController,BottomOperationable {
    var btns: [BtnModel] {
        return [BtnModel(title: "保存", picname: "save"),
                BtnModel(title: "取消", picname: "cancel")];
    }
    
    @IBOutlet weak var recallCodeTF: UITextField!
    
    @IBOutlet weak var customerNameTF: UITextField!
    
    @IBOutlet weak var customerPhoneTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "新增召修"
        bottomView.actBlock = { (button:UIButton) -> Void in
            if button.title(for: .normal)=="保存" {
                self.saveAct()
            }else{
            
            }
        }

        
    }
    
    
    func saveAct() {

        if recallCodeTF.text?.characters.count != 7 {
            showAlert(dialogContents:"召修编号输入错误，请输入7位数字！")
            return
        }
        if (customerNameTF.text?.isEmpty)! {
            showAlert(dialogContents:"请输入客户名称！")
            return
        }
        if isTelNumber(num: customerPhoneTF.text!) {
            showAlert(dialogContents:"请输入正确的手机号码！")
            return
        }

        
        apiProvider.request(.addNewCallback(callbackNo: recallCodeTF.text!, customerName: customerNameTF.text!, customerTel: customerPhoneTF.text!)) {  result in
            switch result {
            case let .success(moyaResponse):
                let json = JSON(data: moyaResponse.data)
                if json["errorCode"].int == 0 {
                    self.navigationController?.popViewController(animated: true)

                    let data = json["data"]["callbackLst"]
                    
                    print(data)
                }
                
                
            case let .failure(error):
                print(error)
                
            }
        }

    }
    
    
}
