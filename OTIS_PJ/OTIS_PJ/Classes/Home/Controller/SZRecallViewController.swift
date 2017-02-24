//
//  SZRecallViewController.swift
//  OTIS_PJ
//
//  Created by sunze on 2017/2/21.
//  Copyright © 2017年 sunzeboy. All rights reserved.
//

import UIKit


class SZRecallViewController: SZPageViewController,bottomOperationable {

    var btns: [BtnModel] {
        
        return [BtnModel(title: "新增", picname: "add")];
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "召修"
        bottomView.actBlock = { (button:UIButton) -> Void in
            self.navigationController?.pushViewController(SZAddRecallViewController(), animated: true)
        }
        

    }
    
    override func setupChildVces() {
        let subVc1 = SZMyselfViewController()
        subVc1.title = "本人召修"
        addChildViewController(subVc1)
        
        let subVc2 = SZStopLaddersViewController()
        subVc2.title = "停梯工单"
        addChildViewController(subVc2)
    }

//    func actBlock(button:UIButton) -> Void {
//        
//        navigationController?.pushViewController(SZAddRecallViewController(), animated: true)
//    }
    
}
