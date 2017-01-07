//
//  SZTable_Route.m
//  OTIS_PJ
//
//  Created by sunze on 16/5/10.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "SZTable_Route.h"
#import "TablesAndFields.h"
#import "SZTable_UserRoute.h"


@implementation SZTable_Route



/**
 *  存储电梯版本号到Supervisor
 *
 *  @param dic 参数
 */
+(void)updateTabRouteWithScheduleVer:(NSInteger)scheduleVer timeStamp:(NSInteger)timeStamp
{
    
    NSArray * routNos = [SZTable_UserRoute routNos];
    
    
    [OTISDB inDatabase:^(FMDatabase *db) {
        for (NSNumber* routNo in routNos) {
           
            
            NSInteger RouteNoCount = 0;

            FMResultSet *set = [db executeQueryWithFormat:@"SELECT count(RouteNo) as RouteNoCount from t_Route WHERE EmployeeID = %@;",[OTISConfig EmployeeID]];
            while ([set next]) {
                RouteNoCount = [set intForColumn:@"RouteNoCount"];
            }
            if (RouteNoCount) {
                BOOL ret =[db executeUpdateWithFormat:@"UPDATE t_Route SET  RouteNo = %ld,ScheduleVer = %ld,LastDownloadScheduleDate = %ld WHERE EmployeeID = %@ ;",
                           (long)routNo.integerValue,(long)scheduleVer,(long)timeStamp,[OTISConfig EmployeeID]];
                if (ret) {

                }else{
                    SZLog(@"t_Route表UPDATE失败！1");
                }

            }else{
            
                BOOL ret =[db executeUpdateWithFormat:@"INSERT INTO t_Route (RouteNo, ScheduleVer, LastDownloadScheduleDate,EmployeeID) VALUES (%ld, %ld, %ld,%@);",
                           (long)routNo.integerValue,(long)scheduleVer,(long)timeStamp,[OTISConfig EmployeeID]];
                if (ret) {

                }else{
                    SZLog(@"t_Route表INSERT失败！2");
                }

            
            }
            
            
        }

        
    }];

   
}


/**
 *  获取计划版本号
 */
+(NSString *)scheduleVer{
    
    
   
    
    __block NSString *ScheduleVer = @"0";

    [OTISDB inDatabase:^(FMDatabase *db) {
        
        FMResultSet *set = [db executeQueryWithFormat:@"SELECT ScheduleVer FROM t_Route WHERE EmployeeID = %@;",[OTISConfig EmployeeID]];
        while ([set next]) {
            ScheduleVer = [NSString stringWithFormat:@"%ld",[set longForColumn:@"ScheduleVer"]];
            
        }

        
    }];
    
    return ScheduleVer;
}
/**
 *  获取计划时间戳
 */
+(NSString *)timeStamp{
    
    
//   __block NSNumber * routNo = [[SZTable_UserRoute routNos] lastObject];
    
    __block NSString *LastDownloadScheduleDate = @"-1";
    
    [OTISDB inDatabase:^(FMDatabase *db) {
        
        FMResultSet *set = [db executeQueryWithFormat:@"SELECT LastDownloadScheduleDate FROM t_Route WHERE EmployeeID = %@;",[OTISConfig EmployeeID]];
        while ([set next]) {
            LastDownloadScheduleDate = [NSString stringWithFormat:@"%ld",[set longForColumn:@"LastDownloadScheduleDate"]];
            
        }
        
        
    }];
    
    return LastDownloadScheduleDate;
}



/**
 *  存储同事保养报告时间戳到t_Route
 *
 *  @param dic 参数
 */
+(void)updateTabRouteWithReportDate:(NSInteger)reportDate fixDate:(NSInteger)fixDate
{
    
    NSArray * routNos = [SZTable_UserRoute routNos];
    
    
    [OTISDB inDatabase:^(FMDatabase *db) {
        for (NSNumber* routNo in routNos) {

            
            
            NSInteger RouteNoCount = 0;
            
            FMResultSet *set = [db executeQueryWithFormat:@"SELECT count(RouteNo) as RouteNoCount from t_Route WHERE EmployeeID = %@;",[OTISConfig EmployeeID]];
            while ([set next]) {
                RouteNoCount = [set intForColumn:@"RouteNoCount"];
            }
            if (RouteNoCount) {
                BOOL ret =[db executeUpdateWithFormat:@"UPDATE t_Route SET LastDownloadReportDate = %ld,LastDownloadFixDate = %ld WHERE EmployeeID = %@ ;",
                           (long)reportDate,(long)fixDate,[OTISConfig EmployeeID]];
                if (ret) {

                }else{
                    SZLog(@"t_Route表UPDATE失败！3");
                }
                
            }else{
                
                BOOL ret =[db executeUpdateWithFormat:@"INSERT INTO t_Route (RouteNo, LastDownloadReportDate, LastDownloadFixDate,EmployeeID) VALUES (%ld, %ld, %ld,%@);",
                           (long)routNo.integerValue,(long)reportDate,(long)fixDate,[OTISConfig EmployeeID]];
                if (ret) {

                }else{
                    SZLog(@"t_Route表INSERT失败！4");
                }

            
        }
        
        }
    }];
    
    
}

