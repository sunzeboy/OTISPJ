//
//  SZTable_REPORT_ITEM_COMPLETE_STATE.h
//  OTIS_PJ
//
//  Created by sunze on 16/5/19.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SZreportItem : NSObject

@property (nonatomic , copy) NSString *EmployeeID;
@property (nonatomic , assign) int  ScheduleId;
@property (nonatomic , copy) NSString *ItemCode;
@property (nonatomic , assign) int State;

@end

@interface SZTable_REPORT_ITEM_COMPLETE_STATE : NSObject

+(void)deletWithScheduleId:(int)scheduleId ANDEmployeeId:(NSString *)employeeId;

/**
 *  存储到t_REPORT_ITEM_COMPLETE_STATE_Download
 *
 *  @param params
 */
+(void)storageSZReportOperations:(NSArray *)operations withEmployeeID:(NSString *)employeeID andScheduleID:(int)scheduleID;
+(void)updateUploadedWithScheduleId:(NSString *)scheduleId;
/**
 *  存储到t_REPORT_ITEM_COMPLETE_STATE
 *
 *  @param params
 */
+(void)storageReportOperations:(NSArray *)operations;

/**
 *  查询其他人已经做的保养项目 EMPLOYEE_ID!='%s' 注意是!=
 *
 *  @param params 请求参数
 */
+(NSDictionary *)queryItemCodeOtherWithScheduleId:(int)scheduleId;

@end
