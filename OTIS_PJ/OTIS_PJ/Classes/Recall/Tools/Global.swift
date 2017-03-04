//
//  Global.swift
//  OTIS_PJ
//
//  Created by sunze on 2017/2/24.
//  Copyright © 2017年 sunzeboy. All rights reserved.
//

import UIKit
import SwiftyUserDefaults

let k_screenW = UIScreen.main.bounds.width
let k_screenH = UIScreen.main.bounds.height

let bottomViewH:CGFloat = 60.0


extension DefaultsKeys {
    
    static let categoriesVer = DefaultsKey<Int>("categoriesVer")
    static let areasVer = DefaultsKey<Int>("areasVer")
    static let mainsVer = DefaultsKey<Int>("mainsVer")
    static let subsVer = DefaultsKey<Int>("subsVer")
    static let defectsVer = DefaultsKey<Int>("defectsVer")
    static let userLastLocationLat = DefaultsKey<String>("userLastLocationLat")
    static let userLastLocationLon = DefaultsKey<String>("userLastLocationLon")


}
