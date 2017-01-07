//
//  SZgetBackPassWordView.m
//  OTIS_PJ
//
//  Created by jQ on 16/6/3.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "SZgetBackPassWordView.h"
#import "SZChangePasswordResponse.h"
#import "NSBundle+Extention.h"
#import "CustomIOSAlertView.h"
#import "SZHttpTool.h"
#import "UIView+Extension.h"

@interface SZgetBackPassWordView()
@property (weak, nonatomic) IBOutlet UIStackView *confirmInforStackView;
@property (weak, nonatomic) IBOutlet UIView *idParentView;
@property (weak, nonatomic) IBOutlet UIView *codeParentView;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic) IBOutlet UIButton *getConfirmCodeBtn;

@property(strong,nonatomic)SZForgetPasswordResponse* forgetPasswordResponse;

@property(nonatomic,copy)NSString* employID;
@property(assign,nonatomic)NSInteger time;
@end
@implementation SZgetBackPassWordView
- (BOOL)shouldAutorotate{
    
    return NO;
}

// 支持屏幕旋转
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    return NO;
}
// 画面一开始加载时就是竖向
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationPortrait;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    [self setUp];
}

#pragma mark - 初始化界面

- (void)setUp{
    [self.nextBtn.layer setMasksToBounds:YES];
    [self.nextBtn.layer setCornerRadius:5.0];
    [self.getConfirmCodeBtn.layer setMasksToBounds:YES];
    [self.getConfirmCodeBtn.layer setCornerRadius:5.0];
    [self.idParentView.layer setBorderWidth:1.0];
    self.idParentView.layer.borderColor=[UIColor colorWithHexString:@"d2d2d2"].CGColor;
    [self.codeParentView.layer setBorderWidth:1.0];
    self.codeParentView.layer.borderColor=[UIColor colorWithHexString:@"d2d2d2"].CGColor;
    self.userID.text = [OTISConfig username];

  
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.userID resignFirstResponder];
    [self.confirmCode resignFirstResponder];
}

+ (instancetype) loadSZgetBackPassWordView
{
    return [[[NSBundle mainBundle]loadNibNamed:@"SZgetBackPassWordView" owner:self options:nil]lastObject];
}
//获取确认码方法
- (IBAction)getConfirmCodeBtn:(id)sender {
    _time=120;
    UIButton* button=(UIButton*)sender;
    if (_userID.text.length == 0) {
        CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] initAlertDialogVieWithImageName:@""
                                                                                        dialogTitle:SZLocal(@"dialog.title.tip")
                                                                                     dialogContents:SZLocal(@"dialog.title.Please enter a user name!")
                                                                                      dialogButtons:[NSMutableArray arrayWithObjects:SZLocal(@"btn.title.confirm"), nil]];
        alertView.onButtonTouchUpInside = ^(CustomIOSAlertView *alertView, int buttonIndex){
            [alertView close];
        };
        [alertView show];
        return;
    }
    
    _timer=[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(start) userInfo:nil repeats:YES];
    [_timer fire];
    [button setTitle:[NSString stringWithFormat:@"%lds",(long)_time] forState:UIControlStateNormal];
    button.enabled=NO;
    [self sendValidationCode];
}

-(void)sendValidationCode{
    //[OTISConfig EmployeeID];
    [self textResignFirstResponder];
    SZForgetPasswordRequest* getValidationRequest=[[SZForgetPasswordRequest alloc] init];
    getValidationRequest.AppVersion=[NSBundle bundleVersionString];
    getValidationRequest.DeviceID=[[UIDevice currentDevice].identifierForVendor UUIDString];
    getValidationRequest.OsVersion=[[UIDevice currentDevice] systemVersion];
    getValidationRequest.UserNo=_userID.text;
    getValidationRequest.Ver=APIVersion;

    
    [SZHttpTool post:[SZNetwork stringByAppendingString:APIValidationCode] parameters:getValidationRequest.mj_keyValues success:^(id obj) {
        SZForgetPasswordResponse* forgetPasswordResponse=[SZForgetPasswordResponse mj_objectWithKeyValues:obj];
        _forgetPasswordResponse=forgetPasswordResponse;
        _employID=_forgetPasswordResponse.EmployeeID;
        NSInteger index=[forgetPasswordResponse.Result integerValue];
        
        switch (index) {
            case 0:
                //验证吗发送成功
                [self createWithMessage:SZLocal(@"dialog.title.Verification code has been sent")];
                break;
            case 1:
                //账号不存在
                [self createWithMessage:SZLocal(@"dialog.title.Account does not exist")];
                break;
            case 2:
                //账户没有绑定电话号/账户绑定的电话号不正确
                [self createWithMessage:SZLocal(@"Account number is not bound by phone number / Account No")];
                break;
                
            case 32:
                //账户没有绑定电话号/账户绑定的电话号不正确
                [self createWithMessage:SZLocal(@"Repeated send verification code to the user's mobile phone")];
                break;
                
            default:
                //发送失败
                [self createWithMessage:SZLocal(@"dialog.title.Verification code sent failed")];
                [self stopTimer];
                self.getConfirmCodeBtn.enabled=YES;
                [self.getConfirmCodeBtn setTitle:SZLocal(@"dialog.title.Re acquisition") forState:UIControlStateNormal];
                break;
        }
        
    } failure:^(NSError *error) {
        [self createWithMessage:SZLocal(@"dialog.title.Network request failed, please check the network")];
        [self stopTimer];
        self.getConfirmCodeBtn.enabled=YES;
        [self.getConfirmCodeBtn setTitle:SZLocal(@"dialog.title.Re acquisition") forState:UIControlStateNormal];
    }];
}


