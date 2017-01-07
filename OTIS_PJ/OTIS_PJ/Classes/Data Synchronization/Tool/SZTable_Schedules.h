//
//  SZTable_Schedules.h
//  OTIS_PJ
//
//  Created by sunze on 16/4/28.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SZReport;

@interface SZTable_Schedules : NSObject

/**
 *  存储到SchedulesDB
 *
 *  @param params
 */
+(void)storageSchedules:(NSArray *)schedules;


+(void)updateIsComplete:(int)isComplete andScheduleID:(int)scheduleID;

+(NSString *)quaryUnitNoWithScheduleID:(int)scheduleID;


+(void)updateAddLaborHoursState:(int)addLaborHoursState andScheduleID:(NSInteger)scheduleID;


+(int)quaryLaborHoursStateWithScheduleID:(int)scheduleID;


+(void)updateAddLaborHoursStateWithScheduleID:(int)scheduleID;

// 判断制定的scheduleID是否在我的路线下
+(BOOL) isMyRouteNoInTabScheduleWithScheduleID:(int)scheduleID;
@end
