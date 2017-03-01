//
//  SZLoginViewController.m
//  OTIS_PJ
//
//  Created by sunze on 16/4/22.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "SZLoginViewController.h"

#import "SZLoginHttpTool.h"
#import "SZLoginRequest.h"
#import "UIDevice+Extention.h"
#import "NSBundle+Extention.h"
#import "SZDownloadManger.h"
#import "SZTable_User.h"
#import "HomeViewController.h"
#import "AppDelegate.h"
#import "SZTable_Schedules.h"
#import "NSDate+Extention.h"
#import "UIView+Extension.h"
#import "CustomIOSAlertView.h"
#import "SZNavigationController.h"
#import "SZgetBackPassWordDetailViewController.h"
#import "MBProgressHUD.h"
#import "HyperlinksButton.h"
#import "SZPassWordChangeViewController.h"
#import "SZClearLocalDataTool.h"
#import "NSString+Extention.h"
#import "NSDate+Extention.h"
#import "SZSuperUserViewController.h"

#import "UIViewController+Email.h"

@interface SZLoginViewController ()

@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@property (weak, nonatomic) IBOutlet HyperlinksButton *reSetBtn;
/**
 *  整个输入框父控件
 */
@property (weak, nonatomic) IBOutlet UIStackView *loginFatherView;
/**
 *  user输入框父控件
 */
@property (weak, nonatomic) IBOutlet UIView *userFatherView;
/**
 *  password输入框父控件
 */
@property (weak, nonatomic) IBOutlet UIView *passwordFatherView;

@property (weak, nonatomic) IBOutlet UILabel *verson;


@property (weak, nonatomic) IBOutlet UILabel *telPhoneNum;

@property (weak, nonatomic) IBOutlet UILabel *mailLabel;

@end

@implementation SZLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUp];

    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"SZOuterNetwork"]) {
        SZOuterNetwork = [[NSUserDefaults standardUserDefaults] objectForKey:@"SZOuterNetwork"];
        SZNetwork = [[NSUserDefaults standardUserDefaults] objectForKey:@"SZOuterNetwork"];
    }
    
    NSMutableAttributedString *content = [[NSMutableAttributedString alloc] initWithString:@"OES系统支持热线：0571-81608858"];
    
    NSRange contentRange = {10, [content length]-10};
    
    [content addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:contentRange];
    [content addAttribute:NSForegroundColorAttributeName value:RGB(30, 32, 81) range:contentRange];
    
    self.telPhoneNum.attributedText = content;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTel)];
    
    [self.telPhoneNum addGestureRecognizer:tap];

    NSMutableAttributedString *content3 = [[NSMutableAttributedString alloc] initWithString:@"邮箱：zhengln@otis.com"];
    NSRange contentRange3 = {3, [content3 length]-3};
    [content3 addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:contentRange3];
    [content3 addAttribute:NSForegroundColorAttributeName value:RGB(30, 32, 81) range:contentRange3];
    self.mailLabel.attributedText = content3;
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTel3)];
    [self.mailLabel addGestureRecognizer:tap3];

    
}

-(void)tapTel{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"telprompt:0571-81608858"]];
}
-(void)tapTel3{
    [self sendEmailWithCompose:[SZMailCompose composeWithsubject:nil toRecipients:@[@"zhengln@otis.com"] ccRecipients:nil bccRecipients:nil andeMailContent:nil]];
}


- (BOOL)shouldAutorotate{
    
    return NO;
}

//支持的方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

// 支持屏幕旋转
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    return NO;
}
// 画面一开始加载时就是竖向
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationPortrait;
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

