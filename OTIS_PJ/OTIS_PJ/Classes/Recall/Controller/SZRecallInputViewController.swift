//
//  SZRecallInputViewController.swift
//  OTIS_PJ
//
//  Created by sunze on 2017/2/21.
//  Copyright © 2017年 sunzeboy. All rights reserved.
//

import UIKit
import RealmSwift

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
        
        recallCategory.delegate = self
        componentArea.delegate = self
        mainComponent.delegate = self
        secondaryPart.delegate = self
        code.delegate = self

        
        contentView.contentSize = CGSize(width: 0, height: 1260)
        contentView.alwaysBounceVertical = true
        let datePicker = KMDatePicker(frame: CGRect(x: 0, y: 0, width: k_screenW, height: 216.0), delegate: self, datePickerStyle: .yearMonthDayHourMinute)
        fangRenTF.inputView = datePicker
        
        let realm = try! Realm()
        let categors: [String] = realm.objects(RecallCategory.self).map { return $0.categoryName }
        print(categors)
        recallCategory.options = categors
        
        let areas: [String] = realm.objects(ComponentArea.self).map { return $0.areaName }
        print(areas)
        componentArea.options = areas
        
        

        
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
        
        let realm = try! Realm()
        var ids = [Int]()
        
        switch menu {
        case componentArea:
            print("recallCategory")
            
            ids = realm.objects(ComponentArea.self).filter("areaName = '\(text)'").map({ return $0.areaID })
            
            let id = ids[0]
            
            let mains: [String] = realm.objects(MainComponent.self).filter("areaID = \(id)").map { return $0.mainName }
            print(mains)
            mainComponent.options = mains
            
            
        case mainComponent:
            print("mainComponent")
            ids = realm.objects(MainComponent.self).filter("mainName = '\(text)'").map({ return $0.mainID })
            let id = ids[0]
            
            let subs: [String] = realm.objects(SubComponent.self).filter("mainCode = \(id)").map { return $0.subName }
            print(subs)
            secondaryPart.options = subs
            
        case secondaryPart:
            print("secondaryPart")
            ids = realm.objects(SubComponent.self).filter("subName = '\(text)'").map({ return $0.subID })
            
            let id = ids[0]
            
            let defects: [String] = realm.objects(Defect.self).filter("subCode = \(id)").map { return $0.defectName }
            print(defects)
            code.options = defects
            
        default:
            print("default")
        }

    }
    
    func dropDownMenu(_ menu: SZDropDownMenu!, didInput text: String!) {
        
        //        let id = ids[0]
//        
//        let mains: [String] = realm.objects(MainComponent.self).filter("areaID = \(id)").map { return $0.mainName }
//        print(mains)
//        mainComponent.options = mains
//        
//        let subs: [String] = realm.objects(SubComponent.self).filter("mainCode = \(id)").map { return $0.subName }
//        print(subs)
//        secondaryPart.options = subs
//        
//        let defects: [String] = realm.objects(Defect.self).filter("subCode = \(id)").map { return $0.defectName }
//        print(defects)
//        code.options = defects
    }

}
