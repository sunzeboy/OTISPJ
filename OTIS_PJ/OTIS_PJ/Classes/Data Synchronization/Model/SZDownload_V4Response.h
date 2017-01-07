//
//  SZDownload_V4Response.h
//  OTIS_PJ
//
//  Created by sunze on 16/4/27.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//



@interface SZDownload_V4Response : NSObject

/**
 * 返回结果
 */
@property (nonatomic , copy) NSString *Result;

/**
 * 时间戳
 */
@property (nonatomic , copy) NSString *TimeStamp;

/**
 * 计划版本
 */
@property (nonatomic , assign) NSInteger ScheduleVer;

/**
 * 计划数组
 */
@property (nonatomic, strong) NSArray *Schedules;

@end
