//
//  SZTable_UnfinishedMaintenanceItem.m
//  OTIS_PJ
//
//  Created by sunze on 16/6/7.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "SZTable_UnfinishedMaintenanceItem.h"
#import "SZReport.h"
#import "SZTable_Report.h"
#import "TablesAndFields.h"
#import "SZReportOperation.h"
#import "SZTable_Schedules.h"

@implementation SZTable_UnfinishedMaintenanceItem



+(void)storgeTabReportItemCompleteState:(SZDownload_UnfinishedItemsResponse *)response{

    NSString *employeeId = [OTISConfig EmployeeID];
    [OTISDB inDatabase:^(FMDatabase *db) {
      
        NSString *sqlDelet1 = [NSString stringWithFormat:@"DELETE  FROM t_REPORT_ITEM_COMPLETE_STATE_Download ;"];
        BOOL ret1 = [db executeUpdate:sqlDelet1];
        if (ret1) {

        }else{
            SZLog(@"错误：删除t_REPORT_ITEM_COMPLETE_STATE_Download失败");
        }
        
        NSString *sqlDelet2 = [NSString stringWithFormat:@"DELETE  FROM t_Report_Download ;"];
        BOOL ret2 = [db executeUpdate:sqlDelet2];
        if (ret2) {

        }else{
            SZLog(@"错误：删除t_Report_Download失败");
        }
    }];

    for (SZReport *report in response.Report) {
        // 将其他人做过的保养信息写入数据库
        [SZTable_Report storageWithSZReportDowndload:report];
        
        employeeId = report.User;
        
        //保存report中的保养项数据
        [SZTable_REPORT_ITEM_COMPLETE_STATE storageSZReportOperations:report.Items withEmployeeID:employeeId andScheduleID:report.ScheduleID];
    }
    
    [OTISDB inDatabase:^(FMDatabase *db) {
        
        // 更新保养项
        NSString *sql = [NSString stringWithFormat:@"REPLACE INTO t_REPORT_ITEM_COMPLETE_STATE (ScheduleId,EmployeeID,ItemCode,State,isUpload ) SELECT \
                         ScheduleId, \
                         EmployeeID, \
                         ItemCode, \
                         State, \
                         1 AS isUpload \
                         FROM t_REPORT_ITEM_COMPLETE_STATE_Download ;"];
        
        BOOL ret = [db executeUpdate:sql];
        if (!ret) {
            SZLog(@"INSERT INTO t_REPORT_ITEM_COMPLETE_STATE失败！！");
        }
        
    
        // 保养记录更新,从report表来的数据IsRepairItem都是0，这个是主键，可以存在两条这样的记录，维修换件和非维修换件
         sql = [NSString stringWithFormat:@"REPLACE INTO t_Report (ScheduleId, \
                                EmployeeID, \
                                JhaDate, \
                                ItemDate, \
                                ItemPhoto, \
                                AdjustmentType, \
                                AdjustmentComment, \
                                Question, \
                                IsReplace, \
                                IsRepair, \
                                IsUploaded, \
                                LastStatus,\
                                IsRepairItem) \
                                SELECT \
                                    ScheduleId, \
                                    EmployeeID, \
                                    0 AS JhaDate, \
                                    0 AS ItemDate, \
                                    0 AS ItemPhoto, \
                                    0 AS AdjustmentType, \
                                    '' AS AdjustmentComment, \
                                    Question, \
                                    IsReplace, \
                                    IsRepair, \
                                    1 AS IsUploaded, \
                                    -1 AS LastStatus, \
                                    0 AS IsRepairItem \
                                FROM t_Report_Download "];
        ret = [db executeUpdate: sql];
        if(!ret ){
            SZLog(@"错误：合并report download");
        }
        
        sql = [NSString stringWithFormat:@"REPLACE INTO  t_Schedules(ScheduleID, \
                     EmployeeID, \
                     UnitNo, \
                     Year, \
                     CheckDate, \
                     Times, \
                     RouteNo, \
                     CardType, \
                     PlanType, \
                     IsComplete \
                     ) \
                     SELECT \
                     t_Report_Download.ScheduleID, \
                     t_Report_Download.EmployeeID, \
                     UnitNo, \
                     Year, \
                     CheckDate, \
                     Times, \
                     RouteNo, \
                     CardType, \
                     PlanType, \
                     t_Report_Download.IsComplete \
                     FROM t_Schedules,t_Report_Download \
                     WHERE (t_Schedules.ScheduleID = t_Report_Download.ScheduleID AND \
                     t_Report_Download.IsComplete >t_Schedules.IsComplete)"];
        ret = [db executeUpdate:sql];
        
        if (!ret) {
            SZLog(@"错误：合并t_Schedules ");
            
        }
    }];
    
    
}


+(void)storgeFixItemCompleteState:(SZDownload_UnfinishedItemsResponse *)response{

    
    [OTISDB  inDatabase:^(FMDatabase *db) {
        
        NSString *sqlDelet1 = [NSString stringWithFormat:@"DELETE  FROM t_FIX_DOWNLOAD ;"];
        BOOL ret1 = [db executeUpdate:sqlDelet1];
        if (!ret1) {
            SZLog(@"错误：下载Fix项 删除t_FIX_DOWNLOAD失败");
        }

        for (SZFix *fix in response.Fix) {
            //插入FixItem数据
            [self storageFixDowndload:fix];
            // 更新report表,是是自己路线的数据，不增加或者更新report表
            BOOL isMyRouteNo = [SZTable_Schedules isMyRouteNoInTabScheduleWithScheduleID:fix.ScheduleID];
            if(isMyRouteNo){
                NSString *sqlInsert = [NSString stringWithFormat:@"REPLACE INTO t_Report( \
                                           EmployeeID,\
                                           ScheduleId,\
                                           LastStatus, \
                                           IsUploaded, \
                                           IsRepairItem) \
                                           VALUES ('%@',%ld,-1,1,1)",
                                           [OTISConfig EmployeeID],(long)fix.ScheduleID];
                BOOL ret = [db executeUpdate:sqlInsert];
                if (!ret) {
                    SZLog(@"错误：下载Fix项，插入tab t_Report");
                }
            }
            
            NSString *sqlUpdate = [NSString stringWithFormat:@"UPDATE t_Schedules  SET IsComplete=%d WHERE ScheduleId =%ld",fix.IsComplete,(long)fix.ScheduleID];
            BOOL retUpdate = [db executeUpdate:sqlUpdate];
            if (!retUpdate) {
                SZLog(@"错误：下载Fix项 更新tab t_Schedules");
            }
        }
    }];
}

//保存未完成项目下载中的Fix项目
+(void)storageFixDowndload:(SZFix *)fix{
    
    [OTISDB inDatabase:^(FMDatabase *db) {
        
        long scheduleID = fix.ScheduleID;
        BOOL ret =0;

        for (SZReportOperation *opreation  in fix.Items) {
            NSString *sql = [NSString stringWithFormat:@"INSERT INTO t_FIX_DOWNLOAD \
                             (ScheduleId,ItemCode,State,IsComplete) \
                             VALUES (%ld,'%@',%d,%d);",
                             scheduleID,
                             opreation.Code,
                             opreation.State,
                             fix.IsComplete];
            ret = [db executeUpdate:sql];
            if (!ret) {
                SZLog(@"错误：下载Fix项 插入t_FIX_DOWNLOAD失败");
            }
        }
    }];
}


@end
