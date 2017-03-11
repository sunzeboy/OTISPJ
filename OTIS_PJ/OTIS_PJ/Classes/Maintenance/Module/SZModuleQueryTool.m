//
//  SZModuleQueryTool.m
//  OTIS_PJ
//
//  Created by sunze on 16/5/17.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "SZModuleQueryTool.h"
#import "TablesAndFields.h"
#import "SZFinalOutsidePlanMaintenanceItem.h"
#import "SZFinalMaintenanceUnitItem.h"
#import "NSDate+Extention.h"
#import "SZFinalMaintenanceUnitDetialItem.h"
#import "SZJHATitleItem.h"
#import "SZMaintenanceCheckItem.h"
#import "SZUploadMaintenancemRequest.h"
#import "SZUploadFixRequest.h"
#import "SZUploadMaintenancePicRequest.h"
#import "SZUploadSignatureRequest.h"
#import "SZUploadYearlyCheckRequest.h"
#import "SZUploadFullLaborHoursRequest.h"
#import "FMResultSet+Extention.h"
@implementation SZModuleQueryTool
//------------------------------------------------------------------------------------------------------------------------------------------------


/**
 *  今日维保数据
 *
 *  @param params 请求参数
 */
+(NSArray *)queryTodayMaintenance{

    NSMutableArray *arrayData = [NSMutableArray array];
    
    NSArray *arrayRoutNos = [SZTable_UserRoute routNos];
    
    NSString *strRoutes = [arrayRoutNos componentsJoinedByString:@","];
    
   
    [OTISDB inDatabase:^(FMDatabase *db) {
//        SZLog(@"%ld    %@",(long)[NSDate sinceDistantPast],strRoutes);
        NSString *sql = [NSString stringWithFormat:@"\
                            SELECT \
                                t_Schedules.ScheduleID,\
                                t_Units.UnitRegcode,\
                                t_Schedules.CheckDate,\
                                t_Schedules.UnitNo,\
                                t_Schedules.Times,\
                                t_Schedules.CardType,\
                                t_Schedules.PlanType ,\
                                t_Schedules.IsComplete ,\
                                t_Units.Route,\
                                t_Units.UnitName,\
                                t_Building.BuildingName,\
                                1 AS IS_NOT_REPAIR, \
                                t_Building.BuildingNo \
                                FROM   t_Schedules ,t_Units,t_Building\
                                WHERE  ( t_Schedules.CheckDate = %ld AND\
                                        t_Schedules.IsComplete != 3 AND t_Schedules.RouteNo IN (%@) )  AND\
                                        t_Schedules.UnitNo = t_Units.UnitNo AND\
                                        t_Building.BuildingNo=t_Units.BuildingNo \
                                AND (NOT EXISTS ( \
                                                SELECT 1 \
                                                FROM  (SELECT ScheduleID FROM t_Signature WHERE  IsAbsent=0 AND IsUploaded =1) AS TT \
                                                WHERE (TT.ScheduleID = t_Schedules.ScheduleID)) \
                                ) \
                        UNION \
                            SELECT \
                                t_Schedules.ScheduleID,\
                                t_Units.UnitRegcode,\
                                t_Schedules.CheckDate,\
                                t_Schedules.UnitNo,\
                                t_Schedules.Times,\
                                t_Schedules.CardType,\
                                t_Schedules.PlanType ,\
                                t_Schedules.IsComplete ,\
                                t_Units.Route,\
                                t_Units.UnitName,\
                                t_Building.BuildingName,\
                                0 AS IS_NOT_REPAIR, \
                                t_Building.BuildingNo \
                            FROM  t_Schedules ,t_Units,t_Building , \
                                    (SELECT ScheduleId FROM t_Report WHERE EmployeeID='%@' AND IsRepairItem=1 \
                         GROUP BY ScheduleId) AS T1 \
                            WHERE   T1.ScheduleID=t_Schedules.ScheduleID \
                                    AND t_Schedules.UnitNo = t_Units.UnitNo \
                                    AND t_Building.BuildingNo = t_Units.BuildingNo \
                            ORDER BY IS_NOT_REPAIR,t_Building.BuildingNo,t_Schedules.UnitNo;",
                         (long)[NSDate sinceDistantPast],strRoutes,[OTISConfig EmployeeID]];
        
        SZLog(@"今日维保查询:%@",sql);
        FMResultSet *set = [db executeQuery:sql];
        
            while ([set next]) {
                
                SZFinalMaintenanceUnitItem *unitItem = [[SZFinalMaintenanceUnitItem alloc] init];
                if ([UIDevice currentDevice].systemVersion.floatValue<10) {
                    unitItem.UnitNo = [set stringForColumn:@"t_Schedules.UnitNo"];
                    unitItem.Times = [set intForColumn:@"t_Schedules.Times"];
                    unitItem.CheckDate = [set longForColumn:@"t_Schedules.CheckDate"];
                    unitItem.CardType = [set intForColumn:@"t_Schedules.CardType"];
                    unitItem.BuildingName = [set stringForColumn:@"t_Building.BuildingName"];
                    unitItem.Route = [set stringForColumn:@"t_Units.Route"];
                    unitItem.ScheduleID = [set intForColumn:@"t_Schedules.ScheduleID"];
                    unitItem.UnitRegcode = [set stringForColumn:@"t_Units.UnitRegcode"];
                    unitItem.isFixMode = ![set boolForColumn:@"IS_NOT_REPAIR"];
                    unitItem.UnitName = [set stringForColumn:@"t_Units.UnitName"];
                }else{
                    unitItem.UnitNo = [set stringForColumn:@"UnitNo"];
                    unitItem.Times = [set intForColumn:@"Times"];
                    unitItem.CheckDate = [set longForColumn:@"CheckDate"];
                    unitItem.CardType = [set intForColumn:@"CardType"];
                    unitItem.BuildingName = [set stringForColumn:@"BuildingName"];
                    unitItem.Route = [set stringForColumn:@"Route"];
                    unitItem.ScheduleID = [set intForColumn:@"ScheduleID"];
                    unitItem.UnitRegcode = [set stringForColumn:@"UnitRegcode"];
                    unitItem.isFixMode = ![set boolForColumn:@"IS_NOT_REPAIR"];
                    unitItem.UnitName = [set stringForColumn:@"UnitName"];
                }
                
                NSString *strUnitName = unitItem.UnitName.uppercaseString;
                if ([strUnitName containsString:@"_MD"]) {
                    [arrayData  addObject:unitItem];
                }

            }
        
    }];

    
    return [NSArray arrayWithArray:arrayData];
}

/**
 *  维保数据（二级页面）
 *
 *  @param params 请求参数
 */
+(SZFinalMaintenanceUnitDetialItem *)queryDetialMaintenanceWithScheduleID:(NSInteger)scheduleID{
    
    SZFinalMaintenanceUnitDetialItem *unitItem = [[SZFinalMaintenanceUnitDetialItem alloc] init];

    [OTISDB inDatabase:^(FMDatabase *db) {
        
        FMResultSet *set = [db executeQueryWithFormat:@"SELECT t_Schedules.ScheduleID,\
                            t_Schedules.UnitNo,\
                            t_Schedules.Times,\
                            t_Schedules.CheckDate,\
                            t_Schedules.CardType ,\
                            t_Units.Owner,\
                            t_Units.ModelType,\
                            t_Units.Tel,\
                            t_Units.UnitRegcode,\
                            t_Building.BuildingAddr,\
                            t_Units.Route,\
                            t_Units.UnitName,\
                            t_Building.BuildingName\
                            FROM   t_Schedules ,t_Units,t_Building\
                            WHERE  ScheduleID = %ld AND t_Units.UnitNo=t_Schedules.UnitNo AND t_Building.BuildingNo = t_Units.BuildingNo;",(long)scheduleID];
        while ([set next]) {
            
            unitItem.UnitNo = [set stringForColumn:@"UnitNo"];
            unitItem.Times = [set intForColumn:@"Times"];
            unitItem.CheckDate = [set longForColumn:@"CheckDate"];
            unitItem.CardType = [set intForColumn:@"CardType"];
            unitItem.BuildingName = [set stringForColumn:@"BuildingName"];
            unitItem.Route = [set stringForColumn:@"Route"];
            unitItem.Owner = [set stringForColumn:@"Owner"];
            unitItem.ModelType = [set stringForColumn:@"ModelType"];
            unitItem.Tel = [set stringForColumn:@"Tel"];
            unitItem.BuildingAddr = [set stringForColumn:@"BuildingAddr"];
            unitItem.UnitRegcode = [set stringForColumn:@"UnitRegcode"];
            unitItem.UnitName = [set stringForColumn:@"UnitName"];
        }
        
    }];
    
    return unitItem;

}

+(SZFinalMaintenanceUnitDetialItem *)queryGongshiDetialMaintenanceWithUnitNo:(NSString *)unitNo{
    
    SZFinalMaintenanceUnitDetialItem *unitItem = [[SZFinalMaintenanceUnitDetialItem alloc] init];
    
    [OTISDB inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"SELECT UnitNo, \
                         UnitRegcode, \
                         ModelType, \
                         CardType, \
                         t_Units.Route, \
                         BuildingName, \
                         BuildingAddr, \
                         Owner, \
                         Tel \
                         FROM t_Units,t_Building \
                         WHERE t_Units.UnitNo='%@' \
                         AND t_Units.BuildingNo=t_Building.BuildingNo;",unitNo];
        FMResultSet *set = [db executeQuery:sql];
        while ([set next]) {
            
            unitItem.UnitNo = [set stringForColumn:@"UnitNo"];
            unitItem.CardType = [set intForColumn:@"CardType"];
            unitItem.BuildingName = [set stringForColumn:@"BuildingName"];
            unitItem.Route = [set stringForColumn:@"Route"];
            unitItem.Owner = [set stringForColumn:@"Owner"];
            unitItem.ModelType = [set stringForColumn:@"ModelType"];
            unitItem.Tel = [set stringForColumn:@"Tel"];
            unitItem.BuildingAddr = [set stringForColumn:@"BuildingAddr"];
            unitItem.UnitRegcode = [set stringForColumn:@"UnitRegcode"];
            unitItem.UnitName = [set stringForColumn:@"UnitName"];

        }
        
    }];
    
    return unitItem;
    
}

+(BOOL)isCompleatedAndUpload:(SZFinalMaintenanceUnitDetialItem *)unitDetialItem{
    
    __block NSInteger myCompleatedAndUpload=0;
    __block NSInteger otherCompleatedAndUpload=0;
    __block NSInteger count1=0;
    __block NSInteger IsUploaded=0;
    [OTISDB inDatabase:^(FMDatabase *db) {
        //  自己做过的电梯，并且上传了
        NSString *sql = [NSString stringWithFormat:@"SELECT IsComplete ,IsUploaded, count() AS count1\
                                                     FROM t_Report,t_Schedules \
                                                     WHERE t_Report.ScheduleId = %ld  \
                                                             AND t_Report.ScheduleId=t_Schedules.ScheduleID\
                                                             AND IsRepairItem=0;",
                                                    (long)unitDetialItem.ScheduleID];
        FMResultSet *set = [db executeQuery:sql];
        while ([set next]) {
            myCompleatedAndUpload = [set intForColumn:@"IsComplete"];
            count1 = [set intForColumn:@"count1"];
            IsUploaded =[set intForColumn:@"IsUploaded"];
        }
        
        sql = [NSString stringWithFormat:@"SELECT IsComplete \
                         FROM t_Schedules \
                         WHERE ScheduleId=%ld;",(long)unitDetialItem.ScheduleID];
        
        FMResultSet *set1 = [db executeQuery:sql];
        while ([set1 next]) {
            otherCompleatedAndUpload = [set1 intForColumn:@"IsComplete"];
        }
        
        
    }];
    NSInteger all = 0;
    NSInteger  competed=0;
    all= [SZModuleQueryTool queryAllMaintenanceWithUnitDetialItem:unitDetialItem];
    competed = [SZModuleQueryTool queryCompletedMaintenanceWithUnitDetialItem:unitDetialItem];
    
    if(count1>0){ // 本地有记录，并且是完成的，而且上传完成
        if(IsUploaded==1 && myCompleatedAndUpload == 2 && all == competed){
            return YES;
        }
    }else {// 下载的，计划外的，或者未完成列表中的，
        if(otherCompleatedAndUpload==2){
            return YES;
        }
    }
//    NSInteger all = 0;
//    NSInteger  competed=0;
//    all= [SZModuleQueryTool queryAllMaintenanceWithUnitDetialItem:unitDetialItem];
//    competed = [SZModuleQueryTool queryCompletedMaintenanceWithUnitDetialItem:unitDetialItem];
    if (IsUploaded==1 && all == competed) {
        return YES;
    }
    return NO;
}

/**
 *  计算电梯已经完成的保养项
 *
 *  @param params 请求参数
 */
+(NSInteger)queryCompletedMaintenanceWithUnitDetialItem:(SZFinalMaintenanceUnitDetialItem *)unitDetialItem{

    __block NSInteger completedMaintenanceCount ;
    [OTISDB inDatabase:^(FMDatabase *db) {
        NSString *sql;
        if(unitDetialItem.isFixMode){
            // Fix的情况，找出已经完成的保养项目
            sql = [NSString stringWithFormat:@"SELECT count() AS COMPLETED_ITEM \
                   FROM  t_FIX_DOWNLOAD \
                   WHERE State=2 AND ScheduleId=%ld;",
                   (long)unitDetialItem.ScheduleID];
        
        }
        else{
            // 计算已经做的保养项目和，去除年检中的每年一次项目
            sql = [NSString stringWithFormat:@"SELECT count(STATE) AS COMPLETED_ITEM \
                             FROM  t_REPORT_ITEM_COMPLETE_STATE\
                             WHERE ScheduleID= %ld   AND\
                             (NOT EXISTS ( \
                             SELECT 1 \
                             FROM t_CheckItem \
                             WHERE    Type<=0 AND \
                             t_CheckItem.ItemCode = t_REPORT_ITEM_COMPLETE_STATE.ItemCode  ) );",
                   (long)unitDetialItem.ScheduleID];
        }
        SZLog(@"是否完成:%@",sql);
        FMResultSet *set = [db executeQuery:sql];
        
        while ([set next]) {
            
            completedMaintenanceCount = [set intForColumn:@"COMPLETED_ITEM"];
  
        }
        
    }];

    return completedMaintenanceCount;
}

/**
 *  计算保养项的和t_ScheduleCheckItem
 *
 *  @param params 请求参数
 */

