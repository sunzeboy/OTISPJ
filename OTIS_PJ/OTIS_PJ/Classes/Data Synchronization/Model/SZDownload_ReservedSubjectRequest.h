//
//  SZDownload_ReservedSubjectRequest.h
//  OTIS_PJ
//
//  Created by sunze on 16/5/9.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SZDownload_ReservedSubjectRequest : NSObject

/**
 *  登录终端的工号（需要加密，与服务端一致的加密方法，一致的Salt）
 */
@property (nonatomic , copy) NSString *UserNo;

/**
 *  用户密码
 */
@property (nonatomic , copy) NSString *Password;

/**
 *  版本号
 */
@property (nonatomic , copy) NSString *Ver;

/**
 *  初始化请求
 */
+(instancetype)reservedSubjectRequest;

@end
