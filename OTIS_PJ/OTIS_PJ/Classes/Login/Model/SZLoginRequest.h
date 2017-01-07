//
//  SZLoginRequest.h
//  OTIS_PJ
//
//  Created by sunze on 16/4/22.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SZLoginRequest : NSObject

/**
 *  登录终端的工号（需要加密，与服务端一致的加密方法，一致的Salt）
 */
@property (nonatomic , copy) NSString *UserNo;

/**
 *  用户密码
 */
@property (nonatomic , copy) NSString *Password;

/**
 *  终端设备号
 */
@property (nonatomic , copy) NSString *Number;

/**
 *  接口版本号
 */
@property (nonatomic , copy) NSString *Ver;

@property(nonatomic,copy)NSString* OsVersion;

@property(nonatomic,copy)NSString* AppVersion;


+(instancetype)requestWithUserNo:(NSString *)UserNo Password:(NSString *)Password Number:(NSString *)Number Ver:(NSString *)Ver;




@end
