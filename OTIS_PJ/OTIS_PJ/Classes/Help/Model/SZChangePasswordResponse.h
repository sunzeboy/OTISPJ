//
//  SZChangePasswordResponse.h
//  OTIS_PJ
//
//  Created by zhangyang on 16/6/13.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SZChangePasswordResponse : NSObject

/**
 *  请求登录返回结果：
 0.修改成功
 1.修改失败
 2.距上次修改密码未满24小时
 3.密码不符合密码安全策略
 4.密码与前5次设置的密码有重复
 */
@property (nonatomic , copy) NSString *Result;

@end


@interface SZForgetPasswordResponse : NSObject

@property (nonatomic , copy) NSString *Result;
@property (nonatomic , copy) NSString *EmployeeID;

@property (nonatomic , copy) NSString *Desc;

@end



@interface SZForgetPasswordRequest : NSObject

//　登录终端的账号
@property(nonatomic,copy)NSString* UserNo;
//　登录终端的工号
@property(nonatomic,copy)NSString* DeviceID;
//　验证码，如：1234
@property(nonatomic,copy)NSString* OsVersion;
//　设备号
@property(nonatomic,copy)NSString* AppVersion;
//　操作系统版本号
@property(nonatomic,copy)NSString* Ver;

//　应用APP版本号
@property(nonatomic,copy)NSString* EmployeeID;
//　数据接口版本号
@property(nonatomic,copy)NSString* ValidationCode;




@end