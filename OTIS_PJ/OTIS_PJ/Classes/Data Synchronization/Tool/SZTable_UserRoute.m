//
//  SZTable_UserRoute.m
//  OTIS_PJ
//
//  Created by sunze on 16/4/29.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "SZTable_UserRoute.h"
#import "TablesAndFields.h"

@implementation SZTable_UserRoute


/**
 *  存储到UserRouteDB
 *
 *  @param params
 */
+(void)storageUserRoute:(NSInteger)RouteNo{
//    SZLog(@"storageUserRoute--------------%@",[NSThread currentThread]);

    [OTISDB inDatabase:^(FMDatabase *db) {
        [db executeUpdateWithFormat:@"delete from t_UserRoute WHERE EmployeeID = %@ AND RouteNo = %ld;",[OTISConfig EmployeeID],(long)RouteNo];
        
        BOOL ret = [db executeUpdateWithFormat:@"INSERT INTO t_UserRoute (EmployeeID, RouteNo) VALUES (\
                    %@,\
                    %ld);",
                    [OTISConfig EmployeeID],
                    (long)RouteNo];
        if (ret) {
            SZLog(@"！！！");
        }else{
            SZLog(@"UserRoute表插入数据失败！！！");
        }
    }];
}
/**
 *  根据请求参数去沙盒中加载缓存的UserRoute数据
 *
 *  @param params 请求参数
 */
+(NSArray *)readWorkingHoursWithParams:(NSDictionary *)params{
    return nil;
}

/**
 *  查找当前EmployeeID关联的所有RoutNo
 *
 *  @param params 请求参数
 */
+(NSArray *)routNos{
    
    NSMutableArray *array = [NSMutableArray array];

    
    [OTISDB inDatabase:^(FMDatabase *db) {
        
        FMResultSet *set1 = [db executeQueryWithFormat:@"SELECT RouteNo FROM t_UserRoute WHERE EmployeeID = %@;",[OTISConfig EmployeeID]];
        while ([set1 next]) {
            
            [array addObject:@([set1 longForColumn:@"RouteNo"])];
        }
    }];
//    SZLog(@"routNos--------------%@ %ld",[NSThread currentThread],array.count);

    return [NSArray arrayWithArray:array];
}

+(NSString *)routNosForDb{
 
    NSMutableArray *routs = [NSMutableArray arrayWithArray:[self routNos]] ;
    
    NSString *strRouts = [routs componentsJoinedByString:@","];
    
    return strRouts;
}



@end