+(NSInteger)queryAllMaintenanceWithUnitDetialItem:(SZFinalMaintenanceUnitDetialItem *)unitDetialItem{

    __block NSInteger allMaintenanceCount ;
    [OTISDB inDatabase:^(FMDatabase *db) {
        NSString *sql;
        
        if(unitDetialItem.isFixMode){
            // Fix的情况，计算保养项的和
            sql = [NSString stringWithFormat:@"\
                            SELECT count() AS ALL_CHECK_ITEM\
                            FROM   t_FIX_DOWNLOAD \
                            WHERE ScheduleId=%ld;",
                            (long)unitDetialItem.ScheduleID];
        }else{
            //正常维保计算保养项的和
            sql = [NSString stringWithFormat:@"\
                            SELECT sum(ALL_CHECK_ITEM) AS ALL_CHECK_ITEM\
                            FROM   (SELECT count() AS ALL_CHECK_ITEM\
                                    FROM   t_CheckItem ,(SELECT ItemCode,CardType FROM t_ScheduleCheckItem WHERE CardType= %ld AND Times = %ld) AS T1\
                            WHERE  T1.ItemCode =t_CheckItem.ItemCode AND T1.CardType=t_CheckItem.CardType \
                        UNION \
                            SELECT count() AS ALL_CHECK_ITEM\
                            FROM t_CheckItem \
                            WHERE t_CheckItem.CardType= %ld AND TYPE=24  );",
                            (long)unitDetialItem.CardType,
                            (long)unitDetialItem.Times,
                            (long)unitDetialItem.CardType];
        }
        SZLog(@"SQL queryAllMaintenanceWithUnitDetialItem:%@",sql);
        FMResultSet *set = [db executeQuery:sql];
        while ([set next]) {
            allMaintenanceCount = [set intForColumn:@"ALL_CHECK_ITEM"];
            
        }
        
    }];
    
    
    return allMaintenanceCount;

}

//------------------------------------------------------------------------------------------------------------------------------------------------


/**
 *  未完成维保数据
 *
 *  @param params 请求参数
 */
+(NSArray *)queryNotCompletedMaintenance{
    NSMutableArray *arrayData = [NSMutableArray array];
    
    NSArray *arrayRoutNos = [SZTable_UserRoute routNos];
    
    NSString *strRoutes = [arrayRoutNos componentsJoinedByString:@","];
    
    
    [OTISDB inDatabase:^(FMDatabase *db) {
        
        NSString *sql = [NSString stringWithFormat:@"\
                         SELECT  t_Schedules.ScheduleID,\
                                 t_Schedules.CheckDate,\
                                 t_Units.UnitRegcode,\
                                 t_Units.UnitName,\
                                 t_Schedules.UnitNo,\
                                 t_Schedules.Times,\
                                 t_Schedules.CardType,\
                                 t_Schedules.PlanType ,\
                                 t_Schedules.IsComplete ,\
                                 t_Units.Route,\
                                 t_Building.BuildingName\
                         FROM   t_Schedules ,t_Units,t_Building\
                         WHERE  ( t_Schedules.CheckDate< %ld AND\
                                 t_Schedules.IsComplete != 3 AND t_Schedules.RouteNo IN (%@) )  AND\
                                 t_Schedules.UnitNo = t_Units.UnitNo AND\
                                 t_Building.BuildingNo=t_Units.BuildingNo \
                         order by t_Schedules.CheckDate,t_Building.BuildingNo,t_Schedules.UnitNo ",(long)[NSDate sinceDistantPast],strRoutes];
        FMResultSet *set = [db executeQuery:sql];
        while ([set next]) {
            
            SZFinalMaintenanceUnitItem *unitItem = [[SZFinalMaintenanceUnitItem alloc] init];
            unitItem.UnitNo = [set stringForColumn:@"UnitNo"];
            unitItem.Times = [set intForColumn:@"Times"];
            unitItem.CheckDate = [set longForColumn:@"CheckDate"];
            unitItem.CardType = [set intForColumn:@"CardType"];
            unitItem.BuildingName = [set stringForColumn:@"BuildingName"];
            unitItem.Route = [set stringForColumn:@"Route"];
            unitItem.ScheduleID = [set intForColumn:@"ScheduleID"];
            unitItem.UnitRegcode = [set stringForColumn:@"UnitRegcode"];
            unitItem.isFixMode = NO;
            unitItem.UnitName = [set stringForColumn:@"UnitName"];

            NSString *strUnitName = unitItem.UnitName.uppercaseString;
            if ([strUnitName containsString:@"_MD"]) {
                [arrayData  addObject:unitItem];
            }
        }
        
    }];

    
    return [NSArray arrayWithArray:arrayData];
}

///**
// *  未完成维保数据(unitRegcode)
// *  @param params 请求参数
// */
//+(SZFinalMaintenanceUnitItem *)queryNotCompletedMaintenanceWithUnitRegcode:(NSArray *)unitRegcode{
//    SZFinalMaintenanceUnitItem *unitItem = [[SZFinalMaintenanceUnitItem alloc] init];
//    
//    NSArray *arrayRoutNos = [SZTable_UserRoute routNos];
//    
//    NSString *strRoutes = [arrayRoutNos componentsJoinedByString:@","];
//    
//    [OTISDB inDatabase:^(FMDatabase *db) {
//        
//        FMResultSet *set = [db executeQueryWithFormat:@"SELECT t_Schedules.ScheduleID,\
//                            t_Schedules.CheckDate,\
//                            t_Schedules.UnitNo,\
//                            t_Schedules.Times,\
//                            t_Schedules.CardType,\
//                            t_Schedules.PlanType ,\
//                            t_Schedules.IsComplete ,\
//                            t_Building.Route,\
//                            t_Building.BuildingName\
//                            FROM   t_Schedules ,t_Units,t_Building\
//                            WHERE  ( t_Schedules.CheckDate< %ld AND\
//                            t_Schedules.IsComplete != 3 AND t_Schedules.RouteNo IN (%@) )  AND\
//                            t_Schedules.UnitNo = t_Units.UnitNo AND\
//                            t_Building.BuildingNo=t_Units.BuildingNo AND t_Units.UnitRegcode = %@;",(long)[NSDate sinceDistantPast],strRoutes,unitRegcode];
//        while ([set next]) {
//            
//            unitItem.UnitNo = [set stringForColumn:@"UnitNo"];
//            unitItem.Times = [set intForColumn:@"Times"];
//            unitItem.CheckDate = [set longForColumn:@"CheckDate"];
//            unitItem.CardType = [set intForColumn:@"CardType"];
//            unitItem.BuildingName = [set stringForColumn:@"BuildingName"];
//            unitItem.Route = [set stringForColumn:@"Route"];
//            unitItem.ScheduleID = [set intForColumn:@"ScheduleID"];
//            unitItem.UnitRegcode = [set stringForColumn:@"UnitRegcode"];
//            
//        }
//        
//    }];
//    
//    
//    return unitItem;
//
//}

//------------------------------------------------------------------------------------------------------------------------------------------------


/**
 *  两周维保数据
 *
 *  @param params 请求参数
 */
+(NSArray *)queryTwoWeeksMaintenance{
    
    NSMutableArray *arrayData = [NSMutableArray array];
    NSInteger Mondaytime = [NSDate sinceDistantPastToDate:[NSDate thisWeekMondayOrNextSunday:@"Monday"]];
    NSInteger Sundaytime = [NSDate sinceDistantPastToDate:[NSDate thisWeekMondayOrNextSunday:@"Sunday"]];
    
    NSArray *arrayRoutNos = [SZTable_UserRoute routNos];

    NSString *strRoutes = [arrayRoutNos componentsJoinedByString:@","];
    
    
    [OTISDB inDatabase:^(FMDatabase *db) {
        
        NSString *sql = [NSString stringWithFormat:@"\
                         SELECT  t_Schedules.ScheduleID,\
                                 t_Schedules.CheckDate,\
                                 t_Units.UnitRegcode,\
                                 t_Schedules.UnitNo,\
                                 t_Schedules.Times,\
                                 t_Schedules.CardType,\
                                 t_Schedules.PlanType ,\
                                 t_Schedules.IsComplete ,\
                                 t_Units.Route,\
                                 t_Building.BuildingName\
                         FROM   t_Schedules ,t_Units,t_Building\
                         WHERE  ( (t_Schedules.CheckDate <= %ld AND t_Schedules.CheckDate >= %ld)  AND\
                                (t_Schedules.IsComplete != 3 OR  t_Schedules.IsComplete =0)AND t_Schedules.RouteNo IN (%@) )  AND\
                                t_Schedules.UnitNo = t_Units.UnitNo AND\
                                t_Building.BuildingNo=t_Units.BuildingNo \
                         GROUP BY t_Schedules.CheckDate,t_Building.BuildingNo,t_Schedules.UnitNo",(long)Sundaytime,(long)Mondaytime,strRoutes];
        
        FMResultSet *set = [db executeQuery:sql];
        while ([set next]) {
            
            SZFinalMaintenanceUnitItem *unitItem = [[SZFinalMaintenanceUnitItem alloc] init];
            unitItem.UnitNo = [set stringForColumn:@"UnitNo"];
            unitItem.Times = [set intForColumn:@"Times"];
            unitItem.CheckDate = [set longForColumn:@"CheckDate"];
            unitItem.CardType = [set intForColumn:@"CardType"];
            unitItem.BuildingName = [set stringForColumn:@"BuildingName"];
            unitItem.Route = [set stringForColumn:@"Route"];
            unitItem.ScheduleID = [set intForColumn:@"ScheduleID"];
            unitItem.UnitRegcode = [set stringForColumn:@"UnitRegcode"];
            unitItem.isFixMode = NO;

            [arrayData  addObject:unitItem];
            
        }
        
    }];

    return [NSArray arrayWithArray:arrayData];

}

///**
// *  两周维保数据(unitRegcode)
// *
// *  @param params 请求参数
// */
//+(SZFinalMaintenanceUnitItem *)queryTwoWeeksMaintenanceWithUnitRegcode:(NSArray *)unitRegcode{
//
//    SZFinalMaintenanceUnitItem *unitItem = [[SZFinalMaintenanceUnitItem alloc] init];
//    NSInteger Mondaytime = [NSDate sinceDistantPastToDate:[NSDate thisWeekMondayOrNextSunday:@"Monday"]];
//    NSInteger Sundaytime = [NSDate sinceDistantPastToDate:[NSDate thisWeekMondayOrNextSunday:@"Sunday"]];
//    NSArray *arrayRoutNos = [SZTable_UserRoute routNos];
//    
//    NSString *strRoutes = [arrayRoutNos componentsJoinedByString:@","];
//    
//    [OTISDB inDatabase:^(FMDatabase *db) {
//        
//        FMResultSet *set = [db executeQueryWithFormat:@"SELECT t_Schedules.ScheduleID,\
//                            t_Schedules.CheckDate,\
//                            t_Schedules.UnitNo,\
//                            t_Schedules.Times,\
//                            t_Schedules.CardType,\
//                            t_Schedules.PlanType ,\
//                            t_Schedules.IsComplete ,\
//                            t_Building.Route,\
//                            t_Building.BuildingName\
//                            FROM   t_Schedules ,t_Units,t_Building\
//                            WHERE  ( (t_Schedules.CheckDate <= %ld AND t_Schedules.CheckDate >= %ld)  AND\
//                            (t_Schedules.IsComplete != 3 OR  t_Schedules.IsComplete =0)AND t_Schedules.RouteNo IN (%@) )  AND\
//                            t_Schedules.UnitNo = t_Units.UnitNo AND\
//                            t_Building.BuildingNo=t_Units.BuildingNo AND t_Units.UnitRegcode = %@ order by t_Schedules.CheckDate,t_Building.BuildingNo ;",(long)Sundaytime,(long)Mondaytime,strRoutes,unitRegcode];
//        while ([set next]) {
//            
//            unitItem.UnitNo = [set stringForColumn:@"UnitNo"];
//            unitItem.Times = [set intForColumn:@"Times"];
//            unitItem.CheckDate = [set longForColumn:@"CheckDate"];
//            unitItem.CardType = [set intForColumn:@"CardType"];
//            unitItem.BuildingName = [set stringForColumn:@"BuildingName"];
//            unitItem.Route = [set stringForColumn:@"Route"];
//            unitItem.ScheduleID = [set intForColumn:@"ScheduleID"];
//            unitItem.UnitRegcode = [set stringForColumn:@"UnitRegcode"];
//            
//        }
//        
//    }];
//    
//    
//    return unitItem;
//
//
//}


//------------------------------------------------------------------------------------------------------------------------------------------------


/**
 *  计划外维保数据
 *
 *  @param params 请求参数
 */
+(NSArray *)queryOutsidePlanMaintenance{
    
    NSMutableArray *arrayData = [NSMutableArray array];
    NSInteger Mondaytime = [NSDate sinceDistantPastToDate:[NSDate thisWeekMondayOrNextSunday:@"Monday"]];
    NSInteger Sundaytime = [NSDate sinceDistantPastToDate:[NSDate thisWeekMondayOrNextSunday:@"Sunday"]];
    [OTISDB inDatabase:^(FMDatabase *db) {
        
        NSString *sql = [NSString stringWithFormat:@"SELECT t_Building.BuildingNo,Route,BuildingName ,BuildingAddr ,T3.COUNT_BUILDING_UNIT FROM t_Building ,\
                         (SELECT BuildingNo,sum( T2.COUNT_UNIT_NO) as COUNT_BUILDING_UNIT FROM \
                         (SELECT \
                         BuildingNo, COUNT_UNIT_NO \
                         FROM \
                         t_Units, \
                         (SELECT UnitNo, count(UnitNo) AS 'COUNT_UNIT_NO' FROM t_Schedules WHERE IsComplete != 3 AND t_Schedules.CheckDate <= %ld AND t_Schedules.CheckDate >= %ld GROUP BY UnitNo ) AS T1 \
                         WHERE T1.UnitNo = t_Units.UnitNo ) AS T2 group by BuildingNo) AS T3 \
                         WHERE T3.BuildingNo=t_Building.BuildingNo AND t_Building.SupervisorNo IN (%@) GROUP BY t_Building.BuildingNo ",(long)Sundaytime,(long)Mondaytime,[SZTable_UserSupervisor supervisorsStr]];
        
        FMResultSet *set = [db executeQuery:sql];
        
        while ([set next]) {
            SZFinalOutsidePlanMaintenanceItem *outside = [[SZFinalOutsidePlanMaintenanceItem alloc] init];
            outside.BuildingName = [set stringForColumn:@"BuildingName"];
            outside.Route = [set stringForColumn:@"Route"];
            outside.BuildingAddr = [set stringForColumn:@"BuildingAddr"];
            outside.unitCount = [NSString stringWithFormat:@"%d",[set intForColumn:@"COUNT_BUILDING_UNIT"]];
            outside.BuildingNo = [set stringForColumn:@"BuildingNo"];
            
            [arrayData  addObject:outside];
            
        }

    }];
    
    return [NSArray arrayWithArray:arrayData];
}


