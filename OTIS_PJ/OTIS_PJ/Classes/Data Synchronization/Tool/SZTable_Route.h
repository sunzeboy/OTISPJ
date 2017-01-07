//
//  SZTable_Route.h
//  OTIS_PJ
//
//  Created by sunze on 16/5/10.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SZTable_Route : NSObject

//+(void)storaget_Route;
//------------------------------------------------------------------------------------------------------------------------------------------------
/**
 *  存储电梯版本号到Supervisor
 *
 *  @param dic 参数
 */
+(void)updateTabRouteWithScheduleVer:(NSInteger)scheduleVer timeStamp:(NSInteger)timeStamp;
/**
 *  获取计划版本号
 */
+(NSString *)scheduleVer;
/**
 *  获取计划时间戳
 */
+(NSString *)timeStamp;

//------------------------------------------------------------------------------------------------------------------------------------------------
/**
 *  存储同事保养报告时间戳到t_Route
 *
 *  @param dic 参数
 */
+(void)updateTabRouteWithReportDate:(NSInteger)reportDate fixDate:(NSInteger)fixDate;
/**
 *  获取同事保养报告fixDate
 */
+(NSString *)fixDate;

/**
 *  获取同事保养报告时间戳
 */
+(NSString *)reportDate;
//------------------------------------------------------------------------------------------------------------------------------------------------

/**
 *  存储年检版本号到t_Route
 *
 *  @param dic 参数
 */
+(void)updateTabRouteWithYCheckDate:(NSInteger)yCheckDate;
/**
 *  获取年检版本号
 */
+(NSString *)yCheckDate;




@end
