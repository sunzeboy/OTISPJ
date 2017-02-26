//
//  Protocols.swift
//  OTIS_PJ
//
//  Created by sunze on 2017/2/21.
//  Copyright © 2017年 sunzeboy. All rights reserved.
//

import UIKit



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
        titleEdgeInsets = UIEdgeInsetsMake(imageH+10,-imageW, 0.0, 0.0)
        imageEdgeInsets = UIEdgeInsetsMake(-10, titleW*0.5,0.0, -titleW*0.5)
    }
    
    func rightPicLeftTitleStyle() {
        contentHorizontalAlignment = .center
        titleEdgeInsets = UIEdgeInsetsMake(0,-imageW-10, 0.0, 10)
        imageEdgeInsets = UIEdgeInsetsMake(0, titleW+10,0.0, -10)
    }
    
    func setBtn(_ title: String ,imageName:String,target:Any?,action:Selector) -> UIButton {
        let leftBtn = UIButton(type: .custom)
        leftBtn.frame = CGRect(x: 0, y: 0, width: 50, height: 24)
        leftBtn.setTitleColor(UIColor(red: 30/255.0, green: 32/255.0, blue: 81/255.0, alpha: 1), for: .normal)
        leftBtn.setTitleColor(UIColor.lightGray, for: .disabled)
        leftBtn.setTitle(title, for: .normal)
        leftBtn.setTitle(title, for: .disabled)
        leftBtn.titleLabel?.font = UIFont.systemFont(ofSize: 10)
        leftBtn.titleLabel?.contentMode = .center
//        leftBtn.titleLabel?.adjustsFontSizeToFitWidth = true
        leftBtn.addTarget(self, action:action, for: .touchUpInside)
        leftBtn.setImage(UIImage.init(named: imageName+"Light"), for: .normal)
        leftBtn.setImage(UIImage.init(named: imageName), for: .disabled)
        leftBtn.imageView?.contentMode = .scaleAspectFit
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



struct BtnModel {
    var title: String
    var picname: String
}


typealias actClosure = (UIButton)->Void

class BottomView: UIView {
    
    var actBlock: actClosure?
    
    
    init(_ btns:[BtnModel],target:UIViewController,frame:CGRect) {
        super.init(frame: frame)
        let total:CGFloat = CGFloat(btns.count)
        var i = CGFloat(0)
        backgroundColor = UIColor.white
        layer.borderWidth = 1
        layer.borderColor = UIColor.lightGray.cgColor
        
      _ =  btns.map { (btn) -> UIButton in
            i += 1
       let btn =  UIButton().setBtn(btn.title, imageName: btn.picname, target: self, action: #selector(act(_:)))
//            btn.frame = CGRect(x: 0, y: 0, width: 35, height: 30)
            btn.center = CGPoint(x: (i-1)*k_screenW/total + k_screenW/total/2, y: 30)
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

protocol BottomOperationable {
    var btns:[BtnModel] {get}
    
}

extension BottomOperationable where Self:UIViewController {

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