+(SZFinalMaintenanceUnitItem *)queryOutsideUnitesWithUnitRegcodes:(SZQRCodeProcotolitem *)item{

    SZFinalMaintenanceUnitItem *unitItem = [[SZFinalMaintenanceUnitItem alloc] init];
    NSInteger Mondaytime = [NSDate sinceDistantPastToDate:[NSDate thisWeekMondayOrNextSunday:@"Monday"]];
    NSInteger Sundaytime = [NSDate sinceDistantPastToDate:[NSDate thisWeekMondayOrNextSunday:@"Sunday"]];
    [OTISDB inDatabase:^(FMDatabase *db) {
        
        if (item.strArray&&item.strArray.count) {
            for (NSString *rCode in item.strArray) {
                
                FMResultSet *set = [db executeQueryWithFormat:@"SELECT t_Schedules.ScheduleID \
                                    FROM t_Schedules , t_Units,t_Building \
                                    WHERE  UnitRegcode=%@ AND  IsComplete != 3 AND \
                                    (t_Schedules.CheckDate <= %ld AND t_Schedules.CheckDate >= %ld) AND \
                                    t_Units.UnitNo=t_Schedules.UnitNo AND \
                                    t_Units.BuildingNo = t_Building.BuildingNo;",rCode,(long)Sundaytime,(long)Mondaytime];
                
                while ([set next]) {
                    unitItem.ScheduleID = [set intForColumn:@"ScheduleID"];
                }
                
            }

        }else{
            
            if (item.REG_CODE.length>0) {
                NSString *sql = [NSString stringWithFormat:@"SELECT t_Schedules.ScheduleID \
                                 FROM t_Schedules , t_Units,t_Building \
                                 WHERE  UnitRegcode= '%@' AND  IsComplete != 3 AND \
                                 (t_Schedules.CheckDate <= %ld AND t_Schedules.CheckDate >= %ld) AND \
                                 t_Units.UnitNo=t_Schedules.UnitNo AND \
                                 t_Units.BuildingNo = t_Building.BuildingNo;",item.REG_CODE,(long)Sundaytime,(long)Mondaytime];
                FMResultSet *set = [db executeQuery:sql];
                
                while ([set next]) {
                    unitItem.ScheduleID = [set intForColumn:@"ScheduleID"];
                }

            }
            
            if (!unitItem.ScheduleID) {
                NSString *sql = [NSString stringWithFormat:@"SELECT t_Schedules.ScheduleID \
                                 FROM t_Schedules , t_Units,t_Building \
                                 WHERE  t_Units.UnitNo= '%@' AND  IsComplete != 3 AND \
                                 (t_Schedules.CheckDate <= %ld AND t_Schedules.CheckDate >= %ld) AND \
                                 t_Units.UnitNo=t_Schedules.UnitNo AND \
                                 t_Units.BuildingNo = t_Building.BuildingNo;",item.UNIT_NO,(long)Sundaytime,(long)Mondaytime];
                FMResultSet *set = [db executeQuery:sql];
                
                while ([set next]) {
                    unitItem.ScheduleID = [set intForColumn:@"ScheduleID"];
                }

                
            }
    
           
        
        }
        
        
    }];
    
    return unitItem;

}

+(SZFinalMaintenanceUnitItem *)queryGongshiUnitesWithUnitRegcodes:(SZQRCodeProcotolitem *)item{
    
    SZFinalMaintenanceUnitItem *unitItem = [[SZFinalMaintenanceUnitItem alloc] init];
    
    [OTISDB inDatabase:^(FMDatabase *db) {
//        NSInteger supervisorNo = [SZTable_UserSupervisor supervisorNo];

        if (item.strArray&&item.strArray.count) {
            for (NSString *rCode in item.strArray) {
                
                NSString *sql = [NSString stringWithFormat:@"SELECT \
                                 t_Units.UnitNo \
                                 FROM t_Building,t_Units \
                                 WHERE \
                                 SupervisorNo IN (%@) \
                                 AND t_Units.BuildingNo = t_Building.BuildingNo \
                                 AND UnitRegcode in ('%@') ",[SZTable_UserSupervisor supervisorsStr],rCode];
                FMResultSet *set = [db executeQuery:sql];
                
                while ([set next]) {
                    unitItem.ScheduleID = [set intForColumn:@"ScheduleID"];
                    unitItem.UnitNo = [set stringForColumn:@"UnitNo"];

                }
                
            }
            
        }else{
            
            if (item.REG_CODE&& ![item.REG_CODE isEqualToString:@""]) {
                FMResultSet *set = [db executeQueryWithFormat:@"SELECT UnitNo, \
                                    UnitRegcode \
                                    FROM t_Units,(SELECT BuildingNo,BuildingName,BuildingAddr FROM t_Building WHERE SupervisorNo IN (%@) ) T1 \
                                    WHERE t_Units.BuildingNo = T1.BuildingNo \
                                    AND  UnitRegcode=%@ ;",[SZTable_UserSupervisor supervisorsStr],item.REG_CODE];
                
                while ([set next]) {
                    unitItem.UnitNo = [set stringForColumn:@"UnitNo"];

                }
                
            }
            
            if (unitItem.UnitNo == nil ||[unitItem.UnitNo isEqualToString:@""]) {
                FMResultSet *set = [db executeQueryWithFormat:@"SELECT UnitNo, \
                                    UnitRegcode \
                                    FROM t_Units,(SELECT BuildingNo,BuildingName,BuildingAddr FROM t_Building WHERE SupervisorNo IN (%@) ) T1 \
                                    WHERE t_Units.BuildingNo = T1.BuildingNo \
                                    AND  UnitNo=%@ ;",[SZTable_UserSupervisor supervisorsStr],item.UNIT_NO];
                
                while ([set next]) {
                    unitItem.UnitNo = [set stringForColumn:@"UnitNo"];
                }

            }
            
        }
        
        
    }];
    
    return unitItem;
    
}



/**
 *  计划外维保电梯（二级页面）
 */
+(NSArray *)queryOutsidePlanMaintenanceUnitsWithOutsidePlanMaintenanceItem:(SZFinalOutsidePlanMaintenanceItem *)item{
    
    NSMutableArray *arrayData = [NSMutableArray array];
    
    NSInteger Mondaytime = [NSDate sinceDistantPastToDate:[NSDate thisWeekMondayOrNextSunday:@"Monday"]];
    NSInteger Sundaytime = [NSDate sinceDistantPastToDate:[NSDate thisWeekMondayOrNextSunday:@"Sunday"]];
    
    [OTISDB inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"SELECT ScheduleID, \
                         UnitNo, \
                         Times, \
                         CheckDate,CardType \
                         FROM   t_Schedules \
                         WHERE  IsComplete != 3 AND t_Schedules.CheckDate <= %ld AND t_Schedules.CheckDate >= %ld AND \
                         UnitNo in (SELECT UnitNo FROM t_Units WHERE BuildingNo='%@') ",(long)Sundaytime,(long)Mondaytime,item.BuildingNo];
        FMResultSet *set = [db executeQuery:sql];
        while ([set next]) {
            
            SZFinalMaintenanceUnitItem *unitItem = [[SZFinalMaintenanceUnitItem alloc] init];
            unitItem.UnitNo = [set stringForColumn:@"UnitNo"];
            unitItem.Times = [set intForColumn:@"Times"];
            unitItem.CheckDate = [set longForColumn:@"CheckDate"];
            unitItem.CardType = [set intForColumn:@"CardType"];
            unitItem.BuildingName = item.BuildingName;
            unitItem.ScheduleID = [set intForColumn:@"ScheduleID"];
            unitItem.isFixMode = NO;
            NSString *sql2 = [NSString stringWithFormat:@"select UnitRegcode ,Route\
                             from t_Units \
                             where UnitNo = '%@' ",unitItem.UnitNo];
            FMResultSet *set2 = [db executeQuery:sql2];
            while ([set2 next]) {
                unitItem.UnitRegcode = [set2 stringForColumn:@"UnitRegcode"];
                unitItem.Route = [set2 stringForColumn:@"Route"];
            }
            
            [arrayData  addObject:unitItem];
        }
        
    }];
    
    return [NSArray arrayWithArray:arrayData];
}

/**
 *  工时里的
 */
+(NSArray *)queryGongshiOutsidePlanMaintenanceUnitsWithOutsidePlanMaintenanceItem:(SZFinalOutsidePlanMaintenanceItem *)item{
    
    NSMutableArray *arrayData = [NSMutableArray array];
    
//    NSInteger Mondaytime = [NSDate sinceDistantPastToDate:[NSDate thisWeekMondayOrNextSunday:@"Monday"]];
//    NSInteger Sundaytime = [NSDate sinceDistantPastToDate:[NSDate thisWeekMondayOrNextSunday:@"Sunday"]];
    
    [OTISDB inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"SELECT \
                         UnitNo,\
                         CardType, \
                         UnitRegcode ,\
                         Route \
                         FROM t_Units \
                         WHERE  RouteNo='%@' AND BuildingNo='%@' AND UnitStatus = 'Active' \
                         ORDER BY UnitNo ",item.RouteNo,item.BuildingNo];
        FMResultSet *set = [db executeQuery:sql];
        while ([set next]) {
            
            SZFinalMaintenanceUnitItem *unitItem = [[SZFinalMaintenanceUnitItem alloc] init];
            unitItem.UnitNo = [set stringForColumn:@"UnitNo"];
            unitItem.CardType = [set intForColumn:@"CardType"];
//            unitItem.CheckDate = [set longForColumn:@"CheckDate"];
            unitItem.BuildingName = item.BuildingName;
            unitItem.Route = [set stringForColumn:@"Route"];
            unitItem.isFixMode = NO;
            unitItem.UnitRegcode = [set stringForColumn:@"UnitRegcode"];

            
            NSString *sql2 = [NSString stringWithFormat:@"SELECT ScheduleID,Times,CheckDate\
                              FROM t_Schedules \
                              WHERE  UnitNo='%@' AND CardType=%d  AND RouteNo = '%@' ",unitItem.UnitNo,(int)unitItem.CardType,item.RouteNo];
            FMResultSet *set2 = [db executeQuery:sql2];
            while ([set2 next]) {
//                if ([item.RouteNo containsString:@"Suspend"]) {
//                    unitItem.ScheduleID = -1;
//                }else{
//                    unitItem.ScheduleID = [set2 intForColumn:@"ScheduleID"];
//                }
                unitItem.CheckDate = [set2 longForColumn:@"CheckDate"];
                unitItem.Times = [set2 intForColumn:@"Times"];
                unitItem.ScheduleID = [set2 intForColumn:@"ScheduleID"];


            }
            
            [arrayData  addObject:unitItem];
        }
        
    }];
    
    return [NSArray arrayWithArray:arrayData];
}

//------------------------------------------------------------------------------------------------------------------------------------------------


/**
 *  计算出JHA控制器标题的名字
 */
+(NSArray *)quaryTitleNameWithCardType:(NSInteger)cardType{
    
    NSMutableArray *arrayData = [NSMutableArray array];

    
    [OTISDB inDatabase:^(FMDatabase *db) {
        FMResultSet *set = [db executeQueryWithFormat:@"SELECT JhaTypeId,Name,CardType FROM t_JHA_TYPE WHERE CardType= %ld ORDER BY JhaTypeId;",(long)cardType];
        while ([set next]) {
            SZJHATitleItem *jhaItem = [[SZJHATitleItem alloc] init];
            jhaItem.title = [set stringForColumn:@"Name"];
            jhaItem.JhaTypeId = [set intForColumn:@"JhaTypeId"];
            BOOL ret = YES;
            for (SZJHATitleItem *item in arrayData) {
                if ([item.title isEqualToString:jhaItem.title]) {
                    ret = NO;
                }
            }
            
            if (ret) {
                [arrayData  addObject:jhaItem];
            }
            
        }
        
    }];
    if (arrayData.count == 0) {
        [arrayData removeAllObjects];
        [OTISDB inDatabase:^(FMDatabase *db) {
            FMResultSet *set = [db executeQueryWithFormat:@"SELECT JhaTypeId,Name,CardType FROM t_JHA_TYPE WHERE CardType=0 ORDER BY JhaTypeId;"];
            while ([set next]) {
                SZJHATitleItem *jhaItem = [[SZJHATitleItem alloc] init];
                jhaItem.title = [set stringForColumn:@"Name"];
                jhaItem.JhaTypeId = [set intForColumn:@"JhaTypeId"];
                
                BOOL ret = YES;
                for (SZJHATitleItem *item in arrayData) {
                    if ([item.title isEqualToString:jhaItem.title]) {
                        ret = NO;
                    }
                }
                
                if (ret) {
                    [arrayData  addObject:jhaItem];
                }
                
            }
            
        }];

    }
       
    return [NSArray arrayWithArray:arrayData];
    
}

/**
 *  计算出分组标题的名字
 */
+(NSArray *)quarySectionTitleNameWithJhaTypeId:(NSInteger)jhaTypeId{
    
    NSMutableArray *arrayData = [NSMutableArray array];
    
    
    [OTISDB inDatabase:^(FMDatabase *db) {
        FMResultSet *set = [db executeQueryWithFormat:@"SELECT  t_JHA_ITEM_TYPE.JhaItemType,\
                            t_JHA_ITEM_TYPE.Name AS Title,\
                            t_JHA_ITEM.JhaCode,\
                            t_JHA_ITEM.Name,\
                            t_JHA_ITEM.JhaCodeId\
                            FROM t_JHA_ITEM_TYPE,t_JHA_ITEM\
                            WHERE JhaTypeId= %ld AND t_JHA_ITEM.JhaItemType = t_JHA_ITEM_TYPE.JhaItemType;",(long)jhaTypeId];
        while ([set next]) {
            SZJHATitleItem *jhaItem = [[SZJHATitleItem alloc] init];
            jhaItem.title = [set stringForColumn:@"Title"];
            jhaItem.JhaItemType = [set intForColumn:@"JhaItemType"];
            jhaItem.JhaCode = [set stringForColumn:@"JhaCode"];
            jhaItem.Name = [set stringForColumn:@"Name"];
            jhaItem.JhaCodeId = [set intForColumn:@"JhaCodeId"];
            
            BOOL ret = YES;
            for (SZJHATitleItem *item in arrayData) {
                if (item.JhaCodeId == jhaItem.JhaCodeId) {
                    ret = NO;
                }
            }
            
            if (ret) {
                [arrayData  addObject:jhaItem];
            }

        }
        
    }];
    
    return [NSArray arrayWithArray:arrayData];
    
}



/**
 *  保存JHA项目
 */
