//
//  SZTable_Interrupt.m
//  OTIS_PJ
//
//  Created by sunze on 16/4/29.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "SZTable_Interrupt.h"
#import "TablesAndFields.h"

@implementation SZTable_Interrupt

+(void)initialize{
    
    
    
    [OTISDB inDatabase:^(FMDatabase *db) {
//        NSString *strCreateInterrupt= [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (%@ INTEGER PRIMARY KEY autoincrement, %@ TEXT NOT NULL,\
//                                       %@ INTEGER ,\
//                                       %@ TEXT NOT NULL,\
//                                       %@ TEXT NOT NULL\
//                                       %@ INTEGER,\
//                                       %@ BOOL);",t_WorkingHours,
//                                       GroupID,
//                                       LaborTypeOrder,
//                                       ScheduleID,
//                                       ItemName,
//                                       Description,
//                                       Type,
//                                       IsStandard];
//        [db executeUpdate:strCreateInterrupt];
    }];

    
}


/**
 *  存储到InterruptDB
 *
 *  @param params
 */
+(void)storageInterruptWithParams:(NSDictionary *)params{


}
/**
 *  根据请求参数去沙盒中加载缓存的Interrupt数据
 *
 *  @param params 请求参数
 */
+(NSArray *)readInterruptWithParams:(NSDictionary *)params{

    return nil;
}

@end
