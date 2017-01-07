//
//  SZPassWordChangeView.m
//  OTIS_PJ
//
//  Created by jQ on 16/5/12.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "SZPassWordChangeView.h"
// Tooltips
#import "JDFTooltips.h"
#import "SZChangePasswordRequest.h"
#import "SZChangePasswordTool.h"
#import "CustomIOSAlertView.h"
#import "AppDelegate+Version.h"
#import "UIView+Extension.h"
#import "AppDelegate.h"
@interface SZPassWordChangeView()
@property (weak, nonatomic) IBOutlet UIStackView *passwordFatherView;
@property (weak, nonatomic) IBOutlet UIView *imputNewPassWordView;

@property (weak, nonatomic) IBOutlet UIView *reImputNewPassWordView;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
// Tooltips
@property (nonatomic, strong) JDFSequentialTooltipManager *tooltipManager;
@end
@implementation SZPassWordChangeView
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

#pragma mark - 初始化登录界面
-(void)setUp
{
    //self.passwordFatherView.spacing = 8;
    [self.confirmBtn.layer setMasksToBounds:YES];
    [self.confirmBtn.layer setCornerRadius:5.0];
    [self.cancelBtn.layer setMasksToBounds:YES];
    [self.cancelBtn.layer setCornerRadius:5.0];
    [self.cancelBtn.layer setBorderWidth:1.0];
    self.cancelBtn.layer.borderColor=[UIColor colorWithHexString:@"d2d2d2"].CGColor;
    
    [self.imputNewPassWordView.layer setMasksToBounds:YES];
    [self.imputNewPassWordView.layer setCornerRadius:5.0];
    [self.imputNewPassWordView.layer setBorderWidth:1.0];
    self.imputNewPassWordView.layer.borderColor=[UIColor colorWithHexString:@"d2d2d2"].CGColor;
    [self.reImputNewPassWordView.layer setMasksToBounds:YES];
    [self.reImputNewPassWordView.layer setCornerRadius:5.0];
    [self.reImputNewPassWordView.layer setBorderWidth:1.0];
    self.reImputNewPassWordView.layer.borderColor=[UIColor colorWithHexString:@"d2d2d2"].CGColor;
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.imputNewPassWordTF resignFirstResponder];
    [self.reImputNewPassWordTF resignFirstResponder];
}

