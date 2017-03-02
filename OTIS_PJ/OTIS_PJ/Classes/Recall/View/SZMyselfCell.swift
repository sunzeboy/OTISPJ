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
    
    var myCallBackItem: [String:JSON] {
        
        set {
            callbackNo.text = newValue["callbackNo"]?.string
            unitNo.text = newValue["unitNo"]?.string
            customerName.text = newValue["customerName"]?.string
            customerTel.text = newValue["callbackNo"]?.string
            callbackNo.text = newValue["callbackNo"]?.string

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
