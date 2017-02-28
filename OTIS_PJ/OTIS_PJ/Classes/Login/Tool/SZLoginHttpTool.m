//
//  SZLoginHttpTool.m
//  OTIS_PJ
//
//  Created by sunze on 16/4/22.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "SZLoginHttpTool.h"
#import "SZHttpTool.h"
#import "SZLoginRequest.h"
#import "SZTable_User.h"
#import "SZLogoutRequest.h"
#import "NSError+Extention.h"
#import "SZLoginResponse.h"
#import "SZUserInfo.h"
#import "SZTable_UserRoute.h"
#import "SZTable_UserSupervisor.h"
#import "NSData+AES256.h"
#import "NSDate+Extention.h"

typedef NS_ENUM(NSInteger,OTISLoginState){
    OTISLoginStateVerified,//0.验证通过
    OTISLoginStateLocked,//1.帐号为锁定状态
    OTISLoginStateNotExistInDB,//2.帐号在数据库中不存在
    OTISLoginStatePasswordError,//3.密码输错,输错次数
    OTISLoginStatePasswordExpired,//4.密码已过期
    OTISLoginState90DaysNotLoggedIn,//5.90天未登录
    OTISLoginStateDeviceNumberNotExistInDB,//6.终端请求的设备号在数据库中不存在
    OTISLoginStateHasNewVersion,//7.有新的版本，旧版本暂时可兼容
    OTISLoginStatePasswordReset,//8.密码已重置
    OTISLoginStateDeviceLocked,//9.设备被锁
    OTISLoginStateDBConnectionFailed,//10.数据库连接未成功
    OTISLoginStateResetThePassword//11.使用初始密码登陆，必须重新设置密码
};


@implementation SZLoginHttpTool

