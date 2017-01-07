//
//  SZTable_CompletedYaerMaintenanceSchedule.m
//  OTIS_PJ
//
//  Created by sunze on 16/4/29.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "SZTable_CompletedYaerMaintenanceSchedule.h"
#import "TablesAndFields.h"

@implementation SZTable_CompletedYaerMaintenanceSchedule

+(void)initialize{
    
    
    [OTISDB inDatabase:^(FMDatabase *db) {
//        NSString *strCreateCompletedYaerMaintenanceSchedule = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (%@ INTEGER PRIMARY KEY autoincrement, %@ TEXT NOT NULL,\
//                                                               %@ INTEGER ,\
//                                                               %@ TEXT NOT NULL,\
//                                                               %@ TEXT NOT NULL\
//                                                               %@ INTEGER,\
//                                                               %@ BOOL);",t_WorkingHours,
//                                                               GroupID,
//                                                               LaborTypeOrder,
//                                                               ScheduleID,
//                                                               ItemName,
//                                                               Description,
//                                                               Type,
//                                                               IsStandard];
//        [db executeUpdate:strCreateCompletedYaerMaintenanceSchedule];
    }];
}

/**
 *  存储到CompletedYaerMaintenanceScheduleDB
 *
 *  @param params
 */
+(void)storageCompletedYaerMaintenanceScheduleWithParams:(NSDictionary *)params{


}
/**
 *  根据请求参数去沙盒中加载缓存的CompletedYaerMaintenanceSchedule数据
 *
 *  @param params 请求参数
 */
+(NSArray *)readCompletedYaerMaintenanceScheduleWithParams:(NSDictionary *)params{
    return nil;
}

@end
