//
//  SZRecallProcessViewController.swift
//  OTIS_PJ
//
//  Created by sunze on 2017/2/21.
//  Copyright © 2017年 sunzeboy. All rights reserved.
//

import UIKit

class SZRecallProcessViewController: UIViewController,BottomOperationable {
    var btns: [BtnModel] {
        return [BtnModel(title: "出发", picname: "start"),
                BtnModel(title: "到达扫描", picname: "scan"),
                BtnModel(title: "完成扫描", picname: "scan"),
                BtnModel(title: "下一步", picname: "next")];
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "召修过程"
        bottomView.actBlock = { (button:UIButton) -> Void in
            if button.title(for: .normal)=="下一步" {
                
            }else if button.title(for: .normal)=="完成扫描" {
            
            }else if button.title(for: .normal)=="到达扫描" {
                
            }else if button.title(for: .normal)=="出发" {
            
            }
            
//            self.navigationController?.popViewController(animated: true)
        }

        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        navigationController?.pushViewController(SZRecallInputViewController(), animated: true)
    }

}
