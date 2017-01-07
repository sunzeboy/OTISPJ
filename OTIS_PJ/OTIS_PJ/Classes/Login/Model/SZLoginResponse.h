//
//  SZLoginResponse.h
//  OTIS_PJ
//
//  Created by sunze on 16/4/22.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SZUserInfo;
@interface SZLoginResponse : NSObject

/**
 *  请求登录返回结果：
 0.验证通过
 1.帐号为锁定状态
 2.帐号在数据库中不存在
 3.密码输错
 4.密码已过期
 5.90天未登录
 6.终端请求的设备号在数据库中不存在
 7.有新的版本
 8.密码已重置
 9.设备被锁
 10.数据库连接未成功
 11.使用初始密码登陆，必须重新设置密码
 */
@property (nonatomic , copy) NSString *Result;

/**
 *  AppURL
 */
@property (nonatomic , copy) NSString *AppURL;
/**
 *  输错次数
 */
@property (nonatomic , copy) NSString *WrongTimes;

/**
 *  App版本号
 */
@property (nonatomic , copy) NSString *AppVer;

/**
 *  UserInfo
 */
@property (nonatomic , strong) SZUserInfo *UserInfo;



@end
