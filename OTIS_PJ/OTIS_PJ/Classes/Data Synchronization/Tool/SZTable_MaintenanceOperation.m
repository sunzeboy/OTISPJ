//
//  SZTable_MaintenanceOperation.m
//  OTIS_PJ
//
//  Created by sunze on 16/4/29.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "SZTable_MaintenanceOperation.h"
#import "TablesAndFields.h"

@implementation SZTable_MaintenanceOperation

+(void)initialize{
    
   
    
    [OTISDB inDatabase:^(FMDatabase *db) {
//        NSString *strCreateSignature= [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (%@ INTEGER PRIMARY KEY autoincrement, %@ TEXT NOT NULL,\
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
//        [db executeUpdate:strCreateSignature];
    }];

    
}


/**
 *  存储到MaintenanceOperationDB
 *
 *  @param params
 */
+(void)storageMaintenanceOperationWithParams:(NSDictionary *)params{


}
/**
 *  根据请求参数去沙盒中加载缓存的MaintenanceOperation数据
 *
 *  @param params 请求参数
 */
+(NSArray *)readMaintenanceOperationWithParams:(NSDictionary *)params{
    return nil;

}

@end
