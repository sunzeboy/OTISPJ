//
//  SZTable_Schedules.m
//  OTIS_PJ
//
//  Created by sunze on 16/4/28.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "SZTable_Schedules.h"
#import "TablesAndFields.h"
#import "SZTable_Unit.h"
#import "SZFinalMaintenanceUnitItem.h"
#import "SZTable_UserRoute.h"
#import "NSDate+Extention.h"
#import "SZReport.h"

@implementation SZTable_Schedules




#pragma mark - 计划表

/**
 *  存储到SchedulesDB
 *
 *  @param params
 */
+(void)storageSchedules:(NSArray *)schedules{

     SZLog(@"计划存储中。。。%@",[NSThread currentThread]);
    if (schedules.count == 0)return;
    

    [OTISDB inDatabase:^(FMDatabase *db) {
        NSString *sqlDelet = [NSString stringWithFormat:@"DELETE  FROM t_Schedules WHERE EmployeeID = '%@' ;",[OTISConfig EmployeeID]];
        BOOL ret = [db executeUpdate:sqlDelet];
        if (ret) {
            SZLog(@"删除t_Schedules成功");
        }else{
            SZLog(@"删除t_Schedules失败");
        }
        
        NSInteger cal = schedules.count%kNumberOfEachDeposit;
        NSInteger frequency = schedules.count/kNumberOfEachDeposit;
        
        for (NSInteger fre = 0; fre<frequency; fre++){
            
            NSMutableString *sql = [NSMutableString stringWithFormat:@"%@", @"INSERT INTO t_Schedules( EmployeeID,ScheduleID, UnitNo, CheckDate,Year, Times,RouteNo, CardType,IsComplete,PlanType) VALUES "];
            
            for (NSInteger i =kNumberOfEachDeposit*fre; i<kNumberOfEachDeposit*(fre +1); i++) {
                SZV4 *v4 = schedules[i];
                NSString *strSqlSuffix = [NSString stringWithFormat:@"('%@',%d,\
                                         '%@',\
                                          %ld,\
                                          %d,\
                                          %d,\
                                          %d,\
                                          %d,\
                                          %d,\
                                          %d),",
                                          [OTISConfig EmployeeID],
                                          v4.ScheduleID,
                                          v4.UnitNo,
                                          (long)[v4.CheckDate integerValue],
                                          v4.Year,
                                          v4.Times,
                                          [v4.RouteNo intValue],
                                          v4.CardType,
                                          0,
                                          v4.PlanType];
                [sql appendString:strSqlSuffix];
                
            }
            
            
            [sql deleteCharactersInRange:NSMakeRange([sql length]-1, 1)];
            BOOL a = [db executeUpdate:sql];
            if (!a) {
                NSLog(@"错误：初始化t_Schedules插入失败1");
            }
            
            
        }
        
        NSMutableString *sql = [NSMutableString stringWithFormat:@"%@", @"INSERT INTO t_Schedules( EmployeeID,ScheduleID, UnitNo, CheckDate,Year, Times,RouteNo, CardType,IsComplete,PlanType) VALUES"];
        
        for (NSInteger i =kNumberOfEachDeposit*frequency; i<kNumberOfEachDeposit*frequency +cal; i++) {
            SZV4 *v4 = schedules[i];
            NSString *strSqlSuffix = [NSString stringWithFormat:@"('%@',%d,\
                                      '%@',\
                                      %ld,\
                                      %d,\
                                      %d,\
                                      %d,\
                                      %d,\
                                      %d,\
                                      %d),",
                                      [OTISConfig EmployeeID],
                                      v4.ScheduleID,
                                      v4.UnitNo,
                                      (long)[v4.CheckDate integerValue],
                                      v4.Year,
                                      v4.Times,
                                      [v4.RouteNo intValue],
                                      v4.CardType,
                                      0,
                                      v4.PlanType];
            [sql appendString:strSqlSuffix];
            
        }
        
        [sql deleteCharactersInRange:NSMakeRange([sql length]-1, 1)];
        BOOL a = [db executeUpdate:sql];
        if (!a) {
            NSLog(@"错误：初始化t_Schedules插入失败2");
        }

        
        
        
        SZLog(@"计划存储完成！%@",[NSThread currentThread]);
    }];
    
}

+(void)updateIsComplete:(int)isComplete andScheduleID:(int)scheduleID{

    [OTISDB inDatabase:^(FMDatabase *db) {

        BOOL ret = [db executeUpdateWithFormat:@"UPDATE t_Schedules SET IsComplete = %d WHERE ScheduleId = %d;",isComplete,scheduleID];
        if (ret) {
            SZLog(@"IsComplete更新成功！！！");
        }else{
            SZLog(@"IsComplete更新失败！！！");
        }
        
        
    }];

}




