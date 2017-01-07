//
//  SZChangePasswordRequest.h
//  OTIS_PJ
//
//  Created by zhangyang on 16/6/13.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SZChangePasswordRequest : NSObject

/**
 *  登录终端的工号（需要加密，与服务端一致的加密方法，一致的Salt）
 */
@property (nonatomic , copy) NSString *UserNo;

/**
 *  忘记密码登录终端的工号（需要加密，与服务端一致的加密方法，一致的Salt）
 */
@property (nonatomic , copy) NSString *EmployeeID;


/**
 *  用户新密码
 */
@property (nonatomic , copy) NSString *Password;

/**
 *  用户旧密码
 */
@property (nonatomic , copy) NSString *OldPassword;


/**
 *  接口版本号
 */
@property (nonatomic , copy) NSString *Ver;


-(instancetype)requestWithUserNo:(NSString *)UserNo NewPassword:(NSString *)NewPassword Ver:(NSString *)Ver;

@end
