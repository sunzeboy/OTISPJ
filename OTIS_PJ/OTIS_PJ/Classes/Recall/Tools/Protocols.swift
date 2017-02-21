//
//  Protocols.swift
//  OTIS_PJ
//
//  Created by sunze on 2017/2/21.
//  Copyright © 2017年 sunzeboy. All rights reserved.
//

import UIKit

extension String {
    func last() -> String {
        let arr = self.components(separatedBy: ".")
        guard arr.count>0 else {
            return self
        }
        return arr.last!
    }
}



/// Cellable协议
protocol Cellable {
    
}

extension Cellable where Self: UITableViewCell{
    static func cellWithTableView(_ tableView: UITableView) -> Self {
        let reusedId = description().last()
        let cell = tableView.dequeueReusableCell(withIdentifier: reusedId)
        guard let cellFinal = cell else {
            return Bundle.main.loadNibNamed(reusedId, owner: self, options: nil)?.last as! Self
        }
        return cellFinal as! Self
    }


}