+(void)storageJHAItemsWithSelectedJHAArray:(NSMutableArray *)selectedArray andDetialItem:(SZFinalMaintenanceUnitDetialItem *)unitDetialItem andIsFixItem:(BOOL)isFixItem{


    [OTISDB inDatabase:^(FMDatabase *db) {
        /**
         *  如果有一样的jhaCodeId，先删除再存储
         */
        NSString *strEmployeeID = [OTISConfig EmployeeID];
        
        NSInteger scheduleID = unitDetialItem.ScheduleID;
        
        [db executeUpdateWithFormat:@"delete \
                                    from t_JHA_USER_SELECTED_SCHEDULE_ITEM \
                                    WHERE ScheduleId = %ld AND EmployeeId = %@ AND IsFixItem=%d;",(long)scheduleID,strEmployeeID,isFixItem];

        for (SZJHATitleItem *item in selectedArray) {
            
       BOOL ret = [db executeUpdateWithFormat:@"INSERT INTO t_JHA_USER_SELECTED_SCHEDULE_ITEM \
                                (IsFixItem,EmployeeId, ScheduleId, JhaCodeId,Other) \
                                VALUES (%d,%@,%ld,%ld,%@);",
                            isFixItem,strEmployeeID,(long)scheduleID,(long)item.JhaCodeId,item.Other];
            SZLog(@"item.Other:%@",item.Other);
            if (ret) {

            }else{
                SZLog(@"错误：t_JHA_USER_SELECTED_SCHEDULE_ITEM表插入数据失败！！！");
            }
        }
        
        
    }];
}

/**
 *  统计某部电梯保养计划的已经完成的JHA项目
 */
+(NSArray *)quaryCompetedJHAArrayWithDetialItem:(SZFinalMaintenanceUnitDetialItem *)unitDetialItem andIsFixItem:(BOOL)isFixItem{
    
    NSMutableArray *arrayData = [NSMutableArray array];
    
    NSString *strEmployeeID = [OTISConfig EmployeeID];
    
    NSInteger scheduleID = unitDetialItem.ScheduleID;
    
    [OTISDB inDatabase:^(FMDatabase *db) {
        FMResultSet *set = [db executeQueryWithFormat:@"\
                            SELECT EmployeeId, ScheduleId, t_JHA_ITEM.JhaCodeId,t_JHA_ITEM.JhaItemType,t_JHA_ITEM.JhaCode,t_JHA_ITEM.Name,Other\
                            FROM t_JHA_USER_SELECTED_SCHEDULE_ITEM,t_JHA_ITEM\
                            WHERE ScheduleId=%ld AND\
                                  EmployeeId=%@ AND\
                                  t_JHA_USER_SELECTED_SCHEDULE_ITEM.JhaCodeId= t_JHA_ITEM.JhaCodeId AND \
                                  IsFixItem=%d;",
                            (long)scheduleID,strEmployeeID,isFixItem];
        while ([set next]) {
            SZJHATitleItem *jhaItem = [[SZJHATitleItem alloc] init];
            jhaItem.title = [set stringForColumn:@"Name"];
            jhaItem.JhaCode = [set stringForColumn:@"JhaCode"];
            jhaItem.Name = [set stringForColumn:@"Name"];
            jhaItem.Other = [set stringForColumn:@"Other"];
            jhaItem.JhaCodeId = [set intForColumn:@"JhaCodeId"];
            jhaItem.JhaItemType = [set intForColumn:@"JhaItemType"];
            jhaItem.select = YES;
            [arrayData  addObject:jhaItem];
            
        }
        
    }];
    
    return [NSArray arrayWithArray:arrayData];
    
}
//------------------------------------------------------------------------------------------------------------------------------------------------
/**
 *  查询保养项目半月
 */
+(NSArray *)quaryMaintenanceItemWithDetialItem:(SZFinalMaintenanceUnitDetialItem *)unitDetialItem andTimeType:(OTISMaintenanceItemTimeType)type{


    NSMutableArray *arrayData = [NSMutableArray array];
    
    //NSDictionary *dic = [SZTable_REPORT_ITEM_COMPLETE_STATE queryItemCodeOtherWithScheduleId:(int)(unitDetialItem.ScheduleID)];

    [OTISDB inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"\
                                SELECT  t_CheckItem.ItemCode as code,\
                                    ItemName,\
                                    Description,\
                                    Type,\
                                    IsStandard,\
                                    IsSafetyItem\
                                FROM   t_CheckItem ,(SELECT ItemCode,CardType FROM t_ScheduleCheckItem WHERE CardType=%ld AND Times=%ld) AS T1\
                                WHERE  T1.ItemCode =t_CheckItem.ItemCode AND T1.CardType=t_CheckItem.CardType AND Type = 12\
                            UNION\
                                SELECT\
                                    ItemCode,\
                                    ItemName,\
                                    Description,\
                                    Type,\
                                    IsStandard,\
                                    IsSafetyItem\
                                FROM t_CheckItem\
                                WHERE t_CheckItem.CardType= %ld AND Type=%ld ORDER BY ItemCode;",
                         (long)unitDetialItem.CardType,(long)unitDetialItem.Times,(long)unitDetialItem.CardType,(long)type];
        SZLog(@"SQL 查询保养项目半月:%@",sql);
        FMResultSet *set = [db executeQuery:sql];
        
        while ([set next]) {
            SZMaintenanceCheckItem *checkItem = [[SZMaintenanceCheckItem alloc] init];
            checkItem.ItemCode = [set stringForColumn:@"code"];
            checkItem.ItemName = [set stringForColumn:@"ItemName"];
            checkItem.Type = [set intForColumn:@"Type"];
            checkItem.Description = [set stringForColumn:@"Description"];
            checkItem.IsStandard = [set intForColumn:@"IsStandard"];
            checkItem.IsSafetyItem = [set intForColumn:@"IsSafetyItem"];
            checkItem.state = 99;

//            if ([dic objectForKey:checkItem.ItemCode]) {
//                continue;
//            }
            [arrayData  addObject:checkItem];
        }
    }];
    

    return [NSArray arrayWithArray:arrayData];

}

/**
 *  查找所有的维修换件
 */
+(NSMutableDictionary *)quaryMaintenanceItemFixWithDetialItem:(SZFinalMaintenanceUnitDetialItem *)unitDetialItem {
    
    NSMutableDictionary *dicFix = [NSMutableDictionary dictionary];
    
    [OTISDB inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@" SELECT ItemCode, State \
                         FROM t_FIX_DOWNLOAD \
                         WHERE ScheduleId = %ld  ;",
                         unitDetialItem.ScheduleID];
        SZLog(@"--%@",sql);
        FMResultSet *set = [db executeQuery:sql];
        while ([set next]) {
            SZMaintenanceCheckItem *checkItem = [[SZMaintenanceCheckItem alloc] init];
            checkItem.ItemCode = [set stringForColumn:@"ItemCode"];
            checkItem.state = [set intForColumn:@"State"];
            [dicFix setObject:@(checkItem.state) forKey:checkItem.ItemCode];
        }
    }];
    return dicFix;
    
}

/**
 *  查询保养项目季度和半年
 */
+(NSArray *)quaryOtherMaintenanceItemWithDetialItem:(SZFinalMaintenanceUnitDetialItem *)unitDetialItem andTimeType:(OTISMaintenanceItemTimeType)type{
    
    
    NSMutableArray *arrayData = [NSMutableArray array];
    
    //NSDictionary *dic = [SZTable_REPORT_ITEM_COMPLETE_STATE queryItemCodeOtherWithScheduleId:(int)(unitDetialItem.ScheduleID)];

    [OTISDB inDatabase:^(FMDatabase *db) {
        FMResultSet *set = [db executeQueryWithFormat:@"SELECT\
                            ItemCode,\
                            ItemName,\
                            Description,\
                            Type,\
                            IsStandard,\
                            IsSafetyItem\
                            FROM t_CheckItem,(SELECT ItemCode AS T1_ITEM_CODE,CardType AS T1_CARD_TYPE \
                                            FROM t_ScheduleCheckItem WHERE CardType= %ld AND Times= %ld) AS T1 \
                            WHERE  T1.T1_ITEM_CODE =t_CheckItem.ItemCode AND \
                            T1.T1_CARD_TYPE=t_CheckItem.CardType  AND \
                            type=%ld;",
                            (long)unitDetialItem.CardType,(long)unitDetialItem.Times,(long)type];
        
        while ([set next]) {
            SZMaintenanceCheckItem *checkItem = [[SZMaintenanceCheckItem alloc] init];
            checkItem.ItemCode = [set stringForColumn:@"ItemCode"];
            checkItem.ItemName = [set stringForColumn:@"ItemName"];
            checkItem.Type = [set intForColumn:@"Type"];
            checkItem.Description = [set stringForColumn:@"Description"];
            checkItem.IsStandard = [set intForColumn:@"IsStandard"];
            checkItem.IsSafetyItem = [set intForColumn:@"IsSafetyItem"];
            checkItem.state = 99;

//            if ([dic objectForKey:checkItem.ItemCode]) {
//                continue;
//            }

            [arrayData  addObject:checkItem];
            
        }
        
    }];
    
    return [NSArray arrayWithArray:arrayData];
    
}
/**
 *  查询保养项目年度
 */
+(NSArray *)quaryOtherMaintenanceItemWithDetialItem:(SZFinalMaintenanceUnitDetialItem *)unitDetialItem andShowYear:(BOOL)ret{
    
    
    NSMutableArray *arrayData = [NSMutableArray array];
    
//    NSDictionary *dic = [SZTable_REPORT_ITEM_COMPLETE_STATE queryItemCodeOtherWithScheduleId:(int)(unitDetialItem.ScheduleID)];

    // 地铁中电梯存在CardType＝33的电梯，Type的值属于每年一次的范围，但是
    // Type时－1表示年检钱一个月，－2为年间前两个月
    [OTISDB inDatabase:^(FMDatabase *db) {
        NSString *sql = @"";
        if (ret) {// 年间列表
            
            if(unitDetialItem.CardType == 33){
                sql = [NSString stringWithFormat:@"\
                       SELECT\
                           ItemCode,\
                           ItemName,\
                           Description,\
                           Type,\
                           IsStandard,\
                           IsSafetyItem,\
                           0 AS IS_ONCE_YEAR\
                       FROM t_CheckItem ,(SELECT ItemCode AS T1_ITEM_CODE,CardType AS T1_CARD_TYPE \
                       FROM t_ScheduleCheckItem \
                       WHERE CardType=%ld AND TIMES=%ld) AS T1\
                       WHERE  T1.T1_ITEM_CODE =t_CheckItem.ItemCode AND T1.T1_CARD_TYPE=t_CheckItem.CardType  AND Type=1\
                    UNION\
                       SELECT \
                           ItemCode,\
                           ItemName,\
                           Description,\
                           Type,\
                           IsStandard,\
                           IsSafetyItem,\
                           1 AS IS_ONCE_YEAR\
                       FROM t_CheckItem\
                       WHERE t_CheckItem.CardType=%ld AND (Type=0 OR Type=-1 OR Type=-2 ) \
                       ORDER BY ItemCode;",
                       (long)unitDetialItem.CardType,(long)unitDetialItem.Times,(long)unitDetialItem.CardType];
            }else {
                sql = [NSString stringWithFormat:@"\
                        SELECT\
                           ItemCode,\
                           ItemName,\
                           Description,\
                           Type,\
                           IsStandard,\
                           IsSafetyItem,\
                           0 AS IS_ONCE_YEAR\
                        FROM t_CheckItem ,(SELECT ItemCode AS T1_ITEM_CODE,CardType AS T1_CARD_TYPE \
                                              FROM t_ScheduleCheckItem \
                                              WHERE CardType=%ld AND TIMES=%ld) AS T1\
                        WHERE  T1.T1_ITEM_CODE =t_CheckItem.ItemCode AND T1.T1_CARD_TYPE=t_CheckItem.CardType  AND Type=1\
                    UNION\
                        SELECT \
                           ItemCode,\
                           ItemName,\
                           Description,\
                           Type,\
                           IsStandard,\
                           IsSafetyItem,\
                           1 AS IS_ONCE_YEAR\
                        FROM t_CheckItem\
                        WHERE t_CheckItem.CardType=%ld AND Type=0 \
                        ORDER BY ItemCode;",
                       (long)unitDetialItem.CardType,(long)unitDetialItem.Times,(long)unitDetialItem.CardType];
            }
        }else{
            sql = [NSString stringWithFormat:@"\
                    SELECT\
                        ItemCode,\
                        ItemName,\
                        Description,\
                        Type,\
                        IsStandard,\
                        IsSafetyItem,\
                        0 AS IS_ONCE_YEAR\
                    FROM t_CheckItem ,( SELECT ItemCode AS T1_ITEM_CODE,CardType AS T1_CARD_TYPE \
                                        FROM t_ScheduleCheckItem \
                                        WHERE CardType=%ld AND TIMES=%ld) AS T1\
                    WHERE  T1.T1_ITEM_CODE =t_CheckItem.ItemCode AND T1.T1_CARD_TYPE=t_CheckItem.CardType  AND Type=1\
                UNION\
                    SELECT \
                        ItemCode,\
                        ItemName,\
                        Description,\
                        Type,\
                        IsStandard,\
                        IsSafetyItem,\
                        1 AS IS_ONCE_YEAR\
                    FROM t_CheckItem\
                    WHERE t_CheckItem.CardType=%ld) \
                    ORDER BY ItemCode;",
                   (long)unitDetialItem.CardType,(long)unitDetialItem.Times,(long)unitDetialItem.CardType];
        
        }
        
        SZLog(@"SQL 年保养项目：%@",sql);
        FMResultSet *set = [db executeQuery:sql];
        while ([set next]) {
            SZMaintenanceCheckItem *checkItem = [[SZMaintenanceCheckItem alloc] init];
            checkItem.ItemCode = [set stringForColumn:@"ItemCode"];
            checkItem.ItemName = [set stringForColumn:@"ItemName"];
            checkItem.Type = [set intForColumn:@"Type"];
            checkItem.Description = [set stringForColumn:@"Description"];
            checkItem.IsStandard = [set intForColumn:@"IsStandard"];
            checkItem.IsSafetyItem = [set intForColumn:@"IsSafetyItem"];
            checkItem.state = 99;

//            if ([dic objectForKey:checkItem.ItemCode]) {
//                continue;
//            }
            
            [arrayData  addObject:checkItem];
            
        }
        
    }];
    
    return [NSArray arrayWithArray:arrayData];
    
}

/**
 *  保存保养项目t_REPORT_ITEM_COMPLETE_STATE
 */
