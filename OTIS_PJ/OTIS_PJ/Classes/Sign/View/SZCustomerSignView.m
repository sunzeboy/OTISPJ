//
//  SZCustomerSignView.m
//  OTIS_PJ
//
//  Created by jQ on 16/5/14.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "SZCustomerSignView.h"
#import "SZSignatureBoardViewController.h"

@interface SZCustomerSignView()<UITextFieldDelegate>


@end

@implementation SZCustomerSignView
- (void)awakeFromNib {
    [super awakeFromNib];
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClickImage:)];
    self.signatureImage.userInteractionEnabled = true;
    [self.signatureImage addGestureRecognizer:singleTap];
    
    //注册键盘弹起与收起通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
}

+ (instancetype) loadSZCustomerSignView
{
    return [[[NSBundle mainBundle]loadNibNamed:@"SZCustomerSignDetailView" owner:self options:nil]lastObject];
}

- (void)setSignDetail:(SZCustomerSignDetail *)signDetail{
    _signDetail = signDetail;

    self.emailAddress.userInteractionEnabled = NO;
    self.emailAddress.delegate = self;
    //签字图片时设置
    CALayer * layer = [_signatureImage layer];
    layer.borderColor = [UIColor colorWithHexString:@"b4d3f5"].CGColor;
    layer.borderWidth = 1.0f;
    //
    self.customerName.delegate = self;
    CALayer * layerCN =[self.customerName layer];
    layerCN.borderColor = [UIColor colorWithHexString:@"b4d3f5"].CGColor;
    layerCN.borderWidth = 1.0f;
    //
    CALayer * layerEA =[self.emailAddress layer];
    layerEA.borderColor = [UIColor colorWithHexString:@"b4d3f5"].CGColor;
    layerEA.borderWidth = 1.0f;
    
    if (signDetail.signatureImage != nil){
//        SZLog(@"view start set over1:nil");
//        signDetail.signatureImage = [UIImage imageWithCGImage:signDetail.signatureImage.CGImage scale:1 orientation:UIImageOrientationLeft];
        self.signatureImage.image = signDetail.signatureImage;
    }
    
    [self.saVerySatisfied setBackgroundImage:[UIImage imageNamed:@"check_on"] forState:UIControlStateSelected];
    [self.saVerySatisfied setBackgroundImage:[UIImage imageNamed:@"check_off"] forState:UIControlStateNormal];
    [self.saSatisfied setBackgroundImage:[UIImage imageNamed:@"check_on"] forState:UIControlStateSelected];
    [self.saSatisfied setBackgroundImage:[UIImage imageNamed:@"check_off"] forState:UIControlStateNormal];
    [self.saUnsatisfied setBackgroundImage:[UIImage imageNamed:@"check_on"] forState:UIControlStateSelected];
    [self.saUnsatisfied setBackgroundImage:[UIImage imageNamed:@"check_off"] forState:UIControlStateNormal];
    [self.mqVerySatisfied setBackgroundImage:[UIImage imageNamed:@"check_on"] forState:UIControlStateSelected];
    [self.mqVerySatisfied setBackgroundImage:[UIImage imageNamed:@"check_off"] forState:UIControlStateNormal];
    [self.mqSatisfied setBackgroundImage:[UIImage imageNamed:@"check_on"] forState:UIControlStateSelected];
    [self.mqSatisfied setBackgroundImage:[UIImage imageNamed:@"check_off"] forState:UIControlStateNormal];
    [self.mqUnsatisfied setBackgroundImage:[UIImage imageNamed:@"check_on"] forState:UIControlStateSelected];
    [self.mqUnsatisfied setBackgroundImage:[UIImage imageNamed:@"check_off"] forState:UIControlStateNormal];
    [self.customerAbsence setBackgroundImage:[UIImage imageNamed:@"check_on"] forState:UIControlStateSelected];
    [self.customerAbsence setBackgroundImage:[UIImage imageNamed:@"check_off"] forState:UIControlStateNormal];
    [self.sendEmail setBackgroundImage:[UIImage imageNamed:@"check_on"] forState:UIControlStateSelected];
    [self.sendEmail setBackgroundImage:[UIImage imageNamed:@"check_off"] forState:UIControlStateNormal];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:)
                                                name:@"UITextFieldTextDidChangeNotification"
                                              object:self.customerName];

}
//服务态度
- (IBAction)saVerySatisfied:(UIButton *)sender {
    if (!self.customerAbsence.selected){
        sender.selected = !sender.selected;
        [self singleSelect:0];
    }
}
- (IBAction)saSatisfied:(UIButton *)sender {
    if (!self.customerAbsence.selected){
        sender.selected = !sender.selected;
        [self singleSelect:1];
    }
}
- (IBAction)saUnsatisfied:(UIButton *)sender {
    if (!self.customerAbsence.selected){
        sender.selected = !sender.selected;
        [self singleSelect:2];
    }
}
//保养质量
- (IBAction)mqVerySatisfied:(UIButton *)sender {
    if (!self.customerAbsence.selected){
        sender.selected = !sender.selected;
        [self singleSelect:3];
    }
}
- (IBAction)mqSatisfied:(UIButton *)sender {
    if (!self.customerAbsence.selected){
        sender.selected = !sender.selected;
        [self singleSelect:4];
    }
}
- (IBAction)mqUnsatisfied:(UIButton *)sender {
    if (!self.customerAbsence.selected){
        sender.selected = !sender.selected;
        [self singleSelect:5];
    }
}
//客户不在
- (IBAction)customerAbsence:(UIButton *)sender {

    sender.selected = !sender.selected;
    if (sender.selected){
        self.saVerySatisfied.selected = NO;
        self.saSatisfied.selected = NO;
        self.saUnsatisfied.selected = NO;
        
        self.mqVerySatisfied.selected = NO;
        self.mqSatisfied.selected = NO;
        self.mqUnsatisfied.selected = NO;
        
        self.customerName.text = @"";
        self.customerName.userInteractionEnabled = NO;
        
        self.sendEmail.selected = NO;
        self.emailAddress.text = @"";
        self.emailAddress.userInteractionEnabled = NO;
        if (self.signatureImage.image != nil){
        self.signatureImage.image = [[UIImage alloc]init];
        }
    } else {
        self.customerName.userInteractionEnabled = YES;
        self.emailAddress.userInteractionEnabled = YES;
    }
}
//发送电子邮件
- (IBAction)sendEmail:(UIButton *)sender {
  if (!self.customerAbsence.selected){
      sender.selected = !sender.selected;
      //发送电子邮件选中时，编辑点子邮件地址
      if(sender.selected){
          self.emailAddress.userInteractionEnabled = YES;
          self.emailAddress.text = @"";
      }else{
          self.emailAddress.text = @"";
          self.emailAddress.userInteractionEnabled = NO;
      }
  }
}

