//
//  SZRecallViewController.swift
//  OTIS_PJ
//
//  Created by sunze on 2017/2/21.
//  Copyright © 2017年 sunzeboy. All rights reserved.
//

import UIKit


class SZRecallViewController: SZPageViewController,bottomOperationable {

    var btns: [String : String] {
        return ["新增":"add"];
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "召修"
        self.bottomView.actBlock = actBlock
        bottomView.actBlock = actBlock
        view.addSubview(bottomView)

    }
    
    override func setupChildVces() {
        let subVc1 = SZMyselfViewController()
        subVc1.title = "本人召修"
        addChildViewController(subVc1)
        
        let subVc2 = SZStopLaddersViewController()
        subVc2.title = "停梯工单"
        addChildViewController(subVc2)
    }

    func actBlock(button:UIButton) -> Void {
        print("addddd")
    }
    
}