/**
 *  获取同事保养报告时间戳
 */
+(NSString *)reportDate{
    
    
    __block NSString *LastDownloadReportDate = @"0";
    
    [OTISDB inDatabase:^(FMDatabase *db) {
        
        FMResultSet *set = [db executeQueryWithFormat:@"SELECT * FROM t_Route WHERE EmployeeID = %@;",[OTISConfig EmployeeID]];
        while ([set next]) {
            LastDownloadReportDate = [NSString stringWithFormat:@"%ld",[set longForColumn:@"LastDownloadReportDate"]];
            
        }
        
        
    }];
    
    return LastDownloadReportDate;
}
/**
 *  获取同事保养报告fixDate
 */
+(NSString *)fixDate{
    
    
//    __block NSNumber * routNo = [[SZTable_UserRoute routNos] lastObject];
    
    __block NSString *LastDownloadFixDate = @"0";
    
    [OTISDB inDatabase:^(FMDatabase *db) {
        
        FMResultSet *set = [db executeQueryWithFormat:@"SELECT LastDownloadFixDate FROM t_Route WHERE EmployeeID = %@;",[OTISConfig EmployeeID]];
        while ([set next]) {
            LastDownloadFixDate = [NSString stringWithFormat:@"%ld",[set longForColumn:@"LastDownloadFixDate"]];
            
        }
        
        
    }];
    
    return LastDownloadFixDate;
}



/**
 *  存储年检版本号到t_Route
 *
 *  @param dic 参数
 */
+(void)updateTabRouteWithYCheckDate:(NSInteger)yCheckDate
{
    
    NSArray * routNos = [SZTable_UserRoute routNos];
    
    
    [OTISDB inDatabase:^(FMDatabase *db) {
        for (NSNumber* routNo in routNos) {
            
            NSInteger RouteNoCount = 0;
            
            FMResultSet *set = [db executeQueryWithFormat:@"SELECT count() as RouteNoCount from t_Route WHERE EmployeeID = %@;",[OTISConfig EmployeeID]];
            while ([set next]) {
                RouteNoCount = [set intForColumn:@"RouteNoCount"];
            }
            if (RouteNoCount) {
                BOOL ret =[db executeUpdateWithFormat:@"UPDATE t_Route SET  RouteNo = %ld,LastDownloadYCheckDate = %ld WHERE EmployeeID = %@ ;",
                           (long)routNo.integerValue,(long)yCheckDate,[OTISConfig EmployeeID]];
                if (ret) {

                }else{
                    SZLog(@"t_Route表UPDATE失败！5");
                }
                
            }else{
                
                BOOL ret =[db executeUpdateWithFormat:@"INSERT INTO t_Route (RouteNo, LastDownloadYCheckDate,EmployeeID) VALUES (%ld, %ld,%@);",
                           (long)routNo.integerValue,(long)yCheckDate,[OTISConfig EmployeeID]];
                if (ret) {

                }else{
                    SZLog(@"t_Route表INSERT失败！6");
                }
                
                
            }

            
            
        }
        
        
    }];
    
    
}
/**
 *  获取年检版本号
 */
+(NSString *)yCheckDate{
    
    
//    __block NSNumber * routNo = [[SZTable_UserRoute routNos] lastObject];
    
    __block NSString *LastDownloadYCheckDate = @"0";
    
    [OTISDB inDatabase:^(FMDatabase *db) {
        
        FMResultSet *set = [db executeQueryWithFormat:@"SELECT * FROM t_Route WHERE EmployeeID = %@;",[OTISConfig EmployeeID]];
        while ([set next]) {
            LastDownloadYCheckDate = [NSString stringWithFormat:@"%ld",[set longForColumn:@"LastDownloadYCheckDate"]];
            
        }
        
        
    }];
    
    return LastDownloadYCheckDate;
}

@end