////点击保存
//- (IBAction)saveSignature:(id)sender {
//    [self.delegate saveBtnClick];
//}
//点击图片与重写进入签字板
-(void)onClickImage:(UITapGestureRecognizer*)recognizer{
    // here, do whatever you wantto do
    if (!self.customerAbsence.selected){
        [self.delegate toSignatureBoard];
    }
}

- (void)singleSelect:(NSInteger )index{
    //服务态度
    if(index == 0){
        self.saSatisfied.selected = NO;
        self.saUnsatisfied.selected = NO;
    }else if(index == 1){
        self.saVerySatisfied.selected = NO;
        self.saUnsatisfied.selected = NO;
    }else if(index == 2){
        self.saVerySatisfied.selected = NO;
        self.saSatisfied.selected = NO;
    //保养质量
    }else if(index == 3){
        self.mqSatisfied.selected = NO;
        self.mqUnsatisfied.selected = NO;
    }else if(index == 4){
        self.mqVerySatisfied.selected = NO;
        self.mqUnsatisfied.selected = NO;
    }else if(index == 5){
        self.mqVerySatisfied.selected = NO;
        self.mqSatisfied.selected = NO;
    }
    
   
    if (index<3) {
        if (self.evaluateTypeBlock) {
            self.evaluateTypeBlock(index+1,1);
        }
    }else{
        if (self.evaluateTypeBlock) {
            self.evaluateTypeBlock(index-2,2);
        }
    }
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    [self textResignFirstResponder];
    
}

-(void)textResignFirstResponder{
    [self.customerName resignFirstResponder];
    [self.emailAddress resignFirstResponder];
}


- (IBAction)resignAct:(UIButton *)sender {
    if (self.confirmActBlock) {
        self.confirmActBlock(sender);
    }
}

- (IBAction)confirmAct:(UIButton *)sender {
    if (self.confirmActBlock) {
        self.confirmActBlock(sender);
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self endEditing:YES];
    return  YES;

}
-(void)textFiledEditChanged:(NSNotification *)obj{
    UITextField *textField = (UITextField *)obj.object;
    
    NSString *toBeString = textField.text;
    NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > kMaxLength) {
                textField.text = [toBeString substringToIndex:kMaxLength];
            }
        }
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
            
        }
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        if (toBeString.length > kMaxLength) {
            textField.text = [toBeString substringToIndex:kMaxLength];
        }  
    }  
}




-(void)keyboardWillShow:(NSNotification *)note
{
    NSDictionary *info = [note userInfo];
    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    CGFloat  _keyBoardHeight = keyboardSize.height;
    
    
    CGRect frame = _emailAddress.frame;
    int offset = frame.origin.y + 32 - (self.frame.size.height -_keyBoardHeight);
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
    if(offset > 0)
        self.frame = CGRectMake(0.0f, -offset, self.frame.size.width, self.frame.size.height);
    [UIView commitAnimations];
}


//输入框编辑完成以后，将视图恢复到原始状态
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.frame =CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [UIView commitAnimations];
    
}




@end
