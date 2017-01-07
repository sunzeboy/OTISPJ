//
//  SZUser.h
//  OTIS_PJ
//
//  Created by sunze on 16/4/28.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SZLoginRequest.h"
#import "SZUserInfo.h"
@interface SZTable_User : NSObject

/**
 *  存储到用户DB
 *
 *  @param dic 参数
 */
+(void)storageTabUserWithRequest:(SZLoginRequest *)request Params:(SZUserInfo *)dic ;

/**
 *  本地登录
 *
 *  @param request 登陆请求
 *  @param success 成功
 *  @param failure 失败
 */
+(void)loginWithRequest:(SZLoginRequest *)request success:(void(^)())success failure:(void(^)(NSError *error))failure;

/**
 *  根据参数更新User数据库
 *
 *  @param dic 参数
 */
+(void)updateTabUserWithParams:(NSDictionary *)dic ;


/**
 *  根据UserNo获取EmployeeID
 *
 *  @param UserNo 用户名
 */
+(NSString *)EmployeeIDWithUserNo:(NSString *)UserNo;

- (NSInteger)computeDaysWithDataFromString:(NSString *)string;
@end
