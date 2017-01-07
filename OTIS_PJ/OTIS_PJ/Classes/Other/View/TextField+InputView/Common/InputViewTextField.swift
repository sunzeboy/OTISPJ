//
//  InputViewTextField.swift
//  TextField+InputView
//
//  Created by sunzeboy on 15/8/31.
//  Copyright (c) 2015年 sunzeboy. All rights reserved.
//

import UIKit

class InputViewTextField: UITextField {
    
    lazy var accessoryView: AccessoryView = {AccessoryView.instance()}()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //视图准备
        self.viewPrepare()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        //视图准备
        self.viewPrepare()
    }
    
    /**  视图准备  */
    func viewPrepare(){
        
        self.inputAccessoryView = accessoryView
        accessoryView.doneBtnActionClosure={
            self.endEditing(true)
        }
        accessoryView.cancelBtnActionClosure={
            self.endEditing(true)
        }
        
        //添加监听
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(InputViewTextField.noti_textFieldDidBeginEditing(_:)), name: UITextFieldTextDidBeginEditingNotification, object: self)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(InputViewTextField.noti_textFieldDidEndEditing(_:)), name: UITextFieldTextDidEndEditingNotification, object: self)
        
    }
    
    deinit{NSNotificationCenter.defaultCenter().removeObserver(self)}
}


extension InputViewTextField{
    
    func noti_textFieldDidBeginEditing(textField: UITextField) {}
    func noti_textFieldDidEndEditing(textField: UITextField) {}
    override func caretRectForPosition(position: UITextPosition) -> CGRect {return CGRectZero}
    
    
}