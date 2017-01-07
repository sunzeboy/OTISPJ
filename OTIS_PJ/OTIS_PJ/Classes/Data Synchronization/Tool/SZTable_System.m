//
//  SZTable_System.m
//  OTIS_PJ
//
//  Created by sunze on 16/5/13.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "SZTable_System.h"
#import "TablesAndFields.h"

@implementation SZTable_System

+(void)initialize
{
    
    [OTISDB inDatabase:^(FMDatabase *db) {
                
    }];
    
}


/**
 *  存保养项版本号到t_System
 *
 *  @param dic 参数
 */
+(void)updateTabSystemWithUpdateVer:(NSString *)updateVer
{
    
    
    
    [OTISDB inDatabase:^(FMDatabase *db) {
        
        NSInteger HostCount = 0;
        
        FMResultSet *set = [db executeQueryWithFormat:@"SELECT count(Host) as HostCount from t_System WHERE EmployeeId = %@;",[OTISConfig EmployeeID]];
        while ([set next]) {
            HostCount = [set intForColumn:@"HostCount"];
        }
        if (HostCount) {
            BOOL ret =[db executeUpdateWithFormat:@"UPDATE t_System SET  Host = %@,ItemScheduleVer = %d WHERE EmployeeId = %@ ;",
                       SZNetwork,updateVer.intValue,[OTISConfig EmployeeID]];
            if (ret) {
                SZLog(@"t_System表UPDATE成功！！！");
            }else{
                SZLog(@"t_Systemte表UPDATE失败！！！");
            }
            
        }else{
            
            BOOL ret =[db executeUpdateWithFormat:@"INSERT INTO t_System (Host,ItemScheduleVer,EmployeeId) VALUES (%@,%d,%@);",
                       SZNetwork,updateVer.intValue,[OTISConfig EmployeeID]];
            if (ret) {
                SZLog(@"t_System表INSERT成功！！！");
            }else{
                SZLog(@"t_System表INSERT失败！！！");
            }
            
            
        }
        

        
    }];
    
}
/**
 *  获取保养项版本号
 */
+(NSString *)updateVer{
    
    __block NSString *updateVer = @"0";
    
    [OTISDB inDatabase:^(FMDatabase *db) {
        
        FMResultSet *set = [db executeQueryWithFormat:@"SELECT ItemScheduleVer FROM t_System WHERE EmployeeId = %@;",[OTISConfig EmployeeID]];
        while ([set next]) {
            updateVer = [set stringForColumn:@"ItemScheduleVer"];
            
        }
        
        
    }];
    if (updateVer == nil) {
        updateVer = @"0";
    }
    return updateVer;
}


/**
 *  安全项版本号到t_System
 *
 *  @param dic 参数
 */
+(void)updateTabSystemWithSafeItemVer:(int )safeItemVer
{
    
    
    
    [OTISDB inDatabase:^(FMDatabase *db) {
        
        NSInteger HostCount = 0;
        
        FMResultSet *set = [db executeQueryWithFormat:@"SELECT count(Host) as HostCount from t_System WHERE EmployeeId = %@;",[OTISConfig EmployeeID]];
        while ([set next]) {
            HostCount = [set intForColumn:@"HostCount"];
        }
        if (HostCount) {
            BOOL ret =[db executeUpdateWithFormat:@"UPDATE t_System SET  Host = %@,SafetyItemVer = %d WHERE EmployeeId = %@ ;",
                       SZNetwork,safeItemVer,[OTISConfig EmployeeID]];
            if (ret) {

            }else{
                SZLog(@"t_Systemte表UPDATE失败！！！");
            }
            
        }else{
            
            BOOL ret =[db executeUpdateWithFormat:@"INSERT INTO t_System (Host,SafetyItemVer,EmployeeId) VALUES (%@,%d,%@);",
                       SZNetwork,safeItemVer,[OTISConfig EmployeeID]];
            if (ret) {

            }else{
                SZLog(@"t_System表INSERT失败！！！");
            }
            
            
        }
        
        
        
    }];
    
}

/**
 *  获取安全项版本号
 */
+(NSString *)safetyItemVer{
    
    __block NSString *safetyItemVer = @"0";
    
    [OTISDB inDatabase:^(FMDatabase *db) {
        
        FMResultSet *set = [db executeQueryWithFormat:@"SELECT * FROM t_System WHERE EmployeeId = %@;",[OTISConfig EmployeeID]];
        while ([set next]) {
            safetyItemVer = [NSString stringWithFormat:@"%d",[set intForColumn:@"SafetyItemVer"]];
            
        }
        
        
    }];
    
    return safetyItemVer;
}

/**
 *  LaborType项版本号到t_System
 *
 *  @param dic 参数
 */
+(void)updateLaborTypeWithLaborItemVer:(NSString *)laborItemVer
{
    
    
    
    [OTISDB inDatabase:^(FMDatabase *db) {
        
        NSInteger HostCount = 0;
        
        FMResultSet *set = [db executeQueryWithFormat:@"SELECT count(Host) as HostCount from t_System WHERE EmployeeId = %@;",[OTISConfig EmployeeID]];
        while ([set next]) {
            HostCount = [set intForColumn:@"HostCount"];
        }
        if (HostCount) {
            BOOL ret =[db executeUpdateWithFormat:@"UPDATE t_System SET  Host = %@,LaborItemVer = %@ WHERE EmployeeId = %@ ;",
                       SZNetwork,laborItemVer,[OTISConfig EmployeeID]];
            if (ret) {

            }else{
                SZLog(@"t_Systemte表LaborType项版本号UPDATE失败！！！");
            }
            
        }else{
            
            BOOL ret =[db executeUpdateWithFormat:@"INSERT INTO t_System (Host,LaborItemVer,EmployeeId) VALUES (%@,%@,%@);",
                       SZNetwork,laborItemVer,[OTISConfig EmployeeID]];
            if (ret) {

            }else{
                SZLog(@"t_System表LaborType项版本号INSERT失败！！！");
            }
            
            
        }
        
        
        
    }];
    
}
/**
 *  获取LaborType版本号
 */
+(NSString *)laborItemVer{
    
    __block NSString *LaborItemVer = @"0";
    
    [OTISDB inDatabase:^(FMDatabase *db) {
        
        FMResultSet *set = [db executeQueryWithFormat:@"SELECT * FROM t_System WHERE EmployeeId = %@;",[OTISConfig EmployeeID]];
        while ([set next]) {
            LaborItemVer = [set stringForColumn:@"LaborItemVer"];
            if (LaborItemVer == nil) {
                LaborItemVer = @"0";
            }
        }
        
        
    }];
    
    return LaborItemVer;
}

@end
