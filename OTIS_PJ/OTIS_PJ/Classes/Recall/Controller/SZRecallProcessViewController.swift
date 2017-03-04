//
//  SZRecallProcessViewController.swift
//  OTIS_PJ
//
//  Created by sunze on 2017/2/21.
//  Copyright © 2017年 sunzeboy. All rights reserved.
//

import UIKit
import SwiftyJSON





class SZRecallProcessViewController: UIViewController,BottomOperationable {
    
    var intCallbId: Int = 0
    
    
    
    var btns: [BtnModel] {
        return [BtnModel(title: "出发", picname: "start"),
                BtnModel(title: "到达扫描", picname: "scan"),
                BtnModel(title: "放人", picname: "rescue"),
                BtnModel(title: "完成扫描", picname: "scan"),
                BtnModel(title: "下一步", picname: "next"),
                BtnModel(title: "取消", picname: "cancel"),];
    }

    /// 召修编号
    @IBOutlet weak var recallCode: UILabel!
    
    /// 客户名称
    @IBOutlet weak var customerName: UILabel!

    /// 客户电话
    @IBOutlet weak var customerPhone: UILabel!
    
    /// 开始时间
    @IBOutlet weak var startTime: UILabel!
    
    /// 电梯编号
    @IBOutlet weak var eleCodeTF: UITextField!
    
    /// 到达时间
    @IBOutlet weak var arriveTime: UILabel!
    
    /// 到达经度
    @IBOutlet weak var arriveLo: UILabel!
    
    /// 到达纬度
    @IBOutlet weak var arriveLa: UILabel!
    
    /// 完成时间
    @IBOutlet weak var completeTime: UILabel!
    
    /// 完成经度
    @IBOutlet weak var completeLo: UILabel!
    
    /// 完成纬度
    @IBOutlet weak var completeLa: UILabel!
    
    @IBOutlet weak var rescueTime: UITextField!
    
    override func viewWillAppear(_ animated: Bool) {
        
        requestData()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "召修过程"
        
        let datePicker = KMDatePicker(frame: CGRect(x: 0, y: 0, width: k_screenW, height: 216.0), delegate: self, datePickerStyle: .yearMonthDayHourMinute)
        rescueTime.inputView = datePicker
        
        bottomView.actBlock = { (button:UIButton) -> Void in
            if button.title(for: .normal)=="下一步" {
                
                
            }else if button.title(for: .normal)=="完成扫描" {
                self.postCallBackStatus()

            
            }else if button.title(for: .normal)=="到达扫描" {
                self.postCallBackStatus()

                
            }else if button.title(for: .normal)=="出发" {
                
                self.postCallBackStatus()
            
            }else if button.title(for: .normal)=="放人" {
                
                
            }else if button.title(for: .normal)=="取消" {
                
                
            }
            
//            self.navigationController?.popViewController(animated: true)
        }

        
    }
    
    func requestData() {
        apiProvider.request(.getCallbackProcess(intCallbId : intCallbId  )) { result in
            switch result {
            case let .success(moyaResponse):
                let json = JSON(data: moyaResponse.data)
                if json["errorCode"].int == 0 {
                    
                    self.updateDataOnView(json: json["data"])
                    
                }
                
                
            case let .failure(error):
                print(error)
                
            }
            
        }
    }
    
    
    func updateDataOnView(json: JSON) {
            recallCode.text = json["callbackNo"].string
            customerName.text = json["customerName"].string
            customerPhone.text = json["customerTel"].string
            startTime.text = json["setOffTime"].string
            eleCodeTF.text = json["unitNo"].string
            arriveTime.text = json["arrivalSiteTime"].string
            arriveLo.text = json["arrivalSiteLong"].string
            arriveLa.text = json["arrivalSiteLat"].string
            completeTime.text = json["finishTime"].string
            completeLo.text = json["finishSiteLong"].string
            completeLa.text = json["finishSiteLat"].string
        
    }
    
    

    
    func postCallBackStatus() {

        apiProvider.request(.saveCallBackStatus(callbackProcessInfo: CallbackProcessInfo(callbackId: intCallbId,
                                                                                         callbackNo: recallCode.text,
                                                                                         unitNo: eleCodeTF.text,
                                                                                         customerName: customerName.text,
                                                                                         customerTel: customerPhone.text,
                                                                                         setOffTime: startTime.text,
                                                                                         arrivalSiteTime: arriveTime.text,
                                                                                         finishTime: completeTime.text,
                                                                                         pTrapRelsTime: rescueTime.text,
                                                                                         arrivalSiteLong: arriveLo.text,
                                                                                         arrivalSiteLat: arriveLa.text,
                                                                                         finishSiteLong: completeLo.text,
                                                                                         finishSiteLat: completeLa.text,
                                                                                         callbackStatus: .start)))
        { result in
                                                                                            
                                                                                            
            switch result {
            case let .success(moyaResponse):
                let json = JSON(data: moyaResponse.data)
                if json["errorCode"].int == 0 {
//                    self.dataArray = json["data"]["callbackLst"].arrayValue
//                    self.tableView.reloadData()
                }
                
                
            case let .failure(error):
                print(error)
                
            }
            
        }
    }


}


extension SZRecallProcessViewController: KMDatePickerDelegate {
    
    func datePicker(_ datePicker: KMDatePicker!, didSelectDate datePickerDate: KMDatePickerDateModel!) {
        rescueTime.text = datePickerDate.year + "-"
            + datePickerDate.month + "-"
            + datePickerDate.day + "  "
            + datePickerDate.hour + ":"
            + datePickerDate.minute
    }
    
}


