//
//  SZAddRecallViewController.swift
//  OTIS_PJ
//
//  Created by sunze on 2017/2/21.
//  Copyright © 2017年 sunzeboy. All rights reserved.
//

import UIKit

class SZAddRecallViewController: UIViewController,bottomOperationable {
    var btns: [BtnModel] {
        return [BtnModel(title: "保存", picname: "save"),
                BtnModel(title: "取消", picname: "cancel")];
    }
    
    @IBOutlet weak var recallCodeTF: UITextField!
    
    @IBOutlet weak var customerNameTF: UITextField!
    
    @IBOutlet weak var customerPhoneTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "新增召修"
        bottomView.actBlock = { (button:UIButton) -> Void in
            if button.title(for: .normal)=="保存" {
                
            }else{
            
            }
            self.navigationController?.popViewController(animated: true)
        }

        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        navigationController?.pushViewController(SZRecallProcessViewController(), animated: true)
    }

}
