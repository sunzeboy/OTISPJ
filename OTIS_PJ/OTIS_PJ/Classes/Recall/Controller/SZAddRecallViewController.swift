//
//  SZAddRecallViewController.swift
//  OTIS_PJ
//
//  Created by sunze on 2017/2/21.
//  Copyright © 2017年 sunzeboy. All rights reserved.
//

import UIKit

class SZAddRecallViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "新增召修"
    
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        navigationController?.pushViewController(SZRecallProcessViewController(), animated: true)
    }

}
