//
//  SZLoginHttpTool.h
//  OTIS_PJ
//
//  Created by sunze on 16/4/22.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import <Foundation/Foundation.h>


@class SZLoginRequest,SZLogoutRequest;
@interface SZLoginHttpTool : NSObject

/**
 *  登录
 */
+(void)loginWithRequest:(SZLoginRequest*)request success:(void(^)(NSString*))success failure:(void(^)(NSError *error))failure;
/**
 *  注销
 */
+(void)logoutWithRequest:(SZLogoutRequest*)request success:(void(^)())success failure:(void(^)(NSError *error))failure;

@end
