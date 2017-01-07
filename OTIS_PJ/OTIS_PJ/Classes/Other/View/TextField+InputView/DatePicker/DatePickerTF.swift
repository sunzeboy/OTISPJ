//
//  DatePickerTF.swift
//  UITextField+InputView
//
//  Created by sunzeboy on 15/9/7.
//  Copyright (c) 2015年 sunzeboy. All rights reserved.
//

import UIKit

 class DatePickerTF: InputViewTextField {

    var pattern: String!{didSet{
        patternKVO()
        if pattern == "yyyy-MM-dd" {
            datePicker.datePickerMode=UIDatePickerMode.Date
        }else{
            datePicker.datePickerMode=UIDatePickerMode.CountDownTimer

        }
        }}
    var selectedDateClosure: ((datePicker: UIDatePicker, selectedDateString: String, selectedDateTimeInterval: NSTimeInterval)->Void)!
    var selectedDateString: String!
    var selectedDateTimeInterval: NSTimeInterval!
    private var datePicker: UIDatePicker!
}


extension DatePickerTF{
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        accessoryView.msgLabel.text = "请您滑动控件以选取时间"
    }
    
    func patternKVO(){
        
        accessoryView.hideCancelBtn=true
        
        datePicker = UIDatePicker()
        datePicker.backgroundColor = BgColor
        datePicker.locale = NSLocale(localeIdentifier: "zh_CH")
        setDateTimeInterval(NSDate().timeIntervalSinceNow)
        datePicker.addTarget(self, action: #selector(DatePickerTF.selectedDatePickerRow(_:)), forControlEvents: UIControlEvents.ValueChanged)
        self.inputView=datePicker

    }
    
    
    /** 选中了时间 */
    func selectedDatePickerRow(datePicker: UIDatePicker){
//        let date : NSDate
//        if pattern == "yyyy-MM-dd" {
//            date = datePicker.date;
//        }else{
//            date = datePicker.countDownDuration;
//            
//        }
        
//        selectedDateTimeInterval = date.timeIntervalSince1970
        let date = datePicker.date;

        selectedDateString = date.dateFormatter(pattern);
        
//        selectedDateClosure?(datePicker: datePicker,selectedDateString: selectedDateString, selectedDateTimeInterval: selectedDateTimeInterval)
        
        self.text = selectedDateString
    }
    
    
    override func noti_textFieldDidBeginEditing(textField: UITextField) {
        assert(pattern != nil, "sunzeboy提示您：您需要设置tf.pattern属性，比如：yyyy-MM-dd")
        selectedDatePickerRow(datePicker)
    }
    
    func setDateTimeInterval(dateTimeInterval: NSTimeInterval){
        datePicker.setDate(NSDate(timeIntervalSince1970: dateTimeInterval), animated: false)
    }

}











extension NSDate{
    
    var timestamp: String {return "\(self.timeIntervalSince1970)"}
    
    func dateFormatter(pattern: String)->String{
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = pattern
        let dateString = formatter.stringFromDate(self)
        return dateString
    }
}