+(void)storageCompletedMaintenanceItemWithArray:(NSMutableArray *)selectedArray andDetialItem:(SZFinalMaintenanceUnitDetialItem *)unitDetialItem{
    
    
    [OTISDB inDatabase:^(FMDatabase *db) {
        /**
         *  如果有一样的jhaCodeId，先删除再存储
         */
        NSString *strEmployeeID = [OTISConfig EmployeeID];
        
        NSInteger scheduleID = unitDetialItem.ScheduleID;
        
        [db executeUpdateWithFormat:@"delete from t_REPORT_ITEM_COMPLETE_STATE \
                                        WHERE ScheduleId = %ld AND EmployeeId = %@ AND isUpload = 0;",
                                    (long)scheduleID,strEmployeeID];
    
        NSMutableString *sql = [NSMutableString stringWithFormat:@"%@", @"REPLACE INTO t_REPORT_ITEM_COMPLETE_STATE (ItemCode,State,EmployeeID,ScheduleId,isUpload) VALUES "];
        
        for (NSInteger i =0; i<selectedArray.count; i++) {
                SZMaintenanceCheckItem *item = selectedArray[i];
                NSString *strSqlSuffix = [NSString stringWithFormat:@"('%@', %d,'%@',%ld,%d),",item.ItemCode,item.state,strEmployeeID,(long)scheduleID,0];
                [sql appendString:strSqlSuffix];
                
            }
        
            [sql deleteCharactersInRange:NSMakeRange([sql length]-1, 1)];
            NSLog(@"SQL 保存保养项目：%@",sql);
            BOOL a = [db executeUpdate:sql];
            if (!a) {
                NSLog(@"错误：保存保养项目 t_REPORT_ITEM_COMPLETE_STATE插入失败2");
            }
    }];
}



/**
 *  统计已经完成的保养项目
 */
+(NSMutableDictionary *)quaryCompletedMaintenanceItemWithDetialItem:(SZFinalMaintenanceUnitDetialItem *)unitDetialItem{
    
    NSMutableDictionary *arrayDic = [NSMutableDictionary dictionary];
    
    NSInteger scheduleID = unitDetialItem.ScheduleID;
    
    [OTISDB inDatabase:^(FMDatabase *db) {
        // 统计已经完成的保养项目的时候，将别人已经做的也统计进来
        // 计算保养项目的时候，计算所有保养项目
        NSString *sql = [NSString stringWithFormat:@"SELECT ItemCode, State,isUpload\
                         FROM t_REPORT_ITEM_COMPLETE_STATE\
                         WHERE ScheduleId=%ld; ",(long)scheduleID];
        FMResultSet *set = [db executeQuery:sql];
        while ([set next]) {
            SZMaintenanceCheckItem *checkItem = [[SZMaintenanceCheckItem alloc] init];
            checkItem.ItemCode = [set stringForColumn:@"ItemCode"];
            checkItem.state = [set intForColumn:@"State"];
            checkItem.isUpload = [set intForColumn:@"isUpload"];
     
            [arrayDic  setObject:checkItem forKey:checkItem.ItemCode];
        }
        
    }];
    
    return arrayDic;
    
}
 

/**
 *  统计已经完成的保养项目
 */
+(NSArray *)quaryCompletedMaintenanceWithDetialItem:(SZFinalMaintenanceUnitDetialItem *)unitDetialItem{
    
    NSMutableArray *arrayData = [NSMutableArray array];
    
    NSString *strEmployeeID = [OTISConfig EmployeeID];
    
    NSInteger scheduleID = unitDetialItem.ScheduleID;
    
    [OTISDB inDatabase:^(FMDatabase *db) {
        FMResultSet *set = [db executeQueryWithFormat:@"SELECT t_REPORT_ITEM_COMPLETE_STATE.ItemCode, \
                            t_CheckItem.ItemName, \
                            t_CheckItem.Type, \
                            t_CheckItem.Description, \
                            t_CheckItem.IsStandard, \
                            t_CheckItem.IsSafetyItem, \
                            t_REPORT_ITEM_COMPLETE_STATE.State \
                            FROM t_REPORT_ITEM_COMPLETE_STATE,t_CheckItem \
                            WHERE ScheduleId=%ld AND t_CheckItem.ItemCode = t_REPORT_ITEM_COMPLETE_STATE.ItemCode AND \
                            EmployeeId=%@ ;",(long)scheduleID,strEmployeeID];
        while ([set next]) {
            SZMaintenanceCheckItem *checkItem = [[SZMaintenanceCheckItem alloc] init];
            checkItem.ItemCode = [set stringForColumn:@"ItemCode"];
            checkItem.ItemName = [set stringForColumn:@"ItemName"];
            checkItem.state = [set intForColumn:@"State"];
            checkItem.Description = [set stringForColumn:@"Description"];
            checkItem.IsStandard = [set intForColumn:@"IsStandard"];
            checkItem.IsSafetyItem = [set intForColumn:@"IsSafetyItem"];
            checkItem.Type = [set intForColumn:@"Type"];

            [arrayData  addObject:checkItem];
        }
    }];
    
    return [NSArray arrayWithArray:arrayData];
    
}

//------------------------------------------------------------------------------------------------------------------------------------------------


/**
 *  本公司维保电梯数据
 *
 *  @param params 请求参数
 */
+(NSArray *)queryTheCompanyMaintenanceElevators{
    
    NSMutableArray *arrayData = [NSMutableArray array];

    [OTISDB inDatabase:^(FMDatabase *db) {
        FMResultSet *set = [db executeQueryWithFormat:@"\
                            SELECT  t_Building.BuildingNo,\
                                    Route,BuildingName ,\
                                    BuildingAddr ,\
                                    T3.COUNT_BUILDING_UNIT \
                            FROM t_Building ,(  SELECT BuildingNo,sum( T2.COUNT_UNIT_NO) as COUNT_BUILDING_UNIT \
                                                FROM (  SELECT BuildingNo, COUNT_UNIT_NO \
                                                        FROM t_Units,(SELECT UnitNo, count(UnitNo) AS 'COUNT_UNIT_NO' FROM t_Schedules GROUP BY UnitNo ) AS T1\
                                                        WHERE	T1.UnitNo = t_Units.UnitNo ) AS T2 group by BuildingNo) AS T3\
                            WHERE T3.BuildingNo=t_Building.BuildingNo \
                                  AND t_Building.SupervisorNo IN (%@) ;",
                            [SZTable_UserSupervisor supervisorsStr]];
        
        while ([set next]) {
            SZFinalOutsidePlanMaintenanceItem *outside = [[SZFinalOutsidePlanMaintenanceItem alloc] init];
            outside.BuildingName = [set stringForColumn:@"BuildingName"];
            outside.Route = [set stringForColumn:@"Route"];
            outside.BuildingAddr = [set stringForColumn:@"BuildingAddr"];
            outside.unitCount = [NSString stringWithFormat:@"%d",[set intForColumn:@"COUNT_BUILDING_UNIT"]];
            outside.BuildingNo = [set stringForColumn:@"BuildingNo"];
            
            [arrayData  addObject:outside];
            
        }
        
    }];
    
    return [NSArray arrayWithArray:arrayData];
}
/**
 *  本公司维保电梯数据（二级页面）
 */
+(NSArray *)queryTheCompanyMaintenanceElevatorsWithOutsidePlanMaintenanceItem:(SZFinalOutsidePlanMaintenanceItem *)item{
    
    NSMutableArray *arrayData = [NSMutableArray array];

    
    [OTISDB inDatabase:^(FMDatabase *db) {
        
        FMResultSet *set = [db executeQueryWithFormat:@"\
                            SELECT ScheduleID,\
                                UnitNo,\
                                Times,\
                                CheckDate,CardType\
                            FROM  t_Schedules\
                            WHERE UnitNo in (SELECT UnitNo FROM t_Units WHERE BuildingNo=%@);",item.BuildingNo];
        while ([set next]) {
            
            SZFinalMaintenanceUnitItem *unitItem = [[SZFinalMaintenanceUnitItem alloc] init];
            unitItem.UnitNo = [set stringForColumn:@"UnitNo"];
            unitItem.Times = [set intForColumn:@"Times"];
            unitItem.CheckDate = [set longForColumn:@"CheckDate"];
            unitItem.CardType = [set intForColumn:@"CardType"];
            unitItem.BuildingName = item.BuildingName;
            unitItem.Route = item.Route;
            unitItem.ScheduleID = [set intForColumn:@"ScheduleID"];
            
            [arrayData  addObject:unitItem];
        }
        
    }];
    
    return [NSArray arrayWithArray:arrayData];
}
//------------------------------------------------------------------------------------------------------------------------------------------------

/**
 *  年检查询
 */
+(NSArray *)queryYearCheckItem{
    
    NSMutableArray *arrayData = [NSMutableArray array];
    
    NSString *strEmployeeID = [OTISConfig EmployeeID];

    [OTISDB inDatabase:^(FMDatabase *db) {
        
        FMResultSet *set = [db executeQueryWithFormat:@"\
                            SELECT  UnitNo, t_Units.Route,YCheckDate,BuildingName,t_Units.CardType \
                            FROM t_Units,t_Building \
                            WHERE   RouteNo IN (SELECT RouteNo FROM t_UserRoute WHERE EmployeeID = %@) AND \
                                    t_Units.CurrentStatus=0 AND \
                                    YCheckDate>0 AND \
                                    t_Units.BuildingNo=t_Building.BuildingNo AND t_Units.UnitStatus = 'Active'\
                            ORDER BY YCheckDate,t_Units.UnitNo;",strEmployeeID];
        //ORDER BY YCheckDate,t_Units.BuildingNo;",strEmployeeID];
        while ([set next]) {
            
            SZFinalMaintenanceUnitItem *unitItem = [[SZFinalMaintenanceUnitItem alloc] init];
            unitItem.UnitNo = [set stringForColumn:@"UnitNo"];
            unitItem.YCheckDate = [set longForColumn:@"YCheckDate"];
            unitItem.CardType = [set intForColumn:@"CardType"];
            unitItem.BuildingName = [set stringForColumn:@"BuildingName"];
            unitItem.Route = [set stringForColumn:@"Route"];
            
            [arrayData  addObject:unitItem];
        }
        
    }];
    
    
    
    return [NSArray arrayWithArray:arrayData];
}
/**
 *  年检查询（二级页面）
 */
+(SZFinalMaintenanceUnitDetialItem *)queryYearCheckDetialItemWithUnitNo:(NSString *)unitNo{
    
    
    SZFinalMaintenanceUnitDetialItem *unitItem = [[SZFinalMaintenanceUnitDetialItem alloc] init];
    
    [OTISDB inDatabase:^(FMDatabase *db) {
        
        FMResultSet *set = [db executeQueryWithFormat:@"\
                            SELECT  t_Units.UnitNo,\
                                    t_Units.ModelType,\
                                    t_Units.CardType,\
                                    t_Units.Route,\
                                    t_Units.Owner,\
                                    t_Units.Tel,\
                                    t_Units.YCheckDate ,\
                                    t_Building.BuildingAddr,\
                                    t_Building.BuildingName\
                            FROM  t_Units,t_Building\
                            WHERE t_Units.BuildingNo = t_Building.BuildingNo\
                                  AND UnitNo = %@;",unitNo];
        
        while ([set next]) {

            unitItem.UnitNo = [set stringForColumn:@"UnitNo"];
            unitItem.ModelType = [set stringForColumn:@"ModelType"];
            unitItem.YCheckDate = [set longForColumn:@"YCheckDate"];
            unitItem.CardType = [set intForColumn:@"CardType"];
            unitItem.BuildingName = [set stringForColumn:@"BuildingName"];
            unitItem.Route = [set stringForColumn:@"Route"];

            unitItem.Owner = [set stringForColumn:@"Owner"];

            unitItem.Tel = [set stringForColumn:@"Tel"];
            unitItem.BuildingAddr = [set stringForColumn:@"BuildingAddr"];


        }
        
    }];
    
    return unitItem;
}

//------------------------------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------------------------------
/**
 *  客户签字列表
 */
+(NSArray *)querySignList{

    NSMutableArray *arrayData = [NSMutableArray array];
    
    NSArray *arrayRoutNos = [SZTable_UserRoute routNos];
    
    NSString *strRoutes = [arrayRoutNos componentsJoinedByString:@","];
    
    [OTISDB inDatabase:^(FMDatabase *db) {
        
        NSString *sql = [NSString stringWithFormat:@"\
                         SELECT t_Report.ScheduleID, \
                                t_Building.BuildingNo, \
                                t_Schedules.UnitNo, \
                                t_Schedules.CheckDate, \
                                Times, \
                                t_Units.CardType, \
                                t_Building.BuildingName \
                         FROM t_Report, t_Schedules, t_Units, t_Building \
                         WHERE ( (t_Schedules.IsComplete = 2  AND (AddLaborHoursState=0 OR AddLaborHoursState=2) ) OR \
                                 (t_Report.ScheduleID IN (SELECT ScheduleID FROM t_Signature WHERE IsAbsent = 1 AND Signature  is not null)) \
                                  AND  t_Schedules.RouteNo in ('%@')  \
                               ) \
                               AND IsRepairItem=0 \
                               AND t_Schedules.ScheduleID = t_Report.ScheduleID \
                               AND t_Schedules.UnitNo = t_Units.UnitNo \
                               AND t_Building.BuildingNo = t_Units.BuildingNo \
                         ORDER BY t_Schedules.CheckDate, t_Building.BuildingNo",
                         strRoutes];
        SZLog(@"SQL 签字列表：%@",sql);
        FMResultSet *set = [db executeQuery:sql];
        while ([set next]) {
            
            SZFinalMaintenanceUnitItem *unitItem = [[SZFinalMaintenanceUnitItem alloc] init];
            unitItem.UnitNo = [set stringForColumn:@"UnitNo"];
            unitItem.ScheduleID = [set intForColumn:@"ScheduleID"];
            unitItem.BuildingNo = [set intForColumn:@"BuildingNo"];
            unitItem.CheckDate = [set longForColumn:@"CheckDate"];
            unitItem.CardType = [set intForColumn:@"CardType"];
            unitItem.Times = [set intForColumn:@"Times"];
            unitItem.BuildingName = [set stringForColumn:@"BuildingName"];
            
            [arrayData  addObject:unitItem];
        }
        
    }];
    
    return [NSArray arrayWithArray:arrayData];

}

+(NSArray *)queryTheGongShiGongdiList{
    
    NSMutableArray *arrayData = [NSMutableArray array];
    
    [OTISDB inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"\
                         SELECT  UnitNo, \
                                 CardType , \
                                 t_Units.BuildingNo, \
                                 t_Units.RouteNo, \
                                 t_Units.Route, \
                                 T1.BuildingName , \
                                 T1.BuildingAddr , \
                                 count(t_Units.BuildingNo) AS COUNT_BUILDING_UNIT \
                         FROM t_Units,(SELECT BuildingNo,BuildingName,BuildingAddr FROM t_Building WHERE SupervisorNo IN (%@) ) T1 \
                         WHERE t_Units.BuildingNo = T1.BuildingNo AND UnitStatus = 'Active' \
                         GROUP BY t_Units.BuildingNo ,t_Units.RouteNo \
                         ORDER BY t_Units.BuildingNo ;",[SZTable_UserSupervisor supervisorsStr]];
        FMResultSet *set = [db executeQuery:sql];
        
        while ([set next]) {
            SZFinalOutsidePlanMaintenanceItem *outside = [[SZFinalOutsidePlanMaintenanceItem alloc] init];
            outside.BuildingName = [set stringForColumn:@"T1.BuildingName"];
            outside.Route = [set stringForColumn:@"t_Units.Route"];
            outside.RouteNo = [set stringForColumn:@"t_Units.RouteNo"];
            outside.BuildingAddr = [set stringForColumn:@"T1.BuildingAddr"];
            outside.unitCount = [NSString stringWithFormat:@"%d",[set intForColumn:@"COUNT_BUILDING_UNIT"]];
            outside.BuildingNo = [set stringForColumn:@"t_Units.BuildingNo"];
            
            [arrayData  addObject:outside];
            
        }
        
    }];
    
    return [NSArray arrayWithArray:arrayData];
}
//------------------------------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------------------------------

