//
//  SZTable_MaintenanceItems.m
//  OTIS_PJ
//
//  Created by sunze on 16/4/29.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "SZTable_MaintenanceItems.h"
#import "TablesAndFields.h"

@implementation SZTable_MaintenanceItems

+(void)initialize{
    
    
    
    
    [OTISDB inDatabase:^(FMDatabase *db) {
        
        NSString *strCreateMaintenanceItems = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (%@ INTEGER PRIMARY KEY autoincrement, %@ TEXT NOT NULL,\
                                               %@ INTEGER ,\
                                               %@ TEXT NOT NULL,\
                                               %@ TEXT NOT NULL\
                                               %@ INTEGER,\
                                               %@ BOOL);",t_MaintenanceItems,
                                               ItemID,
                                               ItemCode,
                                               CardType,
                                               ItemName,
                                               Description,
                                               Type,
                                               IsStandard];
        [db executeUpdate:strCreateMaintenanceItems];
    }];

    
}


/**
 *  存储到MaintenanceItemsDB
 *
 *  @param params
 */
+(void)storageMaintenanceItemsWithParams:(NSDictionary *)params{


}
/**
 *  根据请求参数去沙盒中加载缓存的MaintenanceItems数据
 *
 *  @param params 请求参数
 */
+(NSArray *)readMaintenanceItemsWithParams:(NSDictionary *)params{
    return nil;
}

@end
