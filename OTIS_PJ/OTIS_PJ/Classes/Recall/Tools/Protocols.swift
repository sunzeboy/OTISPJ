//
//  Protocols.swift
//  OTIS_PJ
//
//  Created by sunze on 2017/2/21.
//  Copyright © 2017年 sunzeboy. All rights reserved.
//

import UIKit

let k_screenW = UIScreen.main.bounds.width
let k_screenH = UIScreen.main.bounds.height

let bottomViewH:CGFloat = 60.0



extension UIButton{
    //    func btn(btn: UIButton)  {
    //
    //        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;//使图片和文字水平居中显示
    //        [btn setTitleEdgeInsets:UIEdgeInsetsMake(btn.imageView.frame.size.height ,-btn.imageView.frame.size.width, 0.0,0.0)];//文字距离上边框的距离增加imageView的高度，距离左边框减少imageView的宽度，距离下边框和右边框距离不变
    //        [btn setImageEdgeInsets:UIEdgeInsetsMake(0.0, 0.0,0.0, -btn.titleLabel.bounds.size.width)];//图片距离右边框距离减少图片的宽度，其它不边
    //
    //    }
    
    var titleW: CGFloat {
        return (titleLabel?.bounds.size.width)!
    }
    var imageW: CGFloat {
        return (imageView?.frame.size.width)!
    }
    var imageH: CGFloat {
        return (imageView?.frame.size.height)!
    }
    func topPicBottomTitleStyle() {
        contentHorizontalAlignment = .center
        titleEdgeInsets = UIEdgeInsetsMake(imageH+6,-imageW, 0.0, 0.0)
        imageEdgeInsets = UIEdgeInsetsMake(-6, titleW*0.5,0.0, -titleW*0.5)
    }
    
    func rightPicLeftTitleStyle() {
        contentHorizontalAlignment = .center
        titleEdgeInsets = UIEdgeInsetsMake(0,-imageW-10, 0.0, 10)
        imageEdgeInsets = UIEdgeInsetsMake(0, titleW+10,0.0, -10)
    }
    
    func setBtn(_ title: String ,imageName:String,target:Any?,action:Selector) -> UIButton {
        let leftBtn = UIButton(type: .custom)
        leftBtn.frame = CGRect(x: 0, y: 0, width: 47, height: 47)
        leftBtn.setTitleColor(UIColor(red: 30/255.0, green: 32/255.0, blue: 81/255.0, alpha: 1), for: .normal)
        leftBtn.setTitle(title, for: .normal)
        leftBtn.titleLabel?.font = UIFont.systemFont(ofSize: 9)
        leftBtn.titleLabel?.contentMode = .center
        leftBtn.addTarget(self, action:action, for: .touchUpInside)
        leftBtn.setImage(UIImage.init(named: imageName), for: .normal)
        leftBtn.topPicBottomTitleStyle()
        return leftBtn
    }
}



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

typealias actClosure = (UIButton)->Void

class BottomView: UIView {
    
    var actBlock: actClosure?
    
    
    init(_ btns:[String:String],target:UIViewController,frame:CGRect) {
        super.init(frame: frame)
        let total:CGFloat = CGFloat(btns.count)
        var i = CGFloat(0)
        backgroundColor = UIColor.white
        layer.borderWidth = 1
        layer.borderColor = UIColor.lightGray.cgColor
      _ =  btns.map { (title,picname) -> UIButton in
            i += 1
            let btn = UIButton(type: .custom)
            btn.setTitle(title, for: .normal)
            btn.setTitle(title, for: .disabled)
            btn.setTitleColor(UIColor.blue, for: .normal)
            btn.setTitleColor(UIColor.gray, for: .disabled)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            btn.setImage(UIImage(named: picname+"Light"), for: .normal)
            btn.setImage(UIImage(named:picname), for: .disabled)
            btn.addTarget(self, action: #selector(act(_:)), for: .touchUpInside)
            btn.frame = CGRect(x: 0, y: 0, width: 35, height: 30)
            btn.center = CGPoint(x: (i-1)*k_screenW/total + k_screenW/total/2, y: 30)
            btn.topPicBottomTitleStyle()
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 10)
            addSubview(btn)
            return btn
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func act(_ button:UIButton) {
        if let actBlock = actBlock {
            actBlock(button)
        }
    }
}

protocol bottomOperationable {
    var btns:[String:String] {get}
    
}

extension bottomOperationable where Self:UIViewController {

    var bottomView: BottomView {
        
        let bottomView = BottomView(btns, target: self, frame: CGRect(x: 0, y: k_screenH-bottomViewH, width: k_screenW, height: bottomViewH))
        
        for view in self.view.subviews {
            if view is BottomView {
                return view as! BottomView
            }
        }
        self.view.addSubview(bottomView)
        return bottomView
    }
    

}




