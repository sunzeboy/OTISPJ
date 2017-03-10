//
//  ABAlertView.swift
//  ABAlertViewDemo
//
//  Created by 杜亚伟 on 2017/2/8.
//  Copyright © 2017年 杜亚伟. All rights reserved.
//

import UIKit

public let MARGIN_TOP = 20

public protocol ABAlertViewSelectIndex: class {
    func alertViewSelectIndex(alertView: ABAlertView,clickedButtonAtIndex: Int)
}

public class ABAlertView: UIView {

    var titleArray : [String]?
    var buttonArray = [UIButton]()
    
    var tiltle : NSString?
    var message : String?
    var icon : UIImage?
    var backView : UIView!
    
    var titleView : UIView!
    var iconImageView : UIImageView!
    var titleLabel : UILabel?
    var messageLabel : UILabel?
    
    var contentViewWidth : CGFloat
    var contentViewHeight = MARGIN_TOP
    weak var delegate: ABAlertViewSelectIndex?
    
    
    //自定义View
   public var contentView : UIView!{
        didSet{
            contentView.center = self.center
            self.addSubview(contentView)
        }
    }
    
    //提示框背景色
   public var contentViewBackgroundColor: UIColor = UIColor.white {
        didSet{
            contentView.backgroundColor = contentViewBackgroundColor
        }
    }
    
    //标题颜色
   public var titleColor: UIColor = UIColor.black {
        didSet{
            if tiltle != nil {
                titleLabel?.textColor = titleColor
            }
        }
    }
    
    //信息颜色
   public var messageColor: UIColor = UIColor.black {
        didSet{
            messageLabel?.textColor = messageColor
        }
    }
    
    //取消按钮颜色
   public var cancleButtonColor: UIColor = UIColor.black {
        didSet{
            if buttonArray.count>1 {
                let cancleButton = buttonArray[0]
                cancleButton.setTitleColor(cancleButtonColor, for: .normal)
            }
        }
    }
    
    //确定按钮颜色
   public var confirmButtonColor: UIColor = UIColor.black {
        didSet{
            if buttonArray.count>1 {
                let confirmButton = buttonArray[1]
                confirmButton.setTitleColor(confirmButtonColor, for: .normal)
            }
        }
    }
    
    //自定义初始化
    public init(title: NSString?,icon: UIImage?,message: String?,titleArray: Array<String>?){
        self.tiltle = title
        if message == nil  {
            self.message = "message不能为空"
        }else{
            self.message = message
        }
        self.icon = icon
        self.titleArray = titleArray
        contentViewWidth = 280 * UIScreen.main.bounds.size.width / 320
        super.init(frame: UIScreen.main.bounds)
        setUI()
        setContentView()
    }
    
    //重写父类的初始化
    override public init(frame: CGRect){
        contentViewWidth = 280 * UIScreen.main.bounds.size.width / 320
        super.init(frame: frame)
        setUI()
    }
    
   fileprivate func setUI() {
        backView = UIView.init(frame: self.frame)
        backView.backgroundColor = UIColor.black
        self.addSubview(backView!)
    }
    
   fileprivate func setContentView(){
        
        contentView = UIView()
        contentView.layer.cornerRadius = 5
        contentView.layer.masksToBounds = true
        contentView.backgroundColor = UIColor.white
        initTitleAndIcon()
        initMessage()
        initAllButtons()
        contentView.frame = CGRect.init(x: 0, y: 0, width: Int(contentViewWidth), height: contentViewHeight)
        contentView.center = self.center
        self.addSubview(contentView)
    }
    
    fileprivate func initTitleAndIcon() {
        
        titleView = UIView()
        iconImageView = UIImageView()
        if icon != nil {
            iconImageView.image = icon
            iconImageView.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
            titleView.addSubview(iconImageView)
        }
        let titleSize: CGSize
        var originY : CGFloat
        
        if tiltle == nil {
            titleSize = CGSize.init(width: 0, height: 0)
            originY = 0
        }else{
            titleSize = getTitleSize()
            originY = 20
        }
        
        if tiltle != nil && !(tiltle?.isEqual(to: ""))! {
            titleLabel = UILabel()
            titleLabel?.text = tiltle as String?
            titleLabel?.textColor = UIColor(red: 28/255.0, green: 28/255.0, blue: 28/255.0, alpha: 1.0)
            titleLabel?.textAlignment = .center
            titleLabel?.font = UIFont.systemFont(ofSize: 15)
            titleLabel?.numberOfLines = 0
            titleLabel?.lineBreakMode = .byWordWrapping
            titleLabel?.frame = CGRect(x:iconImageView.frame.origin.x+iconImageView.frame.size.width+5, y:CGFloat(1) , width: titleSize.width, height: titleSize.height)
            titleView.addSubview(titleLabel!)
        }
        
        var maxHeight = 0
        
        if iconImageView.frame.size.height>titleSize.height {
            maxHeight = Int(iconImageView.frame.size.height)
        }else{
            maxHeight = Int(titleSize.height)
        }
        
        print("Int(originY)",Int(originY))
        titleView.frame = CGRect(x: 0, y: Int(originY), width: Int(iconImageView.frame.size.width + 5 + titleSize.width), height: maxHeight)
        contentView.addSubview(titleView)
        titleView.center = CGPoint(x: Int(contentViewWidth / 2), y: Int(Int(originY) + Int(titleView.frame.size.height / 2)))
        contentViewHeight += Int(titleView.frame.size.height)
    }
    
