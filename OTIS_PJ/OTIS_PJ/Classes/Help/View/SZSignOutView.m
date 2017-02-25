//
//  SZSignOutView.m
//  OTIS_PJ
//
//  Created by sunze on 16/6/12.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "SZSignOutView.h"
#import "AFNetworking.h"
#import "SZUploadManger.h"
#import "SZHttpTool.h"
#import "UIView+Extension.h"
#import "SZDownloadManger.h"
#import "CustomIOSAlertView.h"
#import "AppDelegate.h"
#import "AppDelegate+Version.h"
#import "SZClearLocalDataTool.h"
#import "UIView+Extension.h"

@interface SZSignOutView ()

@property(nonatomic,assign)BOOL isNetWork;

@property(nonatomic,strong) AFNetworkReachabilityManager *mgr;

@end

@implementation SZSignOutView

- (IBAction)signOutAct:(UIButton *)sender {
   WEAKSELF
    // 1.获得网络监控的管理者
    _mgr = [AFNetworkReachabilityManager sharedManager];
    //typeof(mgr) __weak weakSelf = mgr;
    // 2.设置网络状态改变后的处理
    [_mgr setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
       
        // 当网络状态改变了, 就会调用这个block
        switch (status) {
            case AFNetworkReachabilityStatusUnknown: // 未知网络
                [weakSelf alertViewLoad];
                break;
            case AFNetworkReachabilityStatusNotReachable: // 没有网络(断网)
                _isNetWork=YES;
                [weakSelf alertViewLoad];
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN: // 手机自带网络
                [weakSelf alertViewLoad];
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi: // WIFI
                [weakSelf alertViewLoad];
                break;
        }
    }];
    // 3.开始监控
    [_mgr startMonitoring];
}


-(void)alertViewLoad{
    
    CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] initAlertDialogVieWithImageName:@""
                                                                                    dialogTitle:SZLocal(@"dialog.title.tip")
                                                                                 dialogContents:SZLocal(@"dialog.title.Whether to withdraw from the system?")
                                                                                  dialogButtons:[NSMutableArray arrayWithObjects:SZLocal(@"btn.title.confirm"),SZLocal(@"btn.title.cencel"), nil]];
    alertView.onButtonTouchUpInside = ^(CustomIOSAlertView *alertView, int buttonIndex){
        if(buttonIndex == 0){
            [alertView close];
            [self syData];
        }else if(buttonIndex == 1){
            [alertView close];
        }
        [_mgr stopMonitoring];
    };
    [alertView show];
}

-(void)syData{
    
    UIView* lastView=[[UIApplication sharedApplication].windows lastObject];
    if ([SZClearLocalDataTool hasUploadData]) {
        WEAKSELF
        CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] initAlertDialogVieWithImageName:@""
                                                                                        dialogTitle:SZLocal(@"dialog.title.tip")
                                                                                     dialogContents:SZLocal(@"dialog.title.There is no upload data, whether to upload")
                                                                                      dialogButtons:[NSMutableArray arrayWithObjects:SZLocal(@"btn.title.confirm"),SZLocal(@"btn.title.cencel"), nil]];
        alertView.onButtonTouchUpInside = ^(CustomIOSAlertView *alertView, int buttonIndex){
            if(buttonIndex == 0){
                if (_isNetWork) {
                    if (self.signOutBlock) {
                        self.signOutBlock();
                    }
                }else{
                    [weakSelf signOutLogin:lastView];
                }
                [alertView close];
            }else if(buttonIndex == 1){
                if (_isNetWork) {
                    if (self.signOutBlock) {
                        self.signOutBlock();
                    }
                }else{
                    [weakSelf logout:lastView];
                }

                
                [alertView close];
            }
        };
        [alertView show];
    }else{
        if (_isNetWork) {
            if (self.signOutBlock) {
                self.signOutBlock();
            }
        }else{
            [self signOutLogin:lastView];
        }
    }
}

-(void)uploadDataError{
    WEAKSELF
    CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] initAlertDialogVieWithImageName:@""
                                                                                    dialogTitle:SZLocal(@"dialog.title.tip")
                                                                                 dialogContents:SZLocal(@"dialog.title.Data upload failed, please check the network")
                                                                                  dialogButtons:[NSMutableArray arrayWithObjects:SZLocal(@"btn.title.confirm"), nil]];
    alertView.onButtonTouchUpInside = ^(CustomIOSAlertView *alertView, int buttonIndex){
        if(buttonIndex == 0){
            [alertView close];
            if (weakSelf.signOutBlock) {
                weakSelf.signOutBlock();
            }
        }
    };
    [alertView show];
}


-(void)signOutLogin:(UIView*)view{
    NSMutableDictionary* dic=[NSMutableDictionary dictionary];
    if ([OTISConfig EmployeeID]&&[OTISConfig userPW]) {
        dic[@"UserNo"]=[OTISConfig EmployeeID];
        dic[@"Password"]=[OTISConfig userPW];
        dic[@"Ver"]=APIVersion;
    }
    
    WEAKSELF
    [SZHttpTool post:[SZNetwork stringByAppendingString:APIExitLogin] parameters:dic success:^(id obj) {
        
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:[obj dataUsingEncoding:NSUTF8StringEncoding]
                                                            options:NSJSONReadingMutableContainers
                                                              error:nil];
        SZLog(@"----%@--%@",dic,dic1);
        if ([dic1[@"Result"] isEqualToString:@"1"]) {
            //[view createWithMessage:@"退出失败"];
            if (weakSelf.signOutBlock) {
                weakSelf.signOutBlock();
            }
        }else{
                UIViewController *vc = [weakSelf viewController];
                [SZUploadManger startUploadWithView:vc.view success:^{
                    if (weakSelf.signOutBlock) {
                        weakSelf.signOutBlock();
                    }
                }];
        }
    } failure:^(NSError *error) {
        if (error.code == -1009) {//没有网络，本地登录
            AppDelegate*delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [delegate rootController];
        }
    }];
}


-(void)logout:(UIView*)view{
    NSMutableDictionary* dic=[NSMutableDictionary dictionary];
    if ([OTISConfig EmployeeID]&&[OTISConfig userPW]) {
        dic[@"UserNo"]=[OTISConfig EmployeeID];
        dic[@"Password"]=[OTISConfig userPW];
        dic[@"Ver"]=APIVersion;
    }
    
    WEAKSELF
    [SZHttpTool post:[SZNetwork stringByAppendingString:APIExitLogin] parameters:dic success:^(id obj) {
        
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:[obj dataUsingEncoding:NSUTF8StringEncoding]
                                                             options:NSJSONReadingMutableContainers
                                                               error:nil];
        SZLog(@"----%@--%@",dic,dic1);
        if ([dic1[@"Result"] isEqualToString:@"1"]) {
            //[view createWithMessage:@"退出失败"];
            if (weakSelf.signOutBlock) {
                weakSelf.signOutBlock();
            }
        }else{
            

            if (weakSelf.signOutBlock) {
                weakSelf.signOutBlock();
            }

        }
    } failure:^(NSError *error) {
        if (error.code == -1009) {//没有网络，本地登录
            AppDelegate*delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [delegate rootController];
        }
    }];
}


+ (instancetype) loadSZSignOutView
{
    return [[[NSBundle mainBundle]loadNibNamed:@"SZSignOutView" owner:self options:nil]lastObject];
}


@end
