//
//  SZTable_WorkingHours.m
//  OTIS_PJ
//
//  Created by sunze on 16/4/29.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "SZTable_WorkingHours.h"
#import "TablesAndFields.h"

@implementation SZTable_WorkingHours
+(void)initialize{
    
    
    
    [OTISDB inDatabase:^(FMDatabase *db) {
        
        NSString *strCreateWorkingHours = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (%@ INTEGER PRIMARY KEY autoincrement, %@ TEXT NOT NULL,\
                                           %@ INTEGER ,\
                                           %@ TEXT NOT NULL,\
                                           %@ TEXT NOT NULL\
                                           %@ INTEGER,\
                                           %@ BOOL);",t_WorkingHours,
                                           GroupID,
                                           LaborTypeOrder,
                                           ScheduleID,
                                           ItemName,
                                           Description,
                                           Type,
                                           IsStandard];
        [db executeUpdate:strCreateWorkingHours];
    }];

    
}

/**
 *  存储到WorkingHoursDB
 *
 *  @param params
 */
+(void)storageWorkingHoursWithParams:(NSDictionary *)params{


}
/**
 *  根据请求参数去沙盒中加载缓存的WorkingHours数据
 *
 *  @param params 请求参数
 */
+(NSArray *)readWorkingHoursWithParams:(NSDictionary *)params{
    return nil;
}

@end
