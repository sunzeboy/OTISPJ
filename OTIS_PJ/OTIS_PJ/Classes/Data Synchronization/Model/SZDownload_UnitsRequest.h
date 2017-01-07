//
//  SZDownload_UnitsRequest.h
//  OTIS_PJ
//
//  Created by sunze on 16/4/22.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SZDownload_UnitsRequest : NSObject

/**
 *  登录终端的工号（需要加密，与服务端一致的加密方法，一致的Salt）
 */
@property (nonatomic , copy) NSString *UserNo;

/**
 *  用户密码
 */
@property (nonatomic , copy) NSString *Password;

/**
 *  变更版本号，（-1表示完全重新下载，否则有变更则发送最新计划，没有变更则发送空的数组）
 */
@property (nonatomic , copy) NSString *UpdateVer;

/**
 *  接口版本号
 */
@property (nonatomic , copy) NSString *Ver;

/**
 *  初始化请求
 */
+(instancetype)unitsRequest;

@end
