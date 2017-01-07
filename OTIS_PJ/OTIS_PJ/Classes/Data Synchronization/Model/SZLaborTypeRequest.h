//
//  SZLaborTypeRequest.h
//  OTIS_PJ
//
//  Created by sunze on 16/6/15.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SZLaborTypeRequest : NSObject

/**
 *  登录终端的工号（需要加密，与服务端一致的加密方法，一致的Salt）
 */
@property (nonatomic , copy) NSString *UserNo;

/**
 *  用户密码
 */
@property (nonatomic , copy) NSString *Password;

/**
 * 上次获取记录的数据版本号,默认数据版本是0
 */
@property (nonatomic , copy) NSString * LaborItemVer;

/**
 *  接口版本号
 */
@property (nonatomic , copy) NSString *Ver;

/**
 *  初始化请求
 */
+(instancetype)laborTypeRequest;

@end
