//
//  SZChangePasswordTool.h
//  OTIS_PJ
//
//  Created by zhangyang on 16/6/13.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SZChangePasswordRequest.h"

@interface SZChangePasswordTool : NSObject

/**
 *  修改新密码
 */
+(void)changePasswordWithRequest:(SZChangePasswordRequest*)request success:(void(^)())success failure:(void(^)(NSError *error))failure;

@end