/**
 *  维保上传
 *
 *  @param params 请求参数
 */
+(NSArray *)queryMaintenanceUploadData{
    
    NSMutableArray *arrayData = [NSMutableArray array];
    
    NSString *strUserNo = [OTISConfig EmployeeID];
    NSString *strPassword = [OTISConfig userPW];
    NSString *strVersion = [NSString stringWithFormat:@"V%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];

    //IsAbsent 0客户存在，1客户不存在，2客户不存在后，上传完成状态
    [OTISDB inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"\
                         SELECT t_Report.ScheduleID, \
                             ItemDate, \
                             JhaDate, \
                             ItemPhoto, \
                             (LastStatus=1) AS IsAdjust, \
                             AdjustmentType, \
                             0 AS AdjustmentHour, \
                             Question , \
                             AdjustmentComment,\
                             IsAbsent, \
                             '' AS GroupID,  \
                             '' AS QRCode,  \
                             '' AS PhoneVersion, \
                             Question,  \
                             IsRepair, \
                             IsReplace, \
                             IsUploaded ,\
                             LastStatus \
                         FROM t_Report,t_Schedules\
                         WHERE  t_Report.ScheduleID=t_Schedules.ScheduleID AND \
                                t_Report.EmployeeID= '%@' AND IsRepairItem=0 AND \
                                ( (IsAbsent=1 AND IsUploaded=1) OR \
                                  (((IsUploaded=0 AND (LastStatus=0 OR LastStatus=1)) OR (AddLaborHoursState=2)) AND JhaDate!=0));",
                         [OTISConfig EmployeeID]];
        
        SZLog(@"SQL 维保上传%@",sql);
        FMResultSet *set = [db executeQuery:sql];
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        NSString *sql1 = [NSString stringWithFormat:@"\
                         SELECT t_Report.ScheduleID ,JhaDate\
                         FROM t_Report ,t_Schedules\
                         WHERE  t_Report.ScheduleID=t_Schedules.ScheduleID AND \
                                t_Report.EmployeeID= '%@' \
                                AND  (AddLaborHoursState=2) \
                                AND JhaDate!=0 AND (t_Report.LastStatus != 0 AND t_Report.LastStatus != 1 ) ;",[OTISConfig EmployeeID]];
        
        FMResultSet *set1 = [db executeQuery:sql1];
        while ([set1 next]) {
            int scheduleID = [set1 intForColumn:@"ScheduleID"];
            [dic setObject:@"" forKey:@(scheduleID)];
        }
 
        
        while ([set next]) {
            SZUploadMaintenancemRequest *maintenancemRequest = [[SZUploadMaintenancemRequest alloc] init];
            
            maintenancemRequest.Ver = APIVersion;
            maintenancemRequest.Checker = [OTISConfig EmployeeID];
            maintenancemRequest.UserNo = strUserNo;
            maintenancemRequest.Password = strPassword;
            if ([set longForColumn:@"ItemDate"] == 0) {
                maintenancemRequest.ItemDate = [NSString stringWithFormat:@"%ld",[set longForColumn:@"JhaDate"]];
                
            }else{
                maintenancemRequest.ItemDate = [NSString stringWithFormat:@"%ld",[set longForColumn:@"ItemDate"]];
                
            }
            
            maintenancemRequest.PhoneVersion = strVersion;
            if ([set stringForColumn:@"Question"]) {
                maintenancemRequest.Question = [set stringForColumn:@"Question"];
            }else{
                maintenancemRequest.Question = @"";
                
            }
            
            int IsUploaded = [set intForColumn:@"IsUploaded"];
            int IsAbsent = [set intForColumn:@"IsAbsent"];
            if(IsUploaded == 1 && IsAbsent==1){
                maintenancemRequest.IsAdjust = [NSString stringWithFormat:@"%d",[set intForColumn:@"IsAdjust"]];
                maintenancemRequest.IsRepair = [NSString stringWithFormat:@"%d",[set intForColumn:@"IsRepair"]];
                maintenancemRequest.IsReplace = [NSString stringWithFormat:@"%d",[set intForColumn:@"IsReplace"]];
                maintenancemRequest.IsOK = @"1";
                maintenancemRequest.ScheduleID = [NSString stringWithFormat:@"%d",[set intForColumn:@"ScheduleID"]];

                maintenancemRequest.JhaDate = @"";
                maintenancemRequest.ItemPhoto = @"";
                maintenancemRequest.Report = @"";
                maintenancemRequest.JHA = @"";
                maintenancemRequest.AdjustmentType = @"";
                maintenancemRequest.AdjustmentHour = 0 ;
                maintenancemRequest.Comment = @"";
                maintenancemRequest.IsAbsent = @"1";
                maintenancemRequest.operate = @"[]";
                maintenancemRequest.GroupID = @"";
                maintenancemRequest.AddHours = @"[]";
                maintenancemRequest.QRCode = @"";
                
                [arrayData  addObject:maintenancemRequest.mj_keyValues];

                
            }else{
            
                maintenancemRequest.Ver = APIVersion;
                maintenancemRequest.ScheduleID = [NSString stringWithFormat:@"%d",[set intForColumn:@"ScheduleID"]];
                maintenancemRequest.JhaDate = [NSString stringWithFormat:@"%ld",[set longForColumn:@"JhaDate"]];
                
                if ([[set stringForColumn:@"ItemPhoto"] isEqualToString:@"0"]||![set stringForColumn:@"ItemPhoto"]) {
                    maintenancemRequest.ItemPhoto = @"";
                    
                }else{
                    maintenancemRequest.ItemPhoto = [set stringForColumn:@"ItemPhoto"];
                    
                }
                
                maintenancemRequest.IsAdjust = [NSString stringWithFormat:@"%d",[set intForColumn:@"IsAdjust"]];
                maintenancemRequest.AdjustmentType = [set stringForColumn:@"AdjustmentType"];
                maintenancemRequest.AdjustmentHour = [NSString stringWithFormat:@"%d",[set intForColumn:@"AdjustmentHour"]];
                if ([set stringForColumn:@"AdjustmentComment"]) {
                    maintenancemRequest.Comment = [set stringForColumn:@"AdjustmentComment"];
                }else{
                    maintenancemRequest.Comment = @" ";
                    
                }
                maintenancemRequest.IsAbsent = [NSString stringWithFormat:@"%d",[set intForColumn:@"IsAbsent"]];
                
               
                if ([set stringForColumn:@"Question"]) {
                    maintenancemRequest.Question = [set stringForColumn:@"Question"];
                }else{
                    maintenancemRequest.Question = @"";
                    
                }
                
                
                maintenancemRequest.IsRepair = [NSString stringWithFormat:@"%d",[set intForColumn:@"IsRepair"]];
                maintenancemRequest.IsReplace = [NSString stringWithFormat:@"%d",[set intForColumn:@"IsReplace"]];
                maintenancemRequest.IsOK = @"1";
                
                
                /**
                 *  Report
                 */
                NSMutableArray *arrayReport = [NSMutableArray array];
                NSMutableArray *arrayDown = [NSMutableArray array];
                
                if (dic[@(maintenancemRequest.ScheduleID.intValue)]) {
                    
                    maintenancemRequest.Report = @"" ;
                    maintenancemRequest.ItemDate = maintenancemRequest.JhaDate;
                    
                }else{
                
                    
                    NSString *sql11 = [NSString stringWithFormat:@"SELECT CardType,Times FROM t_Schedules WHERE ScheduleID=%d;",maintenancemRequest.ScheduleID.intValue];
                    FMResultSet *setReport = [db executeQuery:sql11];
                    while ([setReport next]) {
                        
                        int CardType = [setReport intForColumn:@"CardType"];
                        
                        NSString *Times = [setReport stringForColumn:@"Times"];
                        //  查找所有空保养项目
                        NSString *sql1 = [NSString stringWithFormat:@"SELECT ItemCode \
                                          FROM t_ScheduleCheckItem \
                                          WHERE  CardType = %d AND  \
                                          Times = %@ AND  \
                                          ItemCode not in (SELECT  ItemCode FROM t_REPORT_ITEM_COMPLETE_STATE WHERE  ScheduleId= %d AND EmployeeID!= %@) \
                                          UNION \
                                          SELECT ItemCode \
                                          FROM  t_CheckItem \
                                          WHERE t_CheckItem.CardType = %d  AND  \
                                          (t_CheckItem.Type=24 ) AND\
                                          ItemCode not in (SELECT  ItemCode FROM t_REPORT_ITEM_COMPLETE_STATE WHERE  ScheduleId= %d AND EmployeeID!= %@) ;",CardType,Times,maintenancemRequest.ScheduleID.intValue,strUserNo,CardType,maintenancemRequest.ScheduleID.intValue,strUserNo];
                        //                SZLog(@"%@",sql1);
                        FMResultSet *setItemCode = [db executeQuery:sql1];
                        while ([setItemCode next]) {
                            SZReportItem *item = [[SZReportItem alloc] init];
                            item.Code = [setItemCode stringForColumn:@"ItemCode"];
                            item.State = 99;
                            //                    SZLog(@"00000%@",item.Code);
                            [arrayReport addObject:item];
                        }
                        // 所有已经完成的有状态的保养项目，并且是需要上传的保养项目
                        FMResultSet *setDown = [db executeQueryWithFormat:@"SELECT  ItemCode ,State FROM t_REPORT_ITEM_COMPLETE_STATE WHERE   ScheduleId=%d AND EmployeeID=%@;",maintenancemRequest.ScheduleID.intValue,strUserNo];
                        while ([setDown next]) {
                            SZReportItem *item = [[SZReportItem alloc] init];
                            item.Code = [setDown stringForColumn:@"ItemCode"];
                            item.State= [setDown intForColumn:@"State"];
                            [arrayDown addObject:item];
                        }
                        
                        
                    }
                    
                    NSMutableDictionary *dicReport = [NSMutableDictionary dictionary];
                    for (SZReportItem *item in arrayReport) {
                        
                        [dicReport setObject:item forKey:item.Code];
                    }
                    
                    for (SZReportItem *item in arrayDown) {
                        
                        [dicReport setObject:item forKey:item.Code];
                    }
                    NSMutableArray *arrayTempReport = [NSMutableArray array];
                    int sc = [(NSNumber *)[USER_DEFAULT objectForKey:[NSString stringWithFormat:@"%@_每年一次",maintenancemRequest.ScheduleID]] intValue];
                    //检查一下如果是全做完的（除了每年一次），有99项的要删掉
                    if (sc == maintenancemRequest.ScheduleID.intValue) {
                        NSMutableArray *arrayTempReport2 = [NSMutableArray array];

                        for (SZReportItem *item in dicReport.allValues) {
                            if (item.State != 99) {
                                [arrayTempReport2 addObject:item];
                            }
                        }
                        arrayTempReport = [SZReportItem mj_keyValuesArrayWithObjectArray:arrayTempReport2];

                    }else{
                        
                        arrayTempReport = [SZReportItem mj_keyValuesArrayWithObjectArray:dicReport.allValues];

                    }

                    if (arrayTempReport.count) {
                        maintenancemRequest.Report = [arrayTempReport mj_JSONString];
                    }else{
                        maintenancemRequest.Report = @"";
                    }
                    
                    
                }
                
                
              
                
               
                
                /**
                 *  JHA
                 */
                NSMutableArray *arrayJHA = [NSMutableArray array];
                NSString *sql2 = [NSString stringWithFormat:@"SELECT JhaCode,Other \
                                  FROM t_JHA_USER_SELECTED_SCHEDULE_ITEM, t_JHA_ITEM \
                                  WHERE EmployeeID= %@ AND ScheduleId = %d AND  \
                                        t_JHA_USER_SELECTED_SCHEDULE_ITEM.JhaCodeId = t_JHA_ITEM.JhaCodeId AND \
                                        IsFixItem=0;",strUserNo,maintenancemRequest.ScheduleID.intValue];
                SZLog(@"SQL 维保上传JHA:%@",sql2);
                FMResultSet *setJHA = [db executeQuery:sql2];
                while ([setJHA next]) {
                    SZJHAItem *item = [[SZJHAItem alloc] init];
                    NSString *strOther = [setJHA stringForColumn:@"Other"];
                    NSString *strCode = [setJHA stringForColumn:@"JhaCode"];
                    if (strOther) {
                        item.JHACode = [NSString stringWithFormat:@"%@-%@",strCode,strOther];
                    }else{
                        item.JHACode = strCode;
                    }
                    BOOL ret = NO;
                    for (SZJHAItem *item2 in arrayJHA) {
                        if ([item2.JHACode isEqualToString:item.JHACode]) {
                            ret = YES;
                        }
                    }
                    if (ret == NO) {
                        [arrayJHA addObject:item];
                    }

                }
                NSArray * arrayT = [SZJHAItem mj_keyValuesArrayWithObjectArray:arrayJHA];
                maintenancemRequest.JHA = [arrayT mj_JSONString] ;
                
                /**
                 *  Oprate
                 */
                NSMutableArray *arrayOprate = [NSMutableArray array];
                NSString *sql3 = [NSString stringWithFormat:@"\
                                  SELECT GroupID,QRCode,StratTime,EndTime,StartLon,StartLat,EndLon,EndLat,Property,Reason \
                                  FROM t_QRCode \
                                  WHERE EmployeeID= %@ AND \
                                        ScheduleId = %d AND \
                                        GroupID = 0 AND \
                                        IsFixItem=0;",strUserNo,maintenancemRequest.ScheduleID.intValue];
                //            SZLog(@"%@",sql3);
                
                FMResultSet *setOprate = [db executeQuery:sql3];
                while ([setOprate next]) {
                    maintenancemRequest.GroupID = [NSString stringWithFormat:@"%d",[set intForColumn:@"GroupID"]];
                    if ([setOprate stringForColumn:@"QRCode"]) {
                        maintenancemRequest.QRCode = [setOprate stringForColumn:@"QRCode"];
                        
                    }else{
                        maintenancemRequest.QRCode = @"";
                        
                    }
                    SZOprateItem *item = [[SZOprateItem alloc] init];
                    item.StartTime = [setOprate longForColumn:@"StratTime"];
                    item.EndTime = [setOprate longForColumn:@"EndTime"];
                    item.StartLocalX = [setOprate stringForColumn:@"StartLon"];
                    item.StartLocalY = [setOprate stringForColumn:@"StartLat"];
                    item.EndLocalX = [setOprate stringForColumn:@"EndLon"];
                    item.EndLocalY = [setOprate stringForColumn:@"EndLat"];
                    if (maintenancemRequest.IsAdjust.intValue == 1) {
                        item.Type = @"2";
                    }else{
                        item.Type = @"1";
                        
                    }
                    
                    item.Reason = [setOprate intForColumn:@"Reason"];
                    
                    [arrayOprate addObject:item];
                }
                NSArray * arrayTOprate = [SZOprateItem mj_keyValuesArrayWithObjectArray:arrayOprate];
                maintenancemRequest.operate = [arrayTOprate mj_JSONString];
                /**
                 *  AddHours
                 */
                NSMutableArray *arrayAddHours = [NSMutableArray array];
                NSString *sql4 = [NSString stringWithFormat:@"SELECT LaborTypeId,Hour1Rate,Hour15Rate,Hour2Rate,Hour3Rate,PUINo FROM t_LaborHours WHERE EmployeeID= %@ AND ScheduleId = %d AND GroupID = 0;",strUserNo,maintenancemRequest.ScheduleID.intValue];
                
                FMResultSet *setAddHours = [db executeQuery:sql4];
                while ([setAddHours next]) {
                    SZAddHoursItem *item = [[SZAddHoursItem alloc] init];
                    item.LaborTypeID = [setAddHours intForColumn:@"LaborTypeId"];
                    item.UploadHours1 = [setAddHours floatForColumn:@"Hour1Rate"];
                    item.UploadHours15 = [setAddHours floatForColumn:@"Hour15Rate"];
                    item.UploadHours2 = [setAddHours floatForColumn:@"Hour2Rate"];
                    item.UploadHours3 = [setAddHours floatForColumn:@"Hour3Rate"];
                    
                    if ([setAddHours stringForColumn:@"PUINo"]) {
                        item.PUINum = [setAddHours stringForColumn:@"PUINo"];
                    }else{
                        item.PUINum = @"";
                    }
                    
                    [arrayAddHours addObject:item];
                }
                
                /**
                 *  如果点击中断后没有填写中断原因且没有填工时，维保项不用上传
                 */
                if (([maintenancemRequest.AdjustmentType isEqualToString:@"0"]||maintenancemRequest.AdjustmentType == nil ||[maintenancemRequest.AdjustmentType isEqualToString:@""])&&[set intForColumn:@"LastStatus"] == 1 && arrayAddHours.count == 0) {
                    continue;
                }
                if (arrayAddHours.count&&maintenancemRequest.IsAdjust.integerValue != 1) {//上传工时
                    
                    NSMutableDictionary *dicReport = [NSMutableDictionary dictionary];
                    for (SZReportItem *item in arrayReport) {
                        
                        [dicReport setObject:item forKey:item.Code];
                    }
                    
                    for (SZReportItem *item in arrayDown) {
                        
                        [dicReport setObject:item forKey:item.Code];
                    }
                    NSMutableArray *arrayTempReport = [NSMutableArray array];
                    NSMutableArray *arrayTempReport2 = [NSMutableArray array];
                    
                    for (SZReportItem *item in dicReport.allValues) {
                        if (item.State != 99) {
                            [arrayTempReport2 addObject:item];
                        }
                    }
                    arrayTempReport = [SZReportItem mj_keyValuesArrayWithObjectArray:arrayTempReport2];
                    if (arrayTempReport.count) {
                        maintenancemRequest.Report = [arrayTempReport mj_JSONString];
                    }else{
                        maintenancemRequest.Report = @"";
                    }
                }
                
                NSArray * arrayTAddHours = [SZAddHoursItem mj_keyValuesArrayWithObjectArray:arrayAddHours];
                maintenancemRequest.AddHours = [arrayTAddHours mj_JSONString];
            
                [arrayData  addObject:maintenancemRequest.mj_keyValues];

            
            }
            
           
            
            
            
        }
        
    }];
    
    return [NSArray arrayWithArray:arrayData];
}