    fileprivate func initMessage() {
        if message != nil {
            messageLabel = UILabel()
            messageLabel?.text = message
            messageLabel?.textColor = UIColor(red: 28/255.0, green: 28/255.0, blue: 28/255.0, alpha: 1.0)
            messageLabel?.numberOfLines = 0
            messageLabel?.sizeToFit()
            messageLabel?.font = UIFont.systemFont(ofSize: 13)
            messageLabel?.text = message!
            messageLabel?.textAlignment = .center
            
            let messageSize = getMessageSize()
            var maxWidth = 0
            if (contentViewWidth-60)>messageSize.width {
                maxWidth = Int(contentViewWidth-60)
            }else{
                maxWidth = Int(messageSize.width)
            }
            
            messageLabel?.frame = CGRect.init(x: 30, y:Int(titleView.frame.origin.y+titleView.frame.size.height+10), width: maxWidth, height:Int(messageSize.height))
            contentView.addSubview(messageLabel!)
            contentViewHeight += 10 + Int((messageLabel?.frame.size.height)!)
        }
    }
    
    fileprivate func initAllButtons() {
        if (titleArray?.count)! > 0 {
            if tiltle==nil {
                 contentViewHeight += 35
            }else{
                 contentViewHeight += 10+45
            }
           
            let horizonSperatorView = UIView.init(frame:CGRect.init(x: 0, y:(messageLabel?.frame.origin.y)!+(messageLabel?.frame.size.height)!+10, width: contentViewWidth, height: 1))
            horizonSperatorView.backgroundColor = UIColor(red: 218/255.0, green: 218/255.0, blue: 222/255.0, alpha: 1.0)
            contentView.addSubview(horizonSperatorView)
            
            let buttonWidth = contentViewWidth / CGFloat((titleArray?.count)!)
            
            for (index,buttonTitle) in titleArray!.enumerated() {
                
                let button = UIButton.init(frame: CGRect.init(x: index * Int(buttonWidth), y: Int(horizonSperatorView.frame.origin.y+horizonSperatorView.frame.size.height), width: Int(buttonWidth), height: 44))
                button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
                button.setTitle(buttonTitle, for: .normal)
                button.tag = index
                button.setTitleColor(UIColor(red: 70/255.0, green: 130/255.0, blue: 180/255.0, alpha: 1.0), for: .normal)
                button.addTarget(self, action:#selector(buttonWithPressed(sender:)), for: .touchUpInside)
                buttonArray.append(button)
                contentView.addSubview(button)
                
                if index < ((titleArray?.count)!-1) {
                    let verticalSeperatorView = UIView.init(frame: CGRect.init(x: button.frame.origin.x+button.frame.size.width, y: button.frame.origin.y, width: 1, height: button.frame.size.height))
                    verticalSeperatorView.backgroundColor = UIColor(red: 218/255.0, green: 218/255.0, blue: 222/255.0, alpha: 1.0)
                    contentView.addSubview(verticalSeperatorView)
                }
            }
        }
    }
    
    @objc fileprivate func buttonWithPressed(sender: UIButton) {
        hidenAnimation()
        delegate?.alertViewSelectIndex(alertView: self, clickedButtonAtIndex: sender.tag)
    }
    
    fileprivate func getTitleSize() -> CGSize {
        let font = UIFont.systemFont(ofSize: 15.0)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byWordWrapping
        let attributes = [NSFontAttributeName:font,NSParagraphStyleAttributeName:paragraphStyle]
        
        var size = tiltle?.boundingRect(with: CGSize.init(width: contentViewWidth - (15 + 15 + iconImageView.frame.size.width + 5), height: 2000), options: .usesLineFragmentOrigin, attributes: attributes, context: nil).size
        
        size?.width = ceil((size?.width)!)
        size?.height=ceil((size?.height)!)
        return size!
    }
    
    fileprivate func getMessageSize() -> CGSize {
        let font = UIFont.systemFont(ofSize: 14.0)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5
        let attributes = [NSFontAttributeName:font,NSParagraphStyleAttributeName:paragraphStyle]
        var size = message?.boundingRect(with: CGSize.init(width: contentViewWidth - (30 + 30), height: 2000), options: .usesLineFragmentOrigin, attributes: attributes, context: nil).size
        
        size?.width = ceil((size?.width)!)
        size?.height=ceil((size?.height)!)
        return size!
    }
    
    public func show() {

        let window = UIApplication.shared.keyWindow
        let windowViews = window?.subviews
        if (windowViews != nil)&&(windowViews?.count)!>0 {
            let subView = windowViews?[(windowViews?.count)!-1]
            for aSubviews in (subView?.subviews)! {
                aSubviews.layer.removeAllAnimations()
            }
            subView?.addSubview(self)
            showBackground()
            showAlertAnimation()
        }
    }
    
    
    fileprivate func showBackground() {
        backView.alpha = 0
        UIView.beginAnimations("fadeIn", context: nil)
        UIView.setAnimationDuration(0.35)
        backView.alpha = 0.6
        UIView.commitAnimations()
    }
    
    fileprivate func showAlertAnimation() {

        let animation = CAKeyframeAnimation.init(keyPath: "transform")
        animation.duration = 0.30
        animation.isRemovedOnCompletion = true
        animation.fillMode = kCAFillModeForwards
        
        var values = [Any]()
        values.append(NSValue.init(caTransform3D: CATransform3DMakeScale(0.9, 0.9, 1.0)))
        values.append(NSValue.init(caTransform3D: CATransform3DMakeScale(1.1, 1.1, 1.0)))
        values.append(NSValue.init(caTransform3D: CATransform3DMakeScale(1.0, 1.0, 1.0)))
        animation.values = values
        contentView.layer.add(animation, forKey: nil)
    }
    
    public func hidenAnimation() {
        UIView.beginAnimations("fadeIn", context: nil)
        UIView.setAnimationDuration(0.35)
        backView.alpha = 0.0
        UIView.commitAnimations()
        self.removeFromSuperview()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        print("alertview 释放了")
    }
    
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        self.removeFromSuperview()
        self.endEditing(true)
    }
}