+(NSString *)quaryUnitNoWithScheduleID:(int)scheduleID{
    
   __block NSString *unitNo = @"";
    [OTISDB inDatabase:^(FMDatabase *db) {
        
        
        FMResultSet *set = [db executeQueryWithFormat:@"SELECT  UnitNo \
                            FROM t_Schedules \
                            WHERE ScheduleId = %d;",scheduleID];
        while ([set next]) {
            unitNo =  [set stringForColumn:@"UnitNo"];
        }
        
        
    }];

    return unitNo;
}


+(void)updateAddLaborHoursState:(int)addLaborHoursState andScheduleID:(NSInteger)scheduleID{
    
    [OTISDB inDatabase:^(FMDatabase *db) {
        
        BOOL ret = [db executeUpdateWithFormat:@"UPDATE  t_Schedules SET AddLaborHoursState= %d WHERE ScheduleID = %ld AND EmployeeID=%@ ;",addLaborHoursState,(long)scheduleID,[OTISConfig EmployeeID]];
        if (ret) {
            
        }else{
            SZLog(@"AddLaborHoursState更新失败！！！");
        }
        
        
    }];
    
}



+(int)quaryLaborHoursStateWithScheduleID:(int)scheduleID{
    
    __block int addLaborHoursState = 0;
    [OTISDB inDatabase:^(FMDatabase *db) {
        
        
        FMResultSet *set = [db executeQueryWithFormat:@"SELECT AddLaborHoursState \
                                FROM t_Schedules WHERE EmployeeID=%@ AND ScheduleID=%d ;",[OTISConfig EmployeeID],scheduleID];
        while ([set next]) {
            addLaborHoursState =  [set intForColumn:@"AddLaborHoursState"];
        }
        
        
    }];
    
    return addLaborHoursState;
}

+(void)updateAddLaborHoursStateWithScheduleID:(int)scheduleID{
    
    [OTISDB inDatabase:^(FMDatabase *db) {
        
        // 维保进入工时氛围两种情况，一个是灰色的，上传完成所有维保项目；此时需要清除数据，每次填写完成后，在进入就是新建，所以需要清除
        // 如果是维保的时候，没有上传，就相当于填写工时的功能
        
        
        
        BOOL ret1 = [db executeUpdateWithFormat:@"DELETE FROM t_QRCode \
                     WHERE GroupID=0 AND EmployeeID=%@ AND ScheduleID=%d AND IsFixItem=0;",
                     [OTISConfig EmployeeID],scheduleID];
        BOOL ret2 = [db executeUpdateWithFormat:@"DELETE FROM t_JHA_USER_SELECTED_SCHEDULE_ITEM  \
                                                  WHERE  EmployeeID=%@ AND ScheduleID=%d AND IsFixItem=0;",[OTISConfig EmployeeID],scheduleID];
        BOOL ret3 = [db executeUpdateWithFormat:@"DELETE FROM t_LaborHours WHERE GroupID=0 AND  EmployeeID=%@ AND ScheduleID=%d;",[OTISConfig EmployeeID],scheduleID];

        if (ret1) {

        }else{
            SZLog(@"IsComplete更新失败！！！");
        }
        if (ret2) {
            
        }else{
            SZLog(@"IsComplete更新失败！！！");
        }
        if (ret3) {
            
        }else{
            SZLog(@"IsComplete更新失败！！！");
        }
        
        
    }];
    
}

+(BOOL) isMyRouteNoInTabScheduleWithScheduleID:(int)scheduleID{

    __block int isMyRouteNo = 0 ;
    NSArray *arrayRoutNos = [SZTable_UserRoute routNos];
    NSString *strRoutes = [arrayRoutNos componentsJoinedByString:@","];
    
    NSString *sql = [NSString stringWithFormat:@"SELECT count() AS isMyRouteNo \
                              FROM  t_Schedules \
                              WHERE ScheduleID=%d AND RouteNo IN (%@);",scheduleID,strRoutes];
    
    [OTISDB inDatabase:^(FMDatabase *db) {
        
        FMResultSet *set  = [db executeQuery:sql];
        while ([set next]) {
            isMyRouteNo =  [set intForColumn:@"isMyRouteNo"];
        }
    }];
    
    return (isMyRouteNo >0 );
}



@end
