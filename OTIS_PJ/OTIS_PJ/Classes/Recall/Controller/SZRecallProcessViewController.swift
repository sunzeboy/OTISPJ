//
//  SZRecallProcessViewController.swift
//  OTIS_PJ
//
//  Created by sunze on 2017/2/21.
//  Copyright © 2017年 sunzeboy. All rights reserved.
//

import UIKit
import SwiftyJSON
import SwiftyUserDefaults




class SZRecallProcessViewController: UIViewController,BottomOperationable,Scanable {
    
    var currentBtn: UIButton?
    
   override var qRItem: SZQRCodeProcotolitem? {
        willSet {
            
        }
        didSet {
            if let unitNo = qRItem?.unit_NO {
                eleCodeTF.text = unitNo
            }
            if self.currentBtn?.currentTitle == "到达扫描" {
                postCallBackStatus(callbackState: .arrive)
            }else if self.currentBtn?.currentTitle == "完成扫描" {
                postCallBackStatus(callbackState: .complete)
            }else if self.currentBtn?.currentTitle == "出发" {
                postCallBackStatus(callbackState: .start)
            }

        }
    }
    
    //是否停梯，默认为否
    var isStopLadders:Bool = false
    
    //当前界面的状态
    var state: CallbackStatus = .new {
        
        willSet {
            
        }
        didSet {
            
            switch state {
                
                case .new:
                    bottomView.btns.forEach{ (btn) in
                        if btn.currentTitle == "出发" || btn.currentTitle == "取消" {
                            btn.isEnabled = true
                        }else {
                            btn.isEnabled = false
                        }
                    }
                case .start:
                    bottomView.btns.forEach{ (btn) in
                        if btn.currentTitle == "出发" || btn.currentTitle == "完成扫描" || btn.currentTitle == "下一步" {
                            btn.isEnabled = false
                        }else {
                            btn.isEnabled = true
                        }
                    }
                case .arrive:
                    bottomView.btns.forEach{ (btn) in
                        if btn.currentTitle == "到达扫描" || btn.currentTitle == "取消" || btn.currentTitle == "下一步" || btn.currentTitle == "出发" {
                            btn.isEnabled = false
                        }else {
                            btn.isEnabled = true
                        }
                    }
                
                case .complete:
                    bottomView.btns.forEach{ (btn) in
                        if btn.currentTitle == "完成扫描" || btn.currentTitle == "取消" || btn.currentTitle == "出发" || btn.currentTitle == "到达扫描" || btn.currentTitle == "放人"  {
                            btn.isEnabled = false
                        }else {
                            btn.isEnabled = true
                        }
                }

                
                case .save: break
                
                case .next: break
                
                case .cancel: break

                    
            }
        }
    }
    
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
    
    var alertView: ABAlertView?

    override func viewWillAppear(_ animated: Bool) {
        
        requestData()
    }
    
    deinit {
        print(self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "召修过程"
//        state = .new
        
        let datePicker = KMDatePicker(frame: CGRect(x: 0, y: 0, width: k_screenW, height: 216.0), delegate: self, datePickerStyle: .yearMonthDayHourMinute)
        rescueTime.inputView = datePicker
        
        bottomView.actBlock = { (button:UIButton) -> Void in
            self.currentBtn = button
            if button.currentTitle == "下一步" {
                let vc = SZRecallInputViewController()
                vc.isStopLadders = self.isStopLadders
                vc.intCallbId = self.intCallbId
                self.navigationController?.pushViewController(vc, animated: true)
                
            }else if button.currentTitle == "完成扫描" {
//                self.state = .complete
                self.completeLo.text = Defaults[.userLastLocationLon]
                self.completeLa.text = Defaults[.userLastLocationLat]
                self.ZhiFuBaoStyle(self)
            
            }else if button.currentTitle == "到达扫描" {
//                self.state = .arrive  
                
                self.arriveLo.text = Defaults[.userLastLocationLon]
                self.arriveLa.text = Defaults[.userLastLocationLat]
                self.ZhiFuBaoStyle(self)
                
            }else if button.currentTitle == "出发" {
//                self.state = .start
                self.postCallBackStatus(callbackState: .start)
            
            }else if button.currentTitle == "放人" {

                let timeFormatter = DateFormatter()
                timeFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss" 
                self.rescueTime.text = timeFormatter.string(from: Date())
                
            }else if button.currentTitle == "取消" {
                
               self.cancleAlert()
                
            }
            

        }

        
    }
    
    func cancleAlert() {
        self.alertView = ABAlertView.init(frame: UIScreen.main.bounds)
        let contentView = CancleAlertView.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.size.width-30, height: 245))//220
        contentView.layer.cornerRadius = 5
        contentView.layer.masksToBounds = true
        self.alertView?.contentView = contentView
        self.alertView?.show()
        contentView.cancleButton.addTarget(self, action: #selector(self.cancleClick(button:)), for: .touchUpInside)
        contentView.confirmButton.addTarget(self, action: #selector(self.confirmClick(button:)), for: .touchUpInside)
    }
    
    func cancleClick(button: UIButton) {
        alertView?.hidenAnimation()
        
        let cancelView: CancleAlertView = alertView?.contentView as! CancleAlertView
        apiProvider.request(.cancelCallBack(callbackId: intCallbId ,currentStatus: 4,cancelReason: cancelView.reasonTextView.text ,cancelTime: "")) { result in
            
        }
    }
    
    func confirmClick(button: UIButton) {
        alertView?.hidenAnimation()
        
    }
    
    func requestData() {
        apiProvider.request(.getCallbackProcess(intCallbId : intCallbId  )) { result in
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
            rescueTime.text = json["pTrapRelsTime"].string
    }
    
    

    
    func postCallBackStatus(callbackState: CallbackStatus) {

        apiProvider.request(.saveCallBackStatus(callbackId: intCallbId,
                                                                                     callbackNo: recallCode.text!,
                                                                                     unitNo: eleCodeTF.text!,
                                                                                     customerName: customerName.text!,
                                                                                     customerTel: customerPhone.text!,
                                                                                     setOffTime: startTime.text!,
                                                                                     arrivalSiteTime: arriveTime.text!,
                                                                                     finishTime: completeTime.text!,
                                                                                     pTrapRelsTime: rescueTime.text!,
                                                                                     arrivalSiteLong: arriveLo.text!,
                                                                                     arrivalSiteLat: arriveLa.text!,
                                                                                     finishSiteLong: completeLo.text!,
                                                                                     finishSiteLat: completeLa.text!,
                                                                                     callbackStatus: callbackState))
        { result in
                                                                                            
                                                                                            
            switch result {
            case let .success(moyaResponse):
                let json = JSON(data: moyaResponse.data)
                if json["errorCode"].int == 0 {

                    self.updateDataOnView(json: json["data"])
                    
                    //成功返回数据后更改各btn的状态
                    if self.currentBtn?.currentTitle == "到达扫描" {
                        self.state = .arrive
                    }else if self.currentBtn?.currentTitle == "完成扫描" {
                        self.state = .complete
                    }else if self.currentBtn?.currentTitle == "出发" {
                        self.state = .start
                    }
                    
                }
                
                
            case .failure(_):
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: k_noNetwork), object: self, userInfo: nil)
                
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