/**
 召修是否完成的AlertVIew
 */

fileprivate let screenW = UIScreen.main.bounds.size.width

class AlertView: UIView {
    
    var table: UITableView!
    var indexArray = [String]()
    var tempStr = "dd"
    
    var clickClouse: (()->Void)?
    
    
    lazy var titleLabel: UILabel = {
        let label = UILabel.init(frame: CGRect.init(x: 0, y: 20, width:screenW-30, height: 30))
        label.text = "再次处理确认"
        label.textAlignment = .center
        return label
    }()
    
    
    lazy var leftLabel: UILabel = {
        let label = UILabel.init(frame: CGRect.init(x: 15, y: 65, width: 110, height: 40))
        label.text = "再次确认原因:"
        return label
    }()
    
    var backView : UIView!
    var rightBtn: UIButton!
    var textField: UITextField!
    
    
    lazy var lineView: UIView = {
        let view = UIView.init(frame: CGRect.init(x: 0, y: 120, width: screenW-30, height: 1))
        view.backgroundColor = UIColor.init(red: 221/255.0, green: 223/255.0, blue: 224/255.0, alpha: 1.0)
        return view
    }()
    
    lazy var cancleButton: UIButton = {
        let button = UIButton.init(frame: CGRect.init(x: 15, y: 140, width: ((screenW-30)/2.0)-30, height: 50))
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16.0)
        button.setTitle("本次召修完成", for: .normal)
        button.layer.cornerRadius = 3
        button.layer.masksToBounds = true
        button.backgroundColor = UIColor.init(red: 37/255.0, green: 128/255.0, blue:  236/255.0, alpha: 1.0)
        return button
    }()
    
    lazy var confirmButton: UIButton = {
        let button = UIButton.init(frame: CGRect.init(x:(screenW/2.0), y: 140, width: ((screenW-30)/2.0)-30, height: 50))
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16.0)
        button.setTitle("本次召修未完成", for: .normal)
        button.layer.cornerRadius = 3
        button.layer.masksToBounds = true
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor.init(red: 221/255.0, green: 223/255.0, blue: 224/255.0, alpha: 1.0).cgColor
        button.setTitleColor(UIColor.black, for: .normal)
        return button
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
        addSubview(titleLabel)
        addSubview(leftLabel)
        addSubview(lineView)
        addSubview(cancleButton)
        addSubview(confirmButton)
        setSuviews()
    }
    
    func setSuviews()  {
        
        rightBtn = UIButton.init(frame: CGRect.init(x: screenW-210, y: 10, width: 20, height: 20))
        rightBtn.imageView?.contentMode = .scaleAspectFit
        rightBtn.setImage(UIImage.init(named: "down_dark0"), for: .normal)
        rightBtn.setImage(UIImage.init(named: "down_dark1"), for: .selected)
        rightBtn.addTarget(self, action: #selector(rightBtnClick), for: .touchUpInside)
        
        backView = UIView.init(frame: CGRect.init(x: 130, y: 65, width: screenW-175, height: 40))
        backView.layer.cornerRadius = 3
        backView.layer.masksToBounds = true
        backView.layer.borderColor = UIColor.init(red: 170/225.0, green: 206/255.0, blue: 244/255.0, alpha: 1.0).cgColor
        backView.layer.borderWidth = 1.0
        addSubview(backView)
        
        textField  = UITextField.init(frame: CGRect.init(x: 0, y: 5, width: screenW-215, height: 30))
        //        textField.attributedPlaceholder = NSAttributedString.init(string: "确认原因", attributes: [NSForegroundColorAttributeName: UIColor.gray])
        textField.isEnabled = false
        textField.textAlignment = .center
        backView.addSubview(textField)
        backView.addSubview(rightBtn)
        
        table = UITableView.init(frame: CGRect.init(x: 130, y: 106, width: screenW-175, height: 100), style: .plain);
        table.delegate = self
        table.dataSource = self
        table.rowHeight = 50
        table.isHidden = true
        table.layer.borderColor = UIColor.init(red: 170/225.0, green: 206/255.0, blue: 244/255.0, alpha: 1.0).cgColor
        table.layer.borderWidth = 1.0
        addSubview(table)
    }
    
    func rightBtnClick(button :UIButton) {
        print("展开tabeView")
        
        button.isSelected = !button.isSelected
        
        table.isHidden = !button.isSelected
        
//        if indexArray.count == 0 {
//            for index in 0...5 {
//                
//                let indexPath = IndexPath.init(row: index, section: 0)
//                indexArray.append(indexPath)
//                
//            }
//            table.insertRows(at: indexArray, with: .none)
//        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension AlertView: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        tableView.isHidden = true
        rightBtn.isSelected = false
        textField.text = indexArray[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: false)
        if let clickClouse = clickClouse {
            clickClouse()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("\(indexArray.count)pppppp")
        return indexArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellID = "cellID"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellID)
        if cell == nil{
            cell = UITableViewCell.init(style: .default, reuseIdentifier: cellID)
        }
        cell?.textLabel?.text = indexArray[indexPath.row]
        return cell!
    }
}


