//
//  SZYearCheckRequest.h
//  OTIS_PJ
//
//  Created by sunze on 16/5/24.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SZYearCheckRequest : NSObject

/**
 *  登录终端的工号（需要加密，与服务端一致的加密方法，一致的Salt）
 */
@property (nonatomic , copy) NSString *UserNo;

/**
 *  用户密码
 */
@property (nonatomic , copy) NSString *Password;

/**
 *  如果 -1, 则下载服务技师所属所有
 Supervisor下的截止本周日之前所有
 未签完字的计划（非本Route的已完成计划除外
 ）和所属Route下所有未完成换件的计划。
 */
@property (nonatomic , copy) NSString *TimeStamp;

/**
 *  接口版本号
 */
@property (nonatomic , copy) NSString *Ver;

/**
 *  初始化请求
 */
+(instancetype)yearCheckRequest;

@end