#pragma mark - 初始化登录界面
-(void)setUp
{
    self.verson.text = [NSString stringWithFormat:@"V%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
    [self.loginBtn.layer setMasksToBounds:YES];
    [self.loginBtn.layer setCornerRadius:5.0];
    [self.reSetBtn.layer setMasksToBounds:YES];
    [self.reSetBtn.layer setCornerRadius:5.0];
    //[self.reSetBtn.layer setBorderWidth:1.0];
    self.reSetBtn.layer.borderColor=[UIColor colorWithHexString:@"d2d2d2"].CGColor;
    [self.reSetBtn setColor:[UIColor colorWithHexString:@"0079FF"]];
    
    
    [self.passwordFatherView.layer setBorderWidth:1.0];
    self.passwordFatherView.layer.borderColor=[UIColor colorWithHexString:@"d2d2d2"].CGColor;
    [self.userFatherView.layer setBorderWidth:1.0];
    self.userFatherView.layer.borderColor=[UIColor colorWithHexString:@"d2d2d2"].CGColor;
    self.userNameTF.text = [OTISConfig username];
    //self.userNameTF.text = @"119195";
    //self.passWordTF.text = @"bbb.123";
    
    
    [self.view layoutIfNeeded];
    UIImage *imageEYe = [UIImage imageNamed:@"yanjing1"];
    UIImage *imageEYe2 = [UIImage imageNamed:@"yanjing2"];

    CGFloat w = imageEYe.size.width*2/3;
    CGFloat h = imageEYe.size.height*2/3;
    CGFloat x = SCREEN_WIDTH-30-w;
    CGRect rect = [self.passWordTF.leftView convertRect:self.passWordTF.leftView.frame toView:self.view];
    CGFloat y = CGRectGetMinY(rect)-9;
    UIButton *btnEye = [UIButton buttonWithType:UIButtonTypeCustom];
    btnEye.frame = CGRectMake(x, y, w, h);
    [btnEye setImage:imageEYe forState:UIControlStateSelected];
    [btnEye setImage:imageEYe2 forState:UIControlStateNormal];
    [btnEye setAdjustsImageWhenHighlighted:NO];
    
//    btnEye setImage:<#(nullable UIImage *)#> forState:<#(UIControlState)#>
    [btnEye addTarget:self action:@selector(blink:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnEye];
    self.passWordTF.secureTextEntry = !btnEye.selected;

}

-(void)blink:(UIButton *)btn{
    
    btn.selected = !btn.selected;
    
    self.passWordTF.secureTextEntry = !btn.selected;

}

- (void) customIOS7dialogButtonTouchUpInside:(id)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self textResignFirstResponder];
}

-(void)textResignFirstResponder{
    [self.userNameTF resignFirstResponder];
    [self.passWordTF resignFirstResponder];
}

#pragma mark - 登录重置操作
- (IBAction)loginAct:(id)sender {
    if (![self.userNameTF.text isEqualToString:[OTISConfig username]]) {
//        [SZClearLocalDataTool clear];
    }
    
    // 判断用户名和密码是否为空
    if (self.userNameTF.text.length == 0 || self.passWordTF.text.length == 0) {
        CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] initAlertDialogVieWithImageName:@""
                                                                                        dialogTitle:SZLocal(@"dialog.title.tip")
                                                                                     dialogContents:SZLocal(@"dialog.content.enterUserAndPwd")
                                                                                      dialogButtons:[NSMutableArray arrayWithObjects:SZLocal(@"btn.title.confirm"), nil]];
        alertView.onButtonTouchUpInside = ^(CustomIOSAlertView *alertView, int buttonIndex){
            [alertView close];
        };
        [alertView show];
        [self textResignFirstResponder];

        return;
    }
    // 判断用户名大于20字。
    if (self.userNameTF.text.length > 20) {
        CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] initAlertDialogVieWithImageName:@""
                                                                                        dialogTitle:SZLocal(@"dialog.title.tip")
                                                                                     dialogContents:SZLocal(@"dialog.content.userMoreThan20")
                                                                                      dialogButtons:[NSMutableArray arrayWithObjects:SZLocal(@"btn.title.confirm"), nil]];
        alertView.onButtonTouchUpInside = ^(CustomIOSAlertView *alertView, int buttonIndex){
            [alertView close];
        };
        [alertView show];
        [self textResignFirstResponder];

        return;
    }
    // 判断密码大于16字
    if (self.passWordTF.text.length > 16) {
        CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] initAlertDialogVieWithImageName:@""
                                                                                        dialogTitle:SZLocal(@"dialog.title.tip")
                                                                                     dialogContents:SZLocal(@"dialog.content.pwdMoreThan16")
                                                                                      dialogButtons:[NSMutableArray arrayWithObjects:SZLocal(@"btn.title.confirm"), nil]];
        alertView.onButtonTouchUpInside = ^(CustomIOSAlertView *alertView, int buttonIndex){
            [alertView close];
        };
        [alertView show];
        return;
    }
    

    if ([self.userNameTF.text isEqualToString:@"admin"]&&[self.passWordTF.text isEqualToString:@"abc.123"]) {
        [self presentViewController:[[SZSuperUserViewController alloc] init] animated:YES completion:nil];
        return;
    }
    
    