/**
 是否取消操作的AlertVIew
 */

class CancleAlertView: UIView {
    
    lazy var titleLabel: UILabel = {
        let label = UILabel.init(frame: CGRect.init(x: 0, y: 10, width:screenW-30, height: 20))
        label.text = "是否取消"
        label.textAlignment = .center
        return label
    }()
    
    lazy var reasonLabel: UILabel = {
        let label = UILabel.init(frame: CGRect.init(x: 20, y: 30, width:screenW-50, height: 20))
        label.text = "取消理由:"
        label.textColor = UIColor.lightGray
        label.textAlignment = .left
        return label
    }()
    
    lazy var reasonTextView: UITextView = {
        
        let textView = UITextView.init(frame: CGRect.init(x: 20, y: self.reasonLabel.frame.maxY+10, width: self.frame.maxX-40, height: 100))
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.init(red: 133/255.0, green: 191/255.0, blue: 246/255.0, alpha: 1.0).cgColor
        return textView
    }()
    
    lazy var cancleButton: UIButton = {
        let button = UIButton.init(frame: CGRect.init(x: 15, y: self.reasonTextView.frame.maxY+20, width: ((screenW-30)/2.0)-30, height: 50))
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16.0)
        button.setTitle("是", for: .normal)
        button.layer.cornerRadius = 3
        button.layer.masksToBounds = true
        button.backgroundColor = UIColor.init(red: 37/255.0, green: 128/255.0, blue:  236/255.0, alpha: 1.0)
        return button
    }()
    
    lazy var confirmButton: UIButton = {
        let button = UIButton.init(frame: CGRect.init(x:(screenW/2.0), y: self.reasonTextView.frame.maxY+20, width: ((screenW-30)/2.0)-30, height: 50))
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16.0)
        button.setTitle("否", for: .normal)
        button.layer.cornerRadius = 3
        button.layer.masksToBounds = true
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor.init(red: 221/255.0, green: 223/255.0, blue: 224/255.0, alpha: 1.0).cgColor
        button.setTitleColor(UIColor.black, for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        addSubview(titleLabel)
        addSubview(reasonLabel)
        addSubview(reasonTextView)
        addSubview(cancleButton)
        addSubview(confirmButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.endEditing(true)
    }
}