+ (instancetype) loadSZPassWordChangeView
{
    return [[[NSBundle mainBundle]loadNibNamed:@"SZPassWordChangeDetailView" owner:self options:nil]lastObject];
}
- (IBAction)confirmBTN:(id)sender {
        
    NSString *contiguousString = @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890";
    
    BOOL result =[self judgePasswordIsCanUse:@"789@"];
    
      NSLog(@"----------------%d",result);
    
    if ([self.imputNewPassWordTF.text isEqualToString:[OTISConfig username]]) {
        CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] initAlertDialogVieWithImageName:@""
                                                                                        dialogTitle:SZLocal(@"dialog.title.tip")
                                                                                     dialogContents:SZLocal(@"dialog.content.Password and user name can not be consistent, please re set")
                                                                                      dialogButtons:[NSMutableArray arrayWithObjects:SZLocal(@"btn.title.confirm"), nil]];
        alertView.onButtonTouchUpInside = ^(CustomIOSAlertView *alertView, int buttonIndex){
            _imputNewPassWordTF.text=@"";
            _reImputNewPassWordTF.text=@"";
            [alertView close];
        };
        [alertView show];
        return;
    }
    
    // 两次输入密码不一致
    if (![self.imputNewPassWordTF.text isEqualToString:_reImputNewPassWordTF.text]) {
        CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] initAlertDialogVieWithImageName:@""
                                                                                        dialogTitle:SZLocal(@"dialog.title.tip")
                                                                                     dialogContents:SZLocal(@"dialog.content.passwordNotConsistent")
                                                                                      dialogButtons:[NSMutableArray arrayWithObjects:SZLocal(@"btn.title.confirm"), nil]];
        alertView.onButtonTouchUpInside = ^(CustomIOSAlertView *alertView, int buttonIndex){
            _imputNewPassWordTF.text=@"";
            _reImputNewPassWordTF.text=@"";
            [alertView close];
        };
        [alertView show];
        return;
    }
    // 密码没有输入
    if (self.imputNewPassWordTF.text.length == 0 || self.reImputNewPassWordTF.text.length == 0) {
        CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] initAlertDialogVieWithImageName:@""
                                                                                        dialogTitle:SZLocal(@"dialog.title.tip")
                                                                                     dialogContents:SZLocal(@"dialog.content.passwordIsEmpty")
                                                                                      dialogButtons:[NSMutableArray arrayWithObjects:SZLocal(@"btn.title.confirm"), nil]];
        alertView.onButtonTouchUpInside = ^(CustomIOSAlertView *alertView, int buttonIndex){
            _imputNewPassWordTF.text=@"";
            _reImputNewPassWordTF.text=@"";
            [alertView close];
        };
        [alertView show];
        return;
    }
    // 密码长度小于4
    if (self.imputNewPassWordTF.text.length < 4) {

        CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] initAlertDialogVieWithImageName:@""
                                                                                        dialogTitle:SZLocal(@"dialog.title.tip")
                                                                                     dialogContents:SZLocal(@"dialog.content.passwordLessThan4")
                                                                                      dialogButtons:[NSMutableArray arrayWithObjects:SZLocal(@"btn.title.confirm"), nil]];
        alertView.onButtonTouchUpInside = ^(CustomIOSAlertView *alertView, int buttonIndex){
            _imputNewPassWordTF.text=@"";
            _reImputNewPassWordTF.text=@"";
            [alertView close];
        };
        [alertView show];
        return;
    }
    
    if (self.imputNewPassWordTF.text.length > 16) {
        
        CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] initAlertDialogVieWithImageName:@""
                                                                                        dialogTitle:SZLocal(@"dialog.title.tip")
                                                                                     dialogContents:SZLocal(@"dialog.content.Password length can not be greater than 16, please re set")
                                                                                      dialogButtons:[NSMutableArray arrayWithObjects:SZLocal(@"btn.title.confirm"), nil]];
        alertView.onButtonTouchUpInside = ^(CustomIOSAlertView *alertView, int buttonIndex){
            _imputNewPassWordTF.text=@"";
            _reImputNewPassWordTF.text=@"";
            [alertView close];
        };
        [alertView show];
        return;
    }
    
    // 含有连续字符
    if([contiguousString rangeOfString:self.imputNewPassWordTF.text].location != NSNotFound) {

        CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] initAlertDialogVieWithImageName:@""
                                                                                        dialogTitle:SZLocal(@"dialog.title.tip")
                                                                                     dialogContents:SZLocal(@"dialog.content.passwordContinuous")
                                                                                      dialogButtons:[NSMutableArray arrayWithObjects:SZLocal(@"btn.title.confirm"), nil]];
        alertView.onButtonTouchUpInside = ^(CustomIOSAlertView *alertView, int buttonIndex){
            _imputNewPassWordTF.text=@"";
            _reImputNewPassWordTF.text=@"";
            [alertView close];
        };
        [alertView show];
        return;
    }
    
    if (![self judgePasswordIsCanUse:self.imputNewPassWordTF.text]) {
        CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] initAlertDialogVieWithImageName:@""
                                                                                        dialogTitle:SZLocal(@"dialog.title.tip")
                                                                                     dialogContents:SZLocal(@"dialog.content.passwordformaterror")
                                                                                      dialogButtons:[NSMutableArray arrayWithObjects:SZLocal(@"btn.title.confirm"), nil]];
        alertView.onButtonTouchUpInside = ^(CustomIOSAlertView *alertView, int buttonIndex){
            _imputNewPassWordTF.text=@"";
            _reImputNewPassWordTF.text=@"";
            [alertView close];
        };
        [alertView show];
        return;
    }
    
    SZChangePasswordRequest *request = [[SZChangePasswordRequest alloc]init];
    
    if (!_isValidationCode) {
        request.OldPassword=[OTISConfig userPW];
        request.UserNo = [OTISConfig EmployeeID];
    }else{
        request.EmployeeID = _validationEmployeeID;
    }
    request.Password = self.imputNewPassWordTF.text;
    request.Ver = APIVersion;
    SZLog(@"---%@",request.mj_keyValues);
    [SZChangePasswordTool changePasswordWithRequest:request success:^{
        
        if (_isValidationCode) {
            if (self.backBlock) {
                self.backBlock();
            }
        }else{
            if (_isModol) {
                if (self.backBlock) {
                    self.backBlock();
                }
            }else{
                CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] initAlertDialogVieWithImageName:@""
                                                                                                dialogTitle:SZLocal(@"btn.title.Modify password")
                                                                                             dialogContents:SZLocal(@"dialog.content.Please use the new password next time you log in")
                                                                                              dialogButtons:[NSMutableArray arrayWithObjects:SZLocal(@"btn.title.confirm"), nil]];
                alertView.onButtonTouchUpInside = ^(CustomIOSAlertView *alertView, int buttonIndex){
                    [alertView close];
                    if (self.popBlock) {
                        self.popBlock();
                    }
                };
                [alertView show];
                
                [[NSUserDefaults standardUserDefaults] setObject:request.Password ?: @"" forKey:@"passWord"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
        }
//        AppDelegate*delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//        [delegate rootController];
        
    } failure:^(NSError *error) {
        NSString* content=[error.userInfo objectForKey:NSLocalizedDescriptionKey];
        
        CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] initAlertDialogVieWithImageName:@""
                                                                                        dialogTitle:SZLocal(@"dialog.title.tip")
                                                                                     dialogContents:content
                                                                                      dialogButtons:[NSMutableArray arrayWithObjects:SZLocal(@"btn.title.confirm"), nil]];
        alertView.onButtonTouchUpInside = ^(CustomIOSAlertView *alertView, int buttonIndex){
            _imputNewPassWordTF.text=@"";
            _reImputNewPassWordTF.text=@"";
            [alertView close];
        };
        [alertView show];
        return;
    }];
}

-(BOOL)judgePasswordIsCanUse:(NSString*)passWord{
    
    NSString* str4=@"~!@#$%^&*()_+?><';.*/-=";
    
    int isABC=0;
    int isabc=0;
    int is123= 0;
    int isOther= 0;
    
    for(int i =0; i < [passWord length]; i++)
    {
        char c=[passWord characterAtIndex:i];
        
        NSLog(@"----%c",c);
        
        if( (isABC==0)&&(c>='A'&& c<='Z')){
            isABC=1;
        }else if( (isabc==0)&& (c>='a'&&c<='z')){
            isabc=1;
        }else if((is123==0)&&(c>='0' && c<='9')){
            is123=1;
        }else if ((isOther==0) && [self judgeIsContainChar:str4 charStr:c]){
            isOther=1;
        }
    }
    return (isABC+isabc+is123+isOther) >=3;
}

-(BOOL)judgeIsContainChar:(NSString*)str charStr:(char)tempChar{
    

    for(int i =0; i < [str length]; i++)
    {
        if([str characterAtIndex:i] == tempChar){
            return YES;
        }
    }
    return NO;
}


@end
