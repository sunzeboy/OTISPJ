//
//  SZTable_Log.m
//  OTIS_PJ
//
//  Created by sunze on 16/4/29.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "SZTable_Log.h"
#import "TablesAndFields.h"

@implementation SZTable_Log
+(void)initialize{
    
    
    [OTISDB inDatabase:^(FMDatabase *db) {
//        NSString *strCreateLog = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (%@ INTEGER PRIMARY KEY autoincrement, %@ TEXT NOT NULL,\
//                                  %@ INTEGER ,\
//                                  %@ TEXT NOT NULL,\
//                                  %@ TEXT NOT NULL\
//                                  %@ INTEGER,\
//                                  %@ BOOL);",t_WorkingHours,
//                                  GroupID,
//                                  LaborTypeOrder,
//                                  ScheduleID,
//                                  ItemName,
//                                  Description,
//                                  Type,
//                                  IsStandard];
//        [db executeUpdate:strCreateLog];
    }];
}

/**
 *  存储到LogDB
 *
 *  @param params
 */
+(void)storageLogWithParams:(NSDictionary *)params{

}
/**
 *  根据请求参数去沙盒中加载缓存的Log数据
 *
 *  @param params 请求参数
 */
+(NSArray *)readLogWithParams:(NSDictionary *)params{

    return nil;
}
@end