/**
 *  维修换件报告上传
 *
 *  @param params 请求参数
 */
+(NSArray *)queryFixUploadData{

    NSMutableArray *arrayData = [NSMutableArray array];
    
    NSString *strUserNo = [OTISConfig EmployeeID];
    NSString *strPassword = [OTISConfig userPW];
    
    
    [OTISDB inDatabase:^(FMDatabase *db) {
        NSString *sqlAll = [NSString stringWithFormat:@"SELECT \
                            ScheduleID, \
                            ItemDate, \
                            JhaDate, \
                            ItemPhoto, \
                            JhaDate \
                            FROM t_Report \
                            WHERE IsRepairItem=1 AND IsUploaded=0;"];
        SZLog(@"SQL 维修换件报告上传 %@",sqlAll);
        FMResultSet *set = [db executeQuery:sqlAll];
        
        while ([set next]) {
            if ([set longForColumn:@"ItemDate"] == 0) {
                continue;
            }
            SZUploadFixRequest *fixRequest = [[SZUploadFixRequest alloc] init];
            fixRequest.UserNo = strUserNo;
            fixRequest.Password = strPassword;
            fixRequest.Ver = APIVersion;
            fixRequest.ScheduleID = [NSString stringWithFormat:@"%d",[set intForColumn:@"ScheduleID"]];
            fixRequest.ItemDate = [NSString stringWithFormat:@"%ld",[set longForColumn:@"ItemDate"]];
            fixRequest.JhaDate = [NSString stringWithFormat:@"%ld",[set longForColumn:@"JhaDate"]];
            fixRequest.FixMan = [OTISConfig EmployeeID];
            fixRequest.ItemPhoto = [set stringForColumn:@"ItemPhoto"];
            fixRequest.JHAPhoto = @"";
            fixRequest.IsOK = @"1";
            /**
             *  Fix
             */
            NSMutableArray *arrayReport = [NSMutableArray array];
//            NSMutableArray *arrayDown = [NSMutableArray array];
            NSString *sqlReport = [NSString stringWithFormat:@"SELECT CardType,Times FROM t_Schedules WHERE ScheduleID=%d;",fixRequest.ScheduleID.intValue];
            FMResultSet *setReport = [db executeQuery:sqlReport];
            while ([setReport next]) {
                
                NSString *sqlFix = [NSString stringWithFormat:@"SELECT  ItemCode , State \
                                    FROM t_FIX_DOWNLOAD \
                                    WHERE  ScheduleId=%ld ;",
                                    (long)fixRequest.ScheduleID.intValue];
                FMResultSet *setItemCode = [db executeQuery:sqlFix];
                while ([setItemCode next]) {
                    SZReportItem *item = [[SZReportItem alloc] init];
                    item.Code = [setItemCode stringForColumn:@"ItemCode"];
                    item.State = [setItemCode intForColumn:@"State"];;
//                    SZLog(@"00000%@",item.Code);
                    [arrayReport addObject:item];
                }
                
                
            }


            NSArray *arrayTempReport = [SZReportItem mj_keyValuesArrayWithObjectArray:arrayReport];
            fixRequest.Fix = [arrayTempReport mj_JSONString];
        
            
            fixRequest.JHA = @"";
            
            [arrayData  addObject:fixRequest.mj_keyValues];
            
        }
        
    }];
    
    return [NSArray arrayWithArray:arrayData];


}


/**
 *  图片上传
 *
 *  @param params 请求参数
 */
+(NSArray *)queryUploadImageData{

    
    NSMutableArray *arrayData = [NSMutableArray array];
    
    
    [OTISDB inDatabase:^(FMDatabase *db) {
        
        FMResultSet *set = [db executeQueryWithFormat:@"SELECT ScheduleID, \
                            ItemPhoto \
                            FROM t_Report  \
                            WHERE IsUploaded =1 AND EmployeeID= %@ AND (LastStatus=0 OR LastStatus=1) AND ItemPhoto != '0';",[OTISConfig EmployeeID]];
        while ([set next]) {
            NSString *strPhoto = [set stringForColumn:@"ItemPhoto"];
            if (strPhoto.length>0) {
                
                NSString *strPath = [NSString stringWithFormat:@"%@_%d",[OTISConfig EmployeeID],[set intForColumn:@"ScheduleID"]];
                
                NSString *strPhoto = [set stringForColumn:@"ItemPhoto"];
                
                NSArray *arrayPhoto = [strPhoto componentsSeparatedByString:@";"];
                int i =0;
                for (NSString *strPhotoName in arrayPhoto) {
                    SZUploadMaintenancePicRequest *request = [[SZUploadMaintenancePicRequest alloc] init];
                    request.UserNo = [OTISConfig EmployeeID];
                    request.Password = [OTISConfig userPW];
                    request.Ver = APIVersion;
                    request.ScheduleID =[NSString stringWithFormat:@"%d",[set intForColumn:@"ScheduleID"]] ;
                    request.PicType = @"1";
                   
                    
                    NSArray *arrayDate = [strPhotoName componentsSeparatedByString:@"_"];
                    NSString *strDate = @"";
                    if (arrayDate.count>2) {
                        strDate = [arrayDate objectAtIndex:arrayDate.count-2];
                        if (strDate) {
                            NSDate *date = [NSDate dateFromString:strDate];
                            request.Date = [NSString stringWithFormat:@"%ld",(long)[NSDate sinceDistantPastToDate:date]];
                            
                        }else{
                            request.Date = @"";
                        }

                        request.PicName = strPhotoName;


                        request.Checker = [OTISConfig EmployeeID];
                        if (strPhotoName.length>0) {
                            NSString *str = [PicDataDir(strPath) stringByAppendingPathComponent:strPhotoName];
                            request.image = [UIImage imageWithContentsOfFile:str];
                        }
                        [arrayData addObject:request];
                    }
                   
                    i++;
                    
                }

            }
            

            
        }
        
    
        // 客户不在的情况下，不上传；IsAbsent=0 表示客户都在
        
        
       NSString *sql = [NSString stringWithFormat:@"SELECT ScheduleID, \
                                                                        SignDate, \
                                                                        Signature \
                                                                 FROM t_Signature  \
                                                                 WHERE  IsImageUploaded !=1 AND \
                                                                        EmployeeID= %@ AND \
                                                                        IsAbsent=0 AND \
                                                                        Signature !='' AND\
                                                                        Signature is not NULL;",
                                                                        [OTISConfig EmployeeID]];
        SZLog(@"SQL 查询上传签字图片:%@",sql);
        FMResultSet *setSignature = [db executeQuery:sql];
        while ([setSignature next]) {
            SZUploadMaintenancePicRequest *request = [[SZUploadMaintenancePicRequest alloc] init];
            request.UserNo = [OTISConfig EmployeeID];
            request.Password = [OTISConfig userPW];
            request.Ver = APIVersion;
            request.ScheduleID =[NSString stringWithFormat:@"%d",[setSignature intForColumn:@"ScheduleID"]] ;
            request.PicType = @"4";
            
            request.Date = [setSignature stringForColumn:@"SignDate"];
            request.Checker = [OTISConfig EmployeeID];

            NSString *strPhoto = [setSignature stringForColumn:@"Signature"];
            NSString *unitNo = [SZTable_Schedules quaryUnitNoWithScheduleID:[setSignature intForColumn:@"ScheduleID"]];
            NSString *strImageName = [strPhoto stringByReplacingCharactersInRange:NSMakeRange(9, 8) withString:unitNo];
            request.image = [UIImage imageWithContentsOfFile:[kSignature stringByAppendingPathComponent:strPhoto]];
            SZLog(@"strPhoto:%@ strImageName:%@ ",strPhoto,strImageName);
            if (strPhoto.length>2) {
                request.PicName = strImageName;
                [arrayData addObject:request];
            }
            
        }
        
        
    }];
    
    
    return [NSArray arrayWithArray:arrayData];

}




/**
 * 签字数据上传
 *
 *  @param params 请求参数
 */
+(NSArray *)queryUploadSignature{

    NSMutableArray *arrayData = [NSMutableArray array];
    
    [OTISDB inDatabase:^(FMDatabase *db) {
        NSString *sqlAll = [NSString stringWithFormat:@"SELECT * \
                            FROM t_Signature \
                            WHERE EmployeeID= '%@' AND IsUploaded != 1 AND IsAbsent=0\
                            GROUP BY SinId;",[OTISConfig EmployeeID]];
        
        SZLog(@"SQL 签字数据上传：%@",sqlAll);
        FMResultSet *setAll = [db executeQuery:sqlAll];
        while ([setAll next]) {
            
            SZUploadSignatureRequest *request = [[SZUploadSignatureRequest alloc] init];
            request.UserNo = [OTISConfig EmployeeID];
            request.Password = [OTISConfig userPW];
            request.Ver = APIVersion;
            request.SignID = [NSString stringWithFormat:@"%d",[setAll intForColumn:@"SinId"]];
            request.Date = [setAll stringForColumn:@"SignDate"];
            request.Attitude = [NSString stringWithFormat:@"%d",[setAll intForColumn:@"Attitude"]];
            request.Quality = [NSString stringWithFormat:@"%d",[setAll intForColumn:@"Quality"]];
            request.IsEmail = [NSString stringWithFormat:@"%d",[setAll boolForColumn:@"IsEmail"]];
            request.EmailAddr = [setAll stringForColumn:@"EmailAddr"];
            request.Customer = [setAll stringForColumn:@"Customer"];

            if ([setAll stringForColumn:@"Signature"]) {
                request.HasSignature = @"1";
                request.FileName = [setAll stringForColumn:@"Signature"];

            }else{
                request.HasSignature = @"0";
                request.FileName = @"";

            }
            request.IsOK = @"1";

            NSMutableArray *questions = [NSMutableArray array];
            NSMutableArray *repairs = [NSMutableArray array];
            NSMutableArray *replaces = [NSMutableArray array];
            NSMutableArray *comments = [NSMutableArray array];

            FMResultSet *setSingle = [db executeQueryWithFormat:@"SELECT ScheduleID,SignComment \
                                FROM t_Signature \
                                WHERE SinId=%d;",[setAll intForColumn:@"SinId"]];
            while ([setSingle next]) {
                
                SZComment *comment = [[SZComment alloc] init];
                comment.ScheduleID = [setSingle intForColumn:@"ScheduleID"];
                NSString *comt = [setSingle stringForColumn:@"SignComment"];
                if ([comt isEqualToString:@"(null)"]||comt==nil) {
                    comment.Comment = @"";
                }else{
                    comment.Comment = comt;
                }
                [comments addObject:comment];
                
                FMResultSet *setReport = [db executeQueryWithFormat:@"SELECT Question,IsReplace,IsRepair \
                                          FROM t_Report \
                                          WHERE ScheduleID=%d AND EmployeeID=%@ AND IsRepairItem=0;",[setSingle intForColumn:@"ScheduleID"],[OTISConfig EmployeeID]];
                while ([setReport next]) {
                    SZQuestion *question = [[SZQuestion alloc] init];
                    question.ScheduleID = [setSingle intForColumn:@"ScheduleID"];
                    question.Question = [setReport stringForColumn:@"Question"];
                    
                    SZRepair *repair = [[SZRepair alloc] init];
                    repair.ScheduleID = [setSingle intForColumn:@"ScheduleID"];
                    repair.IsRepair = [NSString stringWithFormat:@"%d",[setReport intForColumn:@"IsRepair"]];
                    
                    SZReplace *replace = [[SZReplace alloc] init];
                    replace.ScheduleID = [setSingle intForColumn:@"ScheduleID"];
                    replace.IsReplace = [NSString stringWithFormat:@"%d",[setReport intForColumn:@"IsReplace"]];
                    
                    [questions addObject:question];
                    [repairs addObject:repair];
                    [replaces addObject:replace];
                }
            }
            request.Comment = [SZComment mj_keyValuesArrayWithObjectArray:comments].mj_JSONString;
            request.IsReplace = [SZReplace mj_keyValuesArrayWithObjectArray:replaces].mj_JSONString;
            request.IsRepair = [SZRepair mj_keyValuesArrayWithObjectArray:repairs].mj_JSONString;
            request.Question = [SZQuestion mj_keyValuesArrayWithObjectArray:questions].mj_JSONString;

            
            [arrayData  addObject:request.mj_keyValues];
            
        }
        
    }];
    
    return [NSArray arrayWithArray:arrayData];




}