#if 1
    MBProgressHUD *hud =[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;

    [SZLoginHttpTool loginWithRequest:[SZLoginRequest requestWithUserNo:self.userNameTF.text Password:self.passWordTF.text Number:[UIDevice currentDeviceUUIDString] Ver:APIVersion] success:^(NSString* str){
        [self.view endEditing:YES];
        [MBProgressHUD hideHUDForView:self.view animated:YES];

        if ([str isEqualToString:@"2"] ) {
            HomeViewController *vc = [[HomeViewController alloc] init];
            vc.isLocalLogin = YES;
            SZNavigationController *nav = [[SZNavigationController alloc] initWithRootViewController:vc];
            [UIApplication sharedApplication].delegate.window.rootViewController = nav;
            return ;
        }else if ([str isEqualToString:@"1"]){
            HomeViewController *vc = [[HomeViewController alloc] init];
            vc.isLocalLogin = NO;
            SZNavigationController *nav = [[SZNavigationController alloc] initWithRootViewController:vc];
            [UIApplication sharedApplication].delegate.window.rootViewController = nav;
            return ;
        }
        
        
        

    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        SZLog(@"%@",error);
        NSString *content = [error.userInfo objectForKey:@"NSLocalizedDescription"];
        CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] initAlertDialogVieWithImageName:@"person"
                                                                                        dialogTitle:SZLocal(@"dialog.title.tip")
                                                                                     dialogContents:content
                                                                                      dialogButtons:[NSMutableArray arrayWithObjects:SZLocal(@"btn.title.confirm"), nil]];
        alertView.onButtonTouchUpInside = ^(CustomIOSAlertView *alertView, int buttonIndex){
            [alertView close];
            if ([content isEqualToString:SZLocal(@"error.OTISLoginStateResetThePassword")]) {
                SZPassWordChangeViewController* passWordChangeVC=[[SZPassWordChangeViewController alloc] init];
                passWordChangeVC.isModal=YES;
                SZNavigationController* nav=[[SZNavigationController alloc] initWithRootViewController:passWordChangeVC];
                [self presentViewController:nav animated:YES completion:nil];
            }else if ([content isEqualToString:SZLocal(@"error.OTISLoginStatePasswordExpired")]){
                SZPassWordChangeViewController* passWordChangeVC=[[SZPassWordChangeViewController alloc] init];
                passWordChangeVC.isModal=YES;
                SZNavigationController* nav=[[SZNavigationController alloc] initWithRootViewController:passWordChangeVC];
                [self presentViewController:nav animated:YES completion:nil];
            }else if ([content isEqualToString:SZLocal(@"dialog.content.LoginMustWorkNet")]){
               
            }
        };
        [alertView show];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
    

    
#endif
        
}

- (IBAction)resetAct:(UIButton *)sender {
    SZgetBackPassWordDetailViewController *gbvc =[[SZgetBackPassWordDetailViewController alloc]init];
    SZNavigationController *nav = [[SZNavigationController alloc] initWithRootViewController:gbvc];
//    [UIApplication sharedApplication].delegate.window.rootViewController = nav;
    [self presentViewController:nav animated:YES completion:^{}];
}


@end
