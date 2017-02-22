//
//  SZRecallInputViewController.swift
//  OTIS_PJ
//
//  Created by sunze on 2017/2/21.
//  Copyright © 2017年 sunzeboy. All rights reserved.
//

import UIKit

class SZRecallInputViewController: UIViewController {
    
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
