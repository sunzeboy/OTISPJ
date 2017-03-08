//
//  SZRecallInputViewController.swift
//  OTIS_PJ
//
//  Created by sunze on 2017/2/21.
//  Copyright © 2017年 sunzeboy. All rights reserved.
//

import UIKit
import RealmSwift
import SwiftyJSON
import SVProgressHUD

class SZRecallInputViewController: UIViewController,BottomOperationable {
    
    //是否停梯，默认为否
    var isStopLadders:Bool = false

    var btns: [BtnModel] {
        return [BtnModel(title: "保存", picname: "save"),
                BtnModel(title: "下一步", picname: "next")];
    }
    
    var intCallbId: Int = 0

    /// 父控件View
    @IBOutlet weak var contentView: UIScrollView!
    
    /// 放人时间TF
    @IBOutlet weak var fangRenTF: UITextField!
    
    /// 召修编号
    @IBOutlet weak var recallCode: UILabel!
    
    /// 客户名称
    @IBOutlet weak var customerName: UILabel!
    
    /// 客户电话
    @IBOutlet weak var customerPhone: UILabel!
    
    /// 开始时间
    @IBOutlet weak var startTime: UILabel!
    
    /// 电梯编号
    @IBOutlet weak var eleCodeTF: UILabel!
    
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
    
    /// 召修分类
    @IBOutlet weak var recallCategory: SZDropDownMenu!
    
    /// 部件区域
    @IBOutlet weak var componentArea: SZDropDownMenu!
    
    /// 主部件
    @IBOutlet weak var mainComponent: SZDropDownMenu!
    
    /// 次部件
    @IBOutlet weak var secondaryPart: SZDropDownMenu!
    
    /// 代码
    @IBOutlet weak var code: SZDropDownMenu!
    
    /// 关人信息
    @IBOutlet weak var closeInformationTV: UITextView!
    
    /// 故障原因
    @IBOutlet weak var failureCauseTV: UITextView!
    
    /// 故障现象
    @IBOutlet weak var failurePhenomenonTV: UITextView!
    
    /// 处理结果
    @IBOutlet weak var treatmentResultTV: UITextView!
    
    var alertView: ABAlertView?
    
//    var cancelAlertView: CancleAlertView?
    