+(void)loginWithRequest:(SZLoginRequest *)request success:(void (^)(NSString*))success failure:(void (^)(NSError *))failure
{
    [SZHttpTool loginPost:[SZNetwork stringByAppendingString:APILogin] parameters:request.mj_keyValues success:^(id obj) {
        
        SZLoginResponse * response = [SZLoginResponse mj_objectWithKeyValues:obj];
        int lockTime = 10 - [response.WrongTimes intValue];
        SZLog(@"SZLoginResponse ：%@",response.mj_keyValues);
        [[NSUserDefaults standardUserDefaults] setObject:response.UserInfo.BeltLevel forKey:OTIS_BeltLevel];
        
        NSError *err = nil;
        int intWrongTimes = 0;
        switch ([response.Result integerValue]) {
                
            case OTISLoginStateVerified:{
                SZLog(@"-----登录成功！！");
                NSString *strLoginKey = [NSString stringWithFormat:@"onlineLoginSuccess%@",request.UserNo];
                [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:strLoginKey];
                SZUserInfo *userInfo = response.UserInfo;
                userInfo.LastLoginDate=[[NSDate currentDate2] integerValue];
//                SZLog(@"-----------%@",userInfo.mj_keyValues);
                //有网络，通过http登录，将获取到的数据写入User数据库
                [SZTable_User storageTabUserWithRequest:request Params:userInfo];
                
                [OTISConfig saveAccountWithEmployeeID:[SZTable_User EmployeeIDWithUserNo:request.UserNo] andPassword:request.Password andUsername:request.UserNo];

                    /**
                     *  存储RouteNo到数据库
                     */
                
                    NSArray *arrayRoutes = userInfo.Routes;
                    for (NSDictionary *dic in arrayRoutes) {
                        NSString * RouteNo = dic[@"RouteNo"];
                        [SZTable_UserRoute storageUserRoute:[RouteNo integerValue]];
                    }
                    /**
                     *  存储SupervisorNo到数据库
                     */
                    NSArray *arraytUserSupervisors = userInfo.Supervisors;
                    
                    for (NSDictionary *dic in arraytUserSupervisors) {
                        
                        NSString * SupervisorNo = dic[@"SupervisorNo"];
                        
                        [SZTable_UserSupervisor storageUserSupervisorNo:[SupervisorNo integerValue]];
                    }

                /**
                 *  返回成功！
                 */
                success(@"1");
                break;
            }
                
           case OTISLoginStateLocked:
            
                err = [NSError errorWithUserInfo:SZLocal(@"error.OTISLoginStateLocked")];
                break;
            
                
            case OTISLoginStateNotExistInDB:
            
                err = [NSError errorWithUserInfo:SZLocal(@"error.OTISLoginStateNotExistInDB")];
                
                break;
            

            case OTISLoginStatePasswordError:
                intWrongTimes = [response.WrongTimes intValue];
                if (intWrongTimes < 10) {
                    err = [NSError errorWithUserInfo:[NSString stringWithFormat:NSLocalizedString(@"error.OTISLoginStatePasswordError", nil), response.WrongTimes,lockTime]];
                } else {
                    err = [NSError errorWithUserInfo:SZLocal(@"error.OTISLoginStateLocked")];
                }
            
                break;
            

            case OTISLoginStatePasswordExpired:{
                err = [NSError errorWithUserInfo:SZLocal(@"error.OTISLoginStatePasswordExpired")];
                SZUserInfo *userInfo = response.UserInfo;
                //有网络，通过http登录，将获取到的数据写入User数据库
                [SZTable_User storageTabUserWithRequest:request Params:userInfo];
                [OTISConfig saveAccountWithEmployeeID:[SZTable_User EmployeeIDWithUserNo:request.UserNo] andPassword:request.Password andUsername:request.UserNo];
            }
                break;
            

            case OTISLoginState90DaysNotLoggedIn:
            
                err = [NSError errorWithUserInfo:SZLocal(@"error.OTISLoginState90DaysNotLoggedIn")];
                
                break;
            

            case OTISLoginStateDeviceNumberNotExistInDB:
            
                err = [NSError errorWithUserInfo:SZLocal(@"error.OTISLoginStateDeviceNumberNotExistInDB")];
                
                break;
            

            case OTISLoginStateHasNewVersion:
            
                err = [NSError errorWithUserInfo:SZLocal(@"error.OTISLoginStateHasNewVersion")];
                
                break;
            

            case OTISLoginStatePasswordReset:
            
                err = [NSError errorWithUserInfo:SZLocal(@"error.OTISLoginStatePasswordReset")];
                
                break;
            

            case OTISLoginStateDeviceLocked:
            
                err = [NSError errorWithUserInfo:SZLocal(@"error.OTISLoginStateDeviceLocked")];
                
                break;

            case OTISLoginStateDBConnectionFailed:
            
                err = [NSError errorWithUserInfo:SZLocal(@"error.OTISLoginStateDBConnectionFailed")];
                
                break;

            case OTISLoginStateResetThePassword:{
                err = [NSError errorWithUserInfo:SZLocal(@"error.OTISLoginStateResetThePassword")];
                SZUserInfo *userInfo = response.UserInfo;
                userInfo.LastLoginDate=[[NSDate currentDate2] integerValue];
//                SZLog(@"-----------%@",userInfo.mj_keyValues);
                //有网络，通过http登录，将获取到的数据写入User数据库
                [SZTable_User storageTabUserWithRequest:request Params:userInfo];
                [OTISConfig saveAccountWithEmployeeID:[SZTable_User EmployeeIDWithUserNo:request.UserNo] andPassword:request.Password andUsername:request.UserNo];
            }
                break;
            default:
                break;
        }
        
        //如果有错误
        if (err) {
            failure(err);
        }
        
        
    } failure:^(NSError *error) {
        
//        SZLog(@"%@",error.userInfo[@"NSLocalizedDescription"]);
        NSString *strLoginKey = [NSString stringWithFormat:@"onlineLoginSuccess%@",request.UserNo];

        NSDate *date = [[NSUserDefaults standardUserDefaults] objectForKey:strLoginKey];
        if ([NSDate isSameDay:date]) {
            if (error.code == -1009) {//没有网络，本地登录
                
                [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:@"localLogin"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [SZTable_User loginWithRequest:request success:^{
                    [OTISConfig saveAccountWithEmployeeID:[SZTable_User EmployeeIDWithUserNo:request.UserNo] andPassword:request.Password andUsername:request.UserNo];
                    success(@"2");
                    
                } failure:^(NSError *error) {
                    failure(error);
                }];
            }

        }else{
            NSError *err = [NSError errorWithUserInfo:SZLocal(@"dialog.content.LoginMustWorkNet")];
            failure(err);

        
        }
        
    }];
}


+(void)logoutWithRequest:(SZLogoutRequest*)request success:(void(^)())success failure:(void(^)(NSError *error))failure
{

    [SZHttpTool post:APILogin parameters:request.mj_keyValues success:^(id obj) {
        
//        SZLog(@"%@",obj);
        
        success();
        // 0：成功；1：失败；
        
    } failure:^(NSError *error) {
        
//        SZLog(@"%@",error);
        
        if (error.code == -1009) {//没有网络，本地登录
            
            SZLog(@"%@",error);
        }
        
    }];


}


@end
