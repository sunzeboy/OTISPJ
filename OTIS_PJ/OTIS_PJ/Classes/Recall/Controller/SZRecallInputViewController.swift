//
//  SZRecallInputViewController.swift
//  OTIS_PJ
//
//  Created by sunze on 2017/2/21.
//  Copyright © 2017年 sunzeboy. All rights reserved.
//

import UIKit

class SZRecallInputViewController: UIViewController {
    
    @IBOutlet weak var contentView: UIScrollView!
    
    @IBOutlet weak var fangRenTF: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        contentView.contentSize = CGSize(width: 0, height: 1260)
        contentView.alwaysBounceVertical = true
        let datePicker = KMDatePicker(frame: CGRect(x: 0, y: 0, width: k_screenW, height: 216.0), delegate: self, datePickerStyle: .yearMonthDayHourMinute)
//        fangRenTF.delegate = self
        fangRenTF.inputView = datePicker
        
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
