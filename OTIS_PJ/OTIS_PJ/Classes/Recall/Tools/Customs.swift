//
//  Customs.swift
//  OTIS_PJ
//
//  Created by sunze on 2017/2/24.
//  Copyright © 2017年 sunzeboy. All rights reserved.
//

import UIKit

public func showAlert(dialogContents: String) {
    let alertView = CustomIOSAlertView(alertDialogVieWithImageName: "", dialogTitle: "温馨提示", dialogContents: dialogContents, dialogButtons: ["确认"])
    alertView?.onButtonTouchUpInside = {(alertView: CustomIOSAlertView?,buttonIndex: Int32) in
        alertView?.close()
    }
    alertView?.show()
}

//public func isTelNumber(num:String)->Bool
//{
//    let mobile = "^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$"
//    let  CM = "^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$"
//    let  CU = "^1(3[0-2]|5[256]|8[56])\\d{8}$"
//    let  CT = "^1((33|53|8[09])[0-9]|349)\\d{7}$"
//    let regextestmobile = NSPredicate(format: "SELF MATCHES %@",mobile)
//    let regextestcm = NSPredicate(format: "SELF MATCHES %@",CM )
//    let regextestcu = NSPredicate(format: "SELF MATCHES %@" ,CU)
//    let regextestct = NSPredicate(format: "SELF MATCHES %@" ,CT)
//    if ((regextestmobile.evaluate(with: num) == true)
//        || (regextestcm.evaluate(with: num)  == true)
//        || (regextestct.evaluate(with: num) == true)
//        || (regextestcu.evaluate(with: num) == true))
//    {
//        return true
//    }
//    else
//    {
//        return false
//    }
//}


func validateMobile(phoneNum:String)-> Bool {
    
    // 手机号以 13 14 15 18 开头   八个 d 数字字符
    
    let phoneRegex = "^((13[0-9])|(17[0-9])|(14[^4,D])|(15[^4,D])|(18[0-9]))d{8}$|^1(7[0-9])d{8}$";
    
    let phoneTest = NSPredicate(format: "SELF MATCHES %@" , phoneRegex)
    
    return (phoneTest.evaluate(with: phoneNum));
    
}


