//
//  SZMyselfCell.swift
//  OTIS_PJ
//
//  Created by sunze on 2017/2/21.
//  Copyright © 2017年 sunzeboy. All rights reserved.
//

import UIKit
import SwiftyJSON



class SZMyselfCell: UITableViewCell,Cellable {
    
    var myCallBackItem: [String:JSON] = [:] {
        
        willSet {
        
        }
        didSet {
            callbackNo.text = myCallBackItem["callbackNo"]?.string
            unitNo.text = myCallBackItem["unitNo"]?.string
            customerName.text = myCallBackItem["customerName"]?.string
            customerTel.text = myCallBackItem["customerTel"]?.string
            let cbackStatus = myCallBackItem["callbackStatus"]?.int
            if cbackStatus == 0 {
                callbackStatus.text = "新增"
            }else if cbackStatus == 1 {
                callbackStatus.text = "出发"
            }else if cbackStatus == 2 {
                callbackStatus.text = "到达"
            }else if cbackStatus == 3 {
                callbackStatus.text = "完成（关闭）"
            }
            
        }
    }
    
    
    
    @IBOutlet weak var callbackNo: UILabel!

    @IBOutlet weak var unitNo: UILabel!
    
    @IBOutlet weak var customerName: UILabel!
    
    @IBOutlet weak var customerTel: UILabel!
    
    @IBOutlet weak var callbackStatus: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
}