    override func viewWillAppear(_ animated: Bool) {
        requestData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "召修详情"
        
        bottomView.btns.forEach{ (btn) in
            if btn.currentTitle == "下一步" {
                btn.isEnabled = false
            }
        }
        
        setUpcontentView()
        
        bottomView.actBlock = {[unowned self] (button:UIButton) -> Void in
            if button.currentTitle == "下一步" {
                if self.isStopLadders {
                    self.saveAlertStop()
                }else{
                    self.saveAlert()
                }
            }else{
                self.save()
            }
            
        }
        
        
        
        
        
    }

    
    func closeCallBack(isComplete: Int,shutdownReason: String) {
        apiProvider.request(.closeCallBack(callbackId: intCallbId, isComplete: isComplete, shutdownReason: shutdownReason, closeTime: "")) { result in
            switch result {
            case let .success(moyaResponse):
                let json = JSON(data: moyaResponse.data)
                if json["errorCode"].int == 0 {
                    print(json)
                    self.navigationController?.popToViewController((self.navigationController?.childViewControllers[1])!, animated: true)
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
    
    func saveAlert() {
        self.alertView = ABAlertView.init(frame: UIScreen.main.bounds)
        let contentView = AlertView.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.size.width-30, height: 245))//220
        contentView.indexArray = ["多次维修","换人维修","领取配件","T修理","总部技术支持","停梯"]
        contentView.layer.cornerRadius = 5
        contentView.layer.masksToBounds = true
        self.alertView?.contentView = contentView
        self.alertView?.show()
        contentView.cancleButton.addTarget(self, action: #selector(self.cancleClick(button:)), for: .touchUpInside)
        contentView.confirmButton.addTarget(self, action: #selector(self.confirmClick(button:)), for: .touchUpInside)
    }
    
    func cancleClick(button: UIButton) {
        alertView?.hidenAnimation()
        closeCallBack(isComplete: 0, shutdownReason:"")

    }
    
    func confirmClick(button: UIButton) {
        alertView?.hidenAnimation()
        let alert: AlertView = self.alertView?.contentView as! AlertView
        if (alert.textField.text?.isEmpty)! {
            SVProgressHUD.showInfo(withStatus: "请选择再次处理原因！")
            return
        }
        closeCallBack(isComplete: 1, shutdownReason: alert.textField.text!)
        
    }
    
    
    func saveAlertStop() {
        let alertView = CustomIOSAlertView(alertDialogVieWithImageName: "", dialogTitle: "温馨提示", dialogContents: "本次工单所有信息客户已经确认，停梯是否恢复？", dialogButtons: ["是","否"])
        alertView?.onButtonTouchUpInside = {(alertView: CustomIOSAlertView?,buttonIndex: Int32) in
            
            if buttonIndex == 0 {
                self.stopEveCallBack(isStop: 0)
            }else{
                self.stopEveCallBack(isStop: 1)
            }
            alertView?.close()
        }
        alertView?.show()
    }
    
    func stopEveCallBack(isStop: Int) {
        apiProvider.request(.stopEveCallBack(callbackId: intCallbId, isStop: isStop)) { result in
                switch result {
                case let .success(moyaResponse):
                    let json = JSON(data: moyaResponse.data)
                    if json["errorCode"].int == 0 {

//                        SVProgressHUD.showInfo(withStatus: "成功")
                        self.navigationController?.popToViewController((self.navigationController?.childViewControllers[1])!, animated: true)
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
    
    
    func setUpcontentView() {
        
        recallCategory.placeholder = "请选择召修分类"
        componentArea.placeholder = "请选择部件区域"
        mainComponent.placeholder = "请选择主部件"
        secondaryPart.placeholder = "请选择次部件"
        code.placeholder = "请选择代码"

        recallCategory.delegate = self
        componentArea.delegate = self
        mainComponent.delegate = self
        secondaryPart.delegate = self
        code.delegate = self
        
        recallCategory.clickClosure = {[weak self] in
            self?.contentView.setContentOffset(CGPoint(x:0,y:k_screenH/3.0), animated: true)
        }
        
        componentArea.clickClosure = {[weak self] in
            self?.contentView.setContentOffset(CGPoint(x:0,y:k_screenH/3.0), animated: true)
        }
        mainComponent.clickClosure = {[weak self] in
            self?.contentView.setContentOffset(CGPoint(x:0,y:k_screenH/3.0), animated: true)
        }
        secondaryPart.clickClosure = {[weak self] in
            self?.contentView.setContentOffset(CGPoint(x:0,y:k_screenH/3.0), animated: true)
        }
        code.clickClosure = {[weak self] in
            self?.contentView.setContentOffset(CGPoint(x:0,y:k_screenH/3.0), animated: true)
        }

        let realm = try! Realm()
        let categors: [String] = realm.objects(RecallCategory.self).map { return $0.categoryNameZh }
        print(categors)
        recallCategory.options = categors
        
        let areas: [String] = realm.objects(ComponentArea.self).map { return $0.areaNameZh }
        print(areas)
        componentArea.options = areas
        
        
        contentView.contentSize = CGSize(width: 0, height: 1300)
        contentView.alwaysBounceVertical = true
        let datePicker = KMDatePicker(frame: CGRect(x: 0, y: 0, width: k_screenW, height: 216.0), delegate: self, datePickerStyle: .yearMonthDayHourMinute)
        fangRenTF.inputView = datePicker
        
    }
    
    
    func requestData() {
        apiProvider.request(.getCallBackDetailInfo(intCallbId : intCallbId)) { result in
            switch result {
            case let .success(moyaResponse):
                let json = JSON(data: moyaResponse.data)
                if json["errorCode"].int == 0 {
                    
                    self.updateDataOnView(json: json["data"])
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
    
    func save() {
        
        let categoryStr = recallCategory.contentTextField.text!
        let areaStr = componentArea.contentTextField.text!
        let mainStr = mainComponent.contentTextField.text!
        let subStr = secondaryPart.contentTextField.text!
        let codeStr = code.contentTextField.text!

        if categoryStr.isEmpty {
            showAlert(dialogContents:"请输入召修分类信息！")
            return
        }else if areaStr.isEmpty {
            showAlert(dialogContents:"请输入部件区域信息！")
            return
        }else if mainStr.isEmpty {
            showAlert(dialogContents:"请输入主部件信息！")
            return
        }else if subStr.isEmpty {
            showAlert(dialogContents:"请输入次部件信息！")
            return
        }else if codeStr.isEmpty {
            showAlert(dialogContents:"请输入代码信息！")
            return
        }else if fangRenTF.text?.isEmpty == false && closeInformationTV.text.isEmpty {
            showAlert(dialogContents:"请输入关人信息！")
            return
        }else if failureCauseTV.text.isEmpty {
            showAlert(dialogContents:"请输入故障原因信息！")
            return
        }else if failurePhenomenonTV.text.isEmpty {
            showAlert(dialogContents:"请输入故障现象信息！")
            return
        }else if treatmentResultTV.text.isEmpty {
            showAlert(dialogContents:"请输入处理结果信息！")
            return
        }
        
        
        
        let realm = try! Realm()
        let ids = realm.objects(RecallCategory.self).filter("categoryNameZh = '\(categoryStr)'").map({ return $0.categoryId })
        
        let categoryId = ids[0]
        
        let ids2 = realm.objects(ComponentArea.self).filter("areaNameZh = '\(areaStr)'").map({ return $0.areaID })
        let areaID = ids2[0]
        
        let ids3 = realm.objects(MainComponent.self).filter("mainNameZh = '\(mainStr)'").map({ return $0.mainCode })
        let mainCode = ids3[0]
        
        let ids4 = realm.objects(SubComponent.self).filter("subNameZh = '\(subStr)'").map({ return $0.subCode })
        let subCode = ids4[0]
        
        let ids5 = realm.objects(Defect.self).filter("defectNameZh = '\(codeStr)'").map({ return $0.defectCode })
        let defectCode = ids5[0]
        

        apiProvider.request(.saveCallBackDetail(callbackId: intCallbId,
                                                categoryId: categoryId,
                                                areaId: areaID,
                                                mainCode: mainCode,
                                                subCode: subCode,
                                                defectCode: defectCode,
                                                pTrapRelsTime: "",
                                                pTrapInfo: closeInformationTV.text,
                                                faultCause: failureCauseTV.text,
                                                faultPhenomenon: failurePhenomenonTV.text,
                                                results: treatmentResultTV.text)) { result in
            switch result {
            case let .success(moyaResponse):
                let json = JSON(data: moyaResponse.data)
                if json["errorCode"].int == 0 {
                    print(Thread.current)
//                    self.updateDataOnView(json: json["data"])
                    self.bottomView.btns.forEach{ (btn) in
                        if btn.currentTitle == "下一步" {
                            btn.isEnabled = true
                        }
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
        treatmentResultTV.text = json["results"].string
        closeInformationTV.text = json["pTrapInfo"].string
        failureCauseTV.text = json["faultCause"].string
        failurePhenomenonTV.text = json["faultPhenomenon"].string
        fangRenTF.text = json["pTrapRelsTime"].string
        
        let realm = try! Realm()
        let areas: [String] = realm.objects(ComponentArea.self).filter("areaID = \(json["areaId"].int!)").map{ return $0.areaNameZh}
        componentArea.contentTextField.text = areas.last
        
        let recallCategorys: [String] = realm.objects(RecallCategory.self).filter("categoryId = \(json["categoryId"].int!)").map{ return $0.categoryNameZh}
        recallCategory.contentTextField.text = recallCategorys.last
        
        let mainComponents: [String] = realm.objects(MainComponent.self).filter("mainCode = '\(json["mainCode"].string!)'").map{ return $0.mainNameZh}
        mainComponent.contentTextField.text = mainComponents.last

        let subComponents: [String] = realm.objects(SubComponent.self).filter("subCode = '\(json["subCode"].string!)'").map{ return $0.subNameZh}
        secondaryPart.contentTextField.text = subComponents.last

        let defects: [String] = realm.objects(Defect.self).filter("defectCode = '\(json["defectCode"].string!)'").map{ return $0.defectNameZh}
        code.contentTextField.text = defects.last
        
    }
    
}


extension SZRecallInputViewController: KMDatePickerDelegate {

    func datePicker(_ datePicker: KMDatePicker!, didSelectDate datePickerDate: KMDatePickerDateModel!) {
        fangRenTF.text = datePickerDate.year + "-"
            + datePickerDate.month + "-"
            + datePickerDate.day + "  "
            + datePickerDate.hour + ":"
            + datePickerDate.minute
    }

}


extension SZRecallInputViewController: SZDropDownMenuDelegate {
    
    func dropDownMenu(_ menu: SZDropDownMenu!, didChoose index: Int) {
        
        let text = menu.options[index]
        
        switch menu {
            
        case recallCategory:
            
            recallCategoryAct(text)
            
        case componentArea:
            
            componentAreaAct(text)
            
        case mainComponent:
            
            mainComponentAct(text)
            
        case secondaryPart:
            
            secondaryPartAct(text)
            
        default:
            print("default")
        }

    }
    
    func dropDownMenu(_ menu: SZDropDownMenu!, didInput text: String!) {
        

    }
    
    func recallCategoryAct(_ text:String) {
        
        componentArea.contentTextField.text = nil
        
        mainComponent.contentTextField.text = nil
        mainComponent.options = []

        secondaryPart.contentTextField.text = nil
        secondaryPart.options = []

        code.contentTextField.text = nil
        code.options = []


    }
    
    func componentAreaAct(_ text:String) {
        contentView.setContentOffset(CGPoint(x:0,y:220), animated: true)

        let realm = try! Realm()

        let ids = realm.objects(ComponentArea.self).filter("areaNameZh = '\(text)'").map({ return $0.areaID })
        
        let id = ids[0]
        
        let mains: [String] = realm.objects(MainComponent.self).filter("areaID = \(id)").map { return $0.mainNameZh }
        
        mainComponent.contentTextField.text = nil
        mainComponent.options = mains
        
        secondaryPart.contentTextField.text = nil
        secondaryPart.options = []

        code.contentTextField.text = nil
        code.options = []

    }
    
    func mainComponentAct(_ text:String) {
        contentView.setContentOffset(CGPoint(x:0,y:240), animated: true)

        let realm = try! Realm()
        let codes = realm.objects(MainComponent.self).filter("mainNameZh = '\(text)'").map({ return $0.mainCode })
        let cd = codes[0]
        
        let subs: [String] = realm.objects(SubComponent.self).filter("mainCode = '\(cd)'").map { return $0.subNameZh }
        
        secondaryPart.contentTextField.text = nil
        secondaryPart.options = subs
        
        code.contentTextField.text = nil
        code.options = []

    }
    
    func secondaryPartAct(_ text:String) {
        contentView.setContentOffset(CGPoint(x:0,y:260), animated: true)

        let realm = try! Realm()
        let ids = realm.objects(SubComponent.self).filter("subNameZh = '\(text)'").map({ return $0.subCode })
        
        let id = ids[0]
        
        let defects: [String] = realm.objects(Defect.self).filter("subCode = '\(id)'").map { return $0.defectNameZh }
        
        code.contentTextField.text = nil
        code.options = defects

    }

}




extension SZRecallInputViewController: UITextViewDelegate {

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        var length = 0
        for char in textView.text!.characters {
            // 判断是否中文，是中文+2 ，不是+1
            length += "\(char)".lengthOfBytes(using: String.Encoding.utf8) == 3 ? 2 : 1
        }
        if length > 500 {
            view.endEditing(true)
            showAlert(dialogContents:"已超出字数限制，最多可入500字！")
            return false
        }
        return true
    }

}

