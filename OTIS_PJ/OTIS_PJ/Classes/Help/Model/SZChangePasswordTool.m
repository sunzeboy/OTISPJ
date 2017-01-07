//
//  SZChangePasswordTool.m
//  OTIS_PJ
//
//  Created by zhangyang on 16/6/13.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "SZChangePasswordTool.h"
#import "SZChangePasswordRequest.h"
#import "SZChangePasswordResponse.h"
#import "SZHttpTool.h"

typedef NS_ENUM(NSInteger,OTISChangePasswordState){
    OTISChangePasswordSuccess,     // 0.验证通过
    OTISChangePasswordFailure,     // 1.修改失败
    OTISChangePasswordLessThan24h, // 2.距上次修改密码未满24小时
    OTISChangePasswordNotSafe,     // 3.密码不符合密码安全策略
    OTISChangePasswordRepeated,     // 4.密码与前5次设置的密码有重复
    OTISChangePasswordAccountLock     // 5.账号被锁定
};

@implementation SZChangePasswordTool

+(void)changePasswordWithRequest:(SZChangePasswordRequest *)request success:(void (^)())success failure:(void (^)(NSError *))failure
{
    
    NSString* url;
    
    if (request.OldPassword==nil) {
        url=[SZNetwork stringByAppendingString:APIForgetPassWord];
    }else{
        url=[SZNetwork stringByAppendingString:APIChangeNewPassword];
    }
//    SZLog(@"----%@",url);
    [SZHttpTool post:url parameters:request.mj_keyValues success:^(id obj) {
        
        SZLog(@"%@/n---%@",obj,request.mj_keyValues);
        SZChangePasswordResponse * response = [SZChangePasswordResponse mj_objectWithKeyValues:obj];
        SZLog(@"%@",response.mj_keyValues);
        NSError *err = nil;
        
        switch ([response.Result integerValue]) {
            case OTISChangePasswordSuccess:{
                success();
                break;
            }
            case OTISChangePasswordFailure:     // 1.修改失败
                
                err = [NSError errorWithUserInfo:SZLocal(@"dialog.content.passwordFailure")];
                
                break;
            case  OTISChangePasswordLessThan24h: // 2.距上次修改密码未满24小时
                
                err = [NSError errorWithUserInfo:SZLocal(@"dialog.content.rechangePasswordNeed24Hours")];
                
                break;
            case   OTISChangePasswordNotSafe:    // 3.密码不符合密码安全策略
                
                err = [NSError errorWithUserInfo:SZLocal(@"dialog.content.passwordNotSecurity")];
                
                break;
            case   OTISChangePasswordRepeated:     // 4.密码与前5次设置的密码有重复
                
                err = [NSError errorWithUserInfo:SZLocal(@"dialog.content.passwordRepeated")];
                
                break;
            case   OTISChangePasswordAccountLock:     //  5.账号被锁定
                
                err = [NSError errorWithUserInfo:SZLocal(@"error.OTISLoginStateLocked")];
                
                break;
            default:
                break;
        }
        //如果有错误
        if (err) {
            failure(err);
        }
        
    } failure:^(NSError *error) {
        NSError *err = [NSError errorWithUserInfo:SZLocal(@"dialog.content.Upload failed, please check the network link")];
//        SZLog(@"%@",error.userInfo[@"NSLocalizedDescription"]);
        failure(err);
        //没有网络
        if (error.code == -1009) {
                    
        }
    }];
    
}
@end