-(void)start{
    _time--;
    if (_time==0) {
        [self stopTimer];
        self.getConfirmCodeBtn.enabled=YES;
        [self.getConfirmCodeBtn setTitle:SZLocal(@"dialog.title.Re acquisition") forState:UIControlStateNormal];
    }else{
        [self.getConfirmCodeBtn setTitle:[NSString stringWithFormat:@"%ld s",(long)_time] forState:UIControlStateDisabled];
    }
}

-(void)stopTimer{
    [_timer invalidate];
    _timer=nil;
}

//下一步方法
- (IBAction)nextBTN:(id)sender {
    [self textResignFirstResponder];
    if (_userID.text.length == 0||_confirmCode.text.length==0) {
        CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] initAlertDialogVieWithImageName:@""
                                                                                        dialogTitle:SZLocal(@"dialog.title.tip")
                                                                                     dialogContents:SZLocal(@"dialog.title.Please enter user name and verification code!")
                                                                                      dialogButtons:[NSMutableArray arrayWithObjects:SZLocal(@"btn.title.confirm"), nil]];
        alertView.onButtonTouchUpInside = ^(CustomIOSAlertView *alertView, int buttonIndex){
            [alertView close];
        };
        [alertView show];
        [self textResignFirstResponder];
        return;
    }
    
    SZForgetPasswordRequest* checkValidationRequest=[[SZForgetPasswordRequest alloc] init];
    checkValidationRequest.AppVersion=[NSBundle bundleVersionString];
    checkValidationRequest.DeviceID=[[UIDevice currentDevice].identifierForVendor UUIDString];
    checkValidationRequest.OsVersion=[[UIDevice currentDevice] systemVersion];
    checkValidationRequest.UserNo=_userID.text;
    checkValidationRequest.EmployeeID=_employID;
    checkValidationRequest.ValidationCode=_confirmCode.text;
    checkValidationRequest.Ver=APIVersion;
    NSLog(@"--%@",_employID);
    
    if (!_employID) {
        [self createWithMessage:SZLocal(@"Please get the verification code")];
        return;
    }
    
    [SZHttpTool post:[SZNetwork stringByAppendingString:APICheckValidationCode] parameters:checkValidationRequest.mj_keyValues success:^(id obj) {
        
        SZForgetPasswordResponse* forgetPasswordResponse=[SZForgetPasswordResponse mj_objectWithKeyValues:obj];
        self.forgetPasswordResponse=forgetPasswordResponse;
        NSInteger index=[forgetPasswordResponse.Result integerValue];
        
        switch (index) {
            case 0:
                //验证吗验证成功
            {
                if (self.next) {
                    self.next(_employID);
                }
            }
                break;
            case 1:
                //验证吗已过期
                [self createWithMessage:SZLocal(@"dialog.title.Verification code has expired")];
                break;
                
            default:
                [self createWithMessage:SZLocal(@"dialog.title.Validation failure")];
                break;
        }
        
    } failure:^(NSError *error) {
        [self createWithMessage:SZLocal(@"dialog.title.Network request failed, please check the network")];
    }];
}


-(void)textResignFirstResponder{
    [_confirmCode resignFirstResponder];
    [_userID resignFirstResponder];
}

@end
