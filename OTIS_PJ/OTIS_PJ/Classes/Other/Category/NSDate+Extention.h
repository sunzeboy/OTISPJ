//
//  NSDate+Extention.h
//  OTIS_PJ
//
//  Created by sunze on 16/5/10.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Extention)

+(NSDate *)localeDate;

+(long)sinceDistantPastToDateTime:(NSDate *)date;

/**
 *  从公元0000年第一天到今天的纳秒数(精确到时分秒)
 */

+(long)sinceDistantPastTime;
/**
 *  从公元0000年第一天到今天的纳秒数
 */
+(long)sinceDistantPast;

/**
 *  从公元0000年第一天到某一天的纳秒数
 */
+(NSInteger)sinceDistantPastToDate:(NSDate *)date;

/**
 *  返回本周的周一或周日
 *
 *  @param dayOfTheWeek 需要返回的周几（条件）
 */
+(NSDate *)thisWeekMondayOrNextSunday:(NSString *)dayOfTheWeek;


+(NSInteger)getDaysFrom:(NSDate *)serverDate To:(NSDate *)endDate;

/**
 *  当前时间
 */
+(NSString *)currentTime;
+(NSString *)currentTimeNOMaohao;
/**
 *  当前日期
 */
+(NSString *)currentDate;

+(NSString *)currentDate2;
/**
 *  返回本周的周一或周日
 *
 *  @param dayOfTheWeek 需要返回的周几（条件）
 */
+(NSString *)thisWeekMondayOrNextWeekSunday:(NSString *)dayOfTheWeek;

+(NSInteger)currentYear;
+(NSInteger)currentMdInt;


+ (NSDate *)dateFromString:(NSString *)dateString;

+(BOOL)compareDate:(NSString *)dateString;

+(BOOL)isDateThisWeek:(NSDate *)date ;

+ (NSDate *)dateTimeFromString:(NSString *)dateString;

+(BOOL)isSameDay:(NSDate *)date ;


+(NSInteger)mondayWithDate:(NSString *)dateString;

@end
