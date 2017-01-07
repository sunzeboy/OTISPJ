//
//  SZPassWordChangeViewController.m
//  OTIS_PJ
//
//  Created by jQ on 16/5/12.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "SZPassWordChangeViewController.h"
#import "SZPassWordChangeView.h"
#import "CustomIOSAlertView.h"
#import "UIView+Extension.h"
@interface SZPassWordChangeViewController ()
@property (strong,nonatomic)SZPassWordChangeView *changePWView;
@end

@implementation SZPassWordChangeViewController
//

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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = SZLocal(@"title.passwordChange");
    [self setUpchangePWView];
    if (self.isModal||self.isValidationCode) {
        [self setLeftItme];
    }else{
        [self setNavItem];
    }
}

-(void)setNavItem{

    UIButton* backBtn=[[UIButton alloc] init];
    backBtn.bounds=CGRectMake(0, 0, 50, 30);
    backBtn.imageEdgeInsets=UIEdgeInsetsMake(0, -10, 0, 0);
    backBtn.titleLabel.font=[UIFont systemFontOfSize:14.0];
    backBtn.imageView.contentMode=UIViewContentModeScaleAspectFit;
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setTitle:SZLocal(@"btn.title.back") forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"return"] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];

}

-(void)setLeftItme{
    UIButton* backBtn=[[UIButton alloc] init];
    backBtn.bounds=CGRectMake(0, 0, 50, 30);
    backBtn.imageEdgeInsets=UIEdgeInsetsMake(0, -10, 0, 0);
    backBtn.titleLabel.font=[UIFont systemFontOfSize:14.0];
    backBtn.imageView.contentMode=UIViewContentModeScaleAspectFit;
    [backBtn addTarget:self action:@selector(cancle) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setTitle:SZLocal(@"btn.title.back") forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"return"] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
}


-(void)back{
    CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] initAlertDialogVieWithImageName:@""
                                                                                    dialogTitle:SZLocal(@"dialog.title.tip")
                                                                                 dialogContents:SZLocal(@"dialog.content.changepasswordtip")
                                                                                  dialogButtons:[NSMutableArray arrayWithObjects:SZLocal(@"btn.title.confirm"),SZLocal(@"btn.title.cencel"), nil]];
    alertView.onButtonTouchUpInside = ^(CustomIOSAlertView *alertView, int buttonIndex){
        if(buttonIndex == 0){
            [self.navigationController popViewControllerAnimated:YES];
            [alertView close];
        }else if(buttonIndex == 1){
            [alertView close];
        }
    };
    [alertView show];
}


-(void)cancle{
    CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] initAlertDialogVieWithImageName:@""
                                                                                    dialogTitle:SZLocal(@"dialog.title.tip")
                                                                                 dialogContents:SZLocal(@"dialog.content.changepasswordtip")
                                                                                  dialogButtons:[NSMutableArray arrayWithObjects:SZLocal(@"btn.title.confirm"),SZLocal(@"btn.title.cencel"), nil]];
    alertView.onButtonTouchUpInside = ^(CustomIOSAlertView *alertView, int buttonIndex){
        if(buttonIndex == 0){
            [self.navigationController dismissViewControllerAnimated:YES completion:^{
            }];
            [alertView close];
        }else if(buttonIndex == 1){
            [alertView close];
        }
    };
    [alertView show];
}


-(void)setUpchangePWView
{
    WEAKSELF
    NSLog(@"%@",_validationEmployeeID);
    _changePWView = [SZPassWordChangeView loadSZPassWordChangeView];
    _changePWView.isValidationCode=_isValidationCode;
    _changePWView.validationEmployeeID=_validationEmployeeID;
    _changePWView.isModol=_isModal;
    //数据设置给View
    _changePWView.frame =CGRectMake(0, 64, SCREEN_WIDTH,(SCREEN_HEIGHT - 64));
    [self.view addSubview:_changePWView];
    
    if (_isValidationCode||_isModal) {
        _changePWView.backBlock=^{
            [weakSelf.navigationController dismissViewControllerAnimated:NO completion:^{
                CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] initAlertDialogVieWithImageName:@""
                                                                                                dialogTitle:SZLocal(@"btn.title.Modify password")
                                                                                             dialogContents:SZLocal(@"dialog.content.Modify the success, please use the new password to re login")
                                                                                              dialogButtons:[NSMutableArray arrayWithObjects:SZLocal(@"btn.title.confirm"), nil]];
                alertView.onButtonTouchUpInside = ^(CustomIOSAlertView *alertView, int buttonIndex){
                    [alertView close];
                };
                [alertView show];
            }];
        };
    }else{
        _changePWView.popBlock=^{
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
        };
    }
}

@end