/**
 * 年检记录数据上传
 *
 *  @param params 请求参数
 */
+(NSArray *)queryYearlyCheckUpload{
    
    NSMutableArray *arrayData = [NSMutableArray array];
    
    [OTISDB inDatabase:^(FMDatabase *db) {
        FMResultSet *setAll = [db executeQueryWithFormat:@"SELECT * \
                               FROM TAB_YEARLY_CHECK \
                               WHERE EmployeeID=%@ AND IS_UPLOADING=0 ;",[OTISConfig EmployeeID]];
        
        while ([setAll next]) {
            
            SZUploadYearlyCheckRequest *request = [[SZUploadYearlyCheckRequest alloc] init];
            request.UserNo = [OTISConfig EmployeeID];
            request.Password = [OTISConfig userPW];
            request.Ver = APIVersion;
            request.UnitNo = [setAll stringForColumn:@"UnitNo"];
            request.PDate = [NSString stringWithFormat:@"%ld",[setAll longForColumn:@"SAVE_YCHECK_PDATE"]];
            request.ADate = [NSString stringWithFormat:@"%ld",[setAll longForColumn:@"YCHECK_ADATE"]];
            request.IsOK = @"1";

            [arrayData  addObject:request.mj_keyValues];
            
        }
        
    }];
    
    return [NSArray arrayWithArray:arrayData];
    
}


/**
 * 全工时数据数据上传
 *
 *  @param params 请求参数
 */
+(NSMutableDictionary *)queryFullLaborHoursUpload{

    
    NSString *strVersion = [NSString stringWithFormat:@"V%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];

    
    SZUploadFullLaborHoursRequest *request = [[SZUploadFullLaborHoursRequest alloc] init];
    request.UserNo = [OTISConfig EmployeeID];
    request.Password = [OTISConfig userPW];
    request.Ver = APIVersion;
    request.PhoneVersion = strVersion;
    request.IsOK = @"1";
    
    NSMutableArray *arrayProductHours = [NSMutableArray array];
    NSMutableArray *arrayUnProductHours = [NSMutableArray array];
    NSMutableArray *arrayNotThisCompanyHours = [NSMutableArray array];

   __block BOOL ret1 = YES;
   __block BOOL ret2 = YES;
   __block BOOL ret3 = YES;

    [OTISDB inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"SELECT GroupID ,ScheduleID,CreateDate,CreateTime,GenerateDate,Property,Remark,UnitNo,ContactNo,CustomerName \
                         FROM t_LaborHours \
                         WHERE EmployeeID='%@' AND GroupID != 0 AND Property != 0 GROUP BY GroupID;",[OTISConfig EmployeeID]];
        FMResultSet *setAll = [db executeQuery:sql];
        
        while ([setAll next]) {
            
            int property = [setAll intForColumn:@"Property"];
            
            if (property == 1) {//本公司生产性工时
                
                SZProductHours *productHours = [[SZProductHours alloc] init];
                productHours.GroupID = [NSString stringWithFormat:@"%d",[setAll intForColumn:@"GroupID"]];
                
                productHours.UnitNo = [setAll stringForColumn:@"UnitNo"];
                
            
                if ([setAll stringForColumn:@"CreateTime"]) {
                    
                    productHours.SaveHourDate =  [NSDate sinceDistantPastToDateTime:[NSDate dateTimeFromString:[setAll stringForColumn:@"CreateTime"]]];

                }
                request.dateTime = [setAll stringForColumn:@"CreateDate"];
                
                NSString *strDate = [setAll stringForColumn:@"GenerateDate"];
                if (strDate) {
                    productHours.GenerateDate = [strDate stringByReplacingOccurrencesOfString:@"-" withString:@"/"];
                }else{
                    productHours.GenerateDate = @" ";
                }
                
                
                productHours.Checker = [OTISConfig EmployeeID];
                productHours.Result = @"0";
                
                /**
                 *  AddHours
                 */
                NSMutableArray *arrayAddHours = [NSMutableArray array];
                FMResultSet *setAddHours = [db executeQueryWithFormat:@"SELECT LaborTypeId,Hour1Rate,Hour15Rate,Hour2Rate,Hour3Rate,PUINo,GroupID FROM t_LaborHours WHERE EmployeeID= %@ AND GroupID = %d AND Property = 1;",[OTISConfig EmployeeID],[setAll intForColumn:@"GroupID"]];
                while ([setAddHours next]) {
                    SZAddHoursItem *item = [[SZAddHoursItem alloc] init];
                    item.LaborTypeID = [setAddHours longForColumn:@"LaborTypeId"];
                    item.UploadHours1 = [setAddHours floatForColumn:@"Hour1Rate"];
                    item.UploadHours15 = [setAddHours floatForColumn:@"Hour15Rate"];
                    item.UploadHours2 = [setAddHours floatForColumn:@"Hour2Rate"];
                    item.UploadHours3 = [setAddHours floatForColumn:@"Hour3Rate"];
                    item.PUINum = [setAddHours stringForColumn:@"PUINo"];
                    if (item.PUINum == nil) {
                        item.PUINum = @"";
                    }
                    [arrayAddHours addObject:item];
                }
                productHours.HourList = [SZAddHoursItem mj_keyValuesArrayWithObjectArray:arrayAddHours];
                
                if (productHours.HourList.count > 0) {
                    ret1 = NO;
                }
                /**
                 *  Oprate
                 */
                NSMutableArray *arrayOprate = [NSMutableArray array];
                NSString *sqlOprate = [NSString stringWithFormat:@"\
                                       SELECT StratTime,EndTime,StartLon,StartLat,EndLon,EndLat,Property,Reason,QRCode \
                                       FROM t_QRCode \
                                       WHERE EmployeeID= %@ AND \
                                            GroupID = %d AND \
                                            Property = 1 AND \
                                            ScheduleID = %ld AND \
                                            IsFixItem=0 ;",
                                       [OTISConfig EmployeeID],[setAll intForColumn:@"GroupID"],
                                       [setAll longForColumn:@"ScheduleID"]];
                FMResultSet *setOprate = [db executeQuery:sqlOprate];
                while ([setOprate next]) {
                    NSString *qRcode = [setOprate stringForColumn:@"QRCode"];
                    if (qRcode && ![qRcode isEqualToString:@"(null)"] ) {
                        productHours.QRCode = [setOprate stringForColumn:@"QRCode"];

                    }else{
                        productHours.QRCode = @"";

                    }
                    
                    SZOprateItem *item = [[SZOprateItem alloc] init];
                    item.StartTime = [setOprate longForColumn:@"StratTime"];
                    item.EndTime = [setOprate longForColumn:@"EndTime"];
                    item.StartLocalX = [setOprate stringForColumn:@"StartLon"];
                    item.StartLocalY = [setOprate stringForColumn:@"StartLat"];
                    item.EndLocalX = [setOprate stringForColumn:@"EndLon"];
                    item.EndLocalY = [setOprate stringForColumn:@"EndLat"];
                    item.Type = @"3";
                    item.Reason = [setOprate intForColumn:@"Reason"];
                    
                    [arrayOprate addObject:item];
                }
                productHours.Operate = [SZOprateItem mj_keyValuesArrayWithObjectArray:arrayOprate];
                
                
                [arrayProductHours  addObject:productHours.mj_keyValues];
                
                
                
            }else if (property == 2){//本公司非生产性工时
                
                SZUnproductHours *unproductHours = [[SZUnproductHours alloc] init];
                unproductHours.GroupID = [NSString stringWithFormat:@"%d",[setAll intForColumn:@"GroupID"]];
                if ([setAll stringForColumn:@"Remark"]) {
                    unproductHours.Remark = [setAll stringForColumn:@"Remark"];
                }else{
                    unproductHours.Remark = @"";
                }
                if ([setAll stringForColumn:@"CreateTime"]) {
                    unproductHours.SaveHourDate = [NSDate sinceDistantPastToDateTime:[NSDate dateTimeFromString:[setAll stringForColumn:@"CreateTime"]]];

                }
                


                NSString *strDate = [setAll stringForColumn:@"GenerateDate"];
                if (strDate) {
                    unproductHours.GenerateDate = [strDate stringByReplacingOccurrencesOfString:@"-" withString:@"/"];
                }else{
                    unproductHours.GenerateDate = @"2016/3/23";
                }
                
                unproductHours.Checker = [OTISConfig EmployeeID];
                unproductHours.Result = @"0";
                
                /**
                 *  AddHours
                 */
                NSMutableArray *arrayAddHours = [NSMutableArray array];
                FMResultSet *setAddHours = [db executeQueryWithFormat:@"SELECT LaborTypeId,Hour1Rate,Hour15Rate,Hour2Rate,Hour3Rate,PUINo,GroupID FROM t_LaborHours WHERE EmployeeID= %@ AND GroupID = %d AND Property = 2;",[OTISConfig EmployeeID],[setAll intForColumn:@"GroupID"]];
                while ([setAddHours next]) {
                    SZAddHoursItem *item = [[SZAddHoursItem alloc] init];
                    item.LaborTypeID = [setAddHours longForColumn:@"LaborTypeId"];
                    item.UploadHours1 = [setAddHours floatForColumn:@"Hour1Rate"];
                    item.UploadHours15 = [setAddHours floatForColumn:@"Hour15Rate"];
                    item.UploadHours2 = [setAddHours floatForColumn:@"Hour2Rate"];
                    item.UploadHours3 = [setAddHours floatForColumn:@"Hour3Rate"];
                    item.PUINum = [setAddHours stringForColumn:@"PUINo"];
                    if (item.PUINum == nil) {
                        item.PUINum = @"";
                    }
                    [arrayAddHours addObject:item];
                }
                unproductHours.HourList = [SZAddHoursItem mj_keyValuesArrayWithObjectArray:arrayAddHours];
                
                
                
                [arrayUnProductHours  addObject:unproductHours.mj_keyValues];
                if (unproductHours.HourList.count > 0) {
                    ret2 = NO;
                }
            
            }else if (property == 4){//非本公司工时
            
                SZNotThisCompanyHours *notThisCompanyHours = [[SZNotThisCompanyHours alloc] init];
                notThisCompanyHours.GroupID = [NSString stringWithFormat:@"%d",[setAll intForColumn:@"GroupID"]];
                
                notThisCompanyHours.CustomerInfo = [setAll stringForColumn:@"CustomerName"];
                notThisCompanyHours.ContractNo = [setAll stringForColumn:@"ContactNo"];
                
                if ([setAll stringForColumn:@"CreateTime"]) {
                    notThisCompanyHours.SaveHourDate = [NSDate sinceDistantPastToDateTime:[NSDate dateTimeFromString:[setAll stringForColumn:@"CreateTime"]]];
                    
                }
                

                
                NSString *strDate = [setAll stringForColumn:@"GenerateDate"];
                if (strDate) {
                    notThisCompanyHours.GenerateDate = [strDate stringByReplacingOccurrencesOfString:@"-" withString:@"/"];
                }else{
                    notThisCompanyHours.GenerateDate = @"2016/3/23";
                }
                
                notThisCompanyHours.Checker = [OTISConfig EmployeeID];
                notThisCompanyHours.Result = @"0";
                notThisCompanyHours.Operate = nil;
                /**
                 *  AddHours
                 */
                NSMutableArray *arrayAddHours = [NSMutableArray array];
                FMResultSet *setAddHours = [db executeQueryWithFormat:@"SELECT LaborTypeId,Hour1Rate,Hour15Rate,Hour2Rate,Hour3Rate,PUINo,GroupID FROM t_LaborHours WHERE EmployeeID= %@ AND GroupID = %d AND Property = 4;",[OTISConfig EmployeeID],[setAll intForColumn:@"GroupID"]];
                while ([setAddHours next]) {
                    SZAddHoursItem *item = [[SZAddHoursItem alloc] init];
                    item.LaborTypeID = [setAddHours longForColumn:@"LaborTypeId"];
                    item.UploadHours1 = [setAddHours floatForColumn:@"Hour1Rate"];
                    item.UploadHours15 = [setAddHours floatForColumn:@"Hour15Rate"];
                    item.UploadHours2 = [setAddHours floatForColumn:@"Hour2Rate"];
                    item.UploadHours3 = [setAddHours floatForColumn:@"Hour3Rate"];
                    item.PUINum = [setAddHours stringForColumn:@"PUINo"];
                    if (item.PUINum == nil) {
                        item.PUINum = @"";
                    }
                    [arrayAddHours addObject:item];
                }
                notThisCompanyHours.HourList = [SZAddHoursItem mj_keyValuesArrayWithObjectArray:arrayAddHours];
                
                
                
                [arrayNotThisCompanyHours  addObject:notThisCompanyHours.mj_keyValues];
                if (notThisCompanyHours.HourList.count > 0) {
                    ret3 = NO;
                }
            }
            
        }

        
    }];
    
    
    if (ret1 == YES && ret2 == YES && ret3 == YES) {
        return nil;
    }
    
    request.ProductHours = arrayProductHours.mj_JSONString;
    request.UnProductHours = arrayUnProductHours.mj_JSONString;
    request.NotThisCompanyHours = arrayNotThisCompanyHours.mj_JSONString;
    
    return request.mj_keyValues;

}


@end
