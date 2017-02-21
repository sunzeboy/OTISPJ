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

    override func viewDidLoad() {
        super.viewDidLoad()
        contentView.contentSize = CGSize(width: 0, height: 1260)
        contentView.alwaysBounceVertical = true
        
    }
    


}
