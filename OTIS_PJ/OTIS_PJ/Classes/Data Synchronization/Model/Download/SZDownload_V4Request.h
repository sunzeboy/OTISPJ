//
//  SZDownload_V4Request.h
//  OTIS_PJ
//
//  Created by sunze on 16/4/22.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SZDownload_V4Request : NSObject

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
 *  版本号
 */
@property (nonatomic , copy) NSString *Ver;

/**
 *   计划的版本，0表示第一次下载
 */
@property (nonatomic , copy) NSString *ScheduleVer;


/**
 *  初始化请求
 */
+(instancetype)v4Request;

@end
