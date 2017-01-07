//
//  SZTable_REPORT_ITEM_COMPLETE_STATE.m
//  OTIS_PJ
//
//  Created by sunze on 16/5/19.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "SZTable_REPORT_ITEM_COMPLETE_STATE.h"
#import "TablesAndFields.h"
#import "SZReportOperation.h"
#import "SZModuleQueryTool.h"

@implementation SZreportItem


@end

@implementation SZTable_REPORT_ITEM_COMPLETE_STATE



+(void)deletWithScheduleId:(int)scheduleId ANDEmployeeId:(NSString *)employeeId{
    
    [OTISDB inDatabase:^(FMDatabase *db) {
        
        BOOL ret = [db executeUpdateWithFormat:@"DELET from t_REPORT_ITEM_COMPLETE_STATE WHERE ScheduleId = %d AND EmployeeId = %@;",scheduleId,employeeId];
        if (ret) {
            SZLog(@"DELET t_Report成功！！！");
        }else{
            SZLog(@"错误：DELET t_Report失败！！！");
        }
        
        
        
    }];
    
}


/**
 *  存储到t_REPORT_ITEM_COMPLETE_STATE_Download
 *
 *  @param params
 */
+(void)storageSZReportOperations:(NSArray *)operations withEmployeeID:(NSString *)employeeID andScheduleID:(int)scheduleID{
    
    if (operations.count == 0)return;
    [OTISDB inDatabase:^(FMDatabase *db) {
    
//        NSInteger cal = operations.count%kNumberOfEachDeposit;
//        NSInteger frequency = operations.count/kNumberOfEachDeposit;
//        
//        for (NSInteger fre = 0; fre<frequency; fre++){
//            
//            NSMutableString *sql = [NSMutableString stringWithFormat:@"%@", @"INSERT INTO t_REPORT_ITEM_COMPLETE_STATE_Download (ItemCode, State,EmployeeID,ScheduleId) VALUES"];
//            
//            for (NSInteger i =kNumberOfEachDeposit*fre; i<kNumberOfEachDeposit*(fre +1); i++) {
//                SZReportOperation *operation= operations[i];
//                if (operation.State == 99) {
//                    continue;
//                }
//                // 未完成保养项目里面有stat＝1的保养项目，但是再fix里 没有这项；
//                // 此时，fix里的是维修换件，保养项里 的数据应该是stat＝2的状态，本地修改一下
//                if (operation.State ==1 ){
//                    operation.State =2;
//                }
//                NSString *strSqlSuffix = [NSString stringWithFormat:@"('%@',\
//                                          %d,\
//                                          '%@',\
//                                           %d ),",
//                                          operation.Code,
//                                          operation.State,
//                                          employeeID,
//                                          scheduleID];
//                [sql appendString:strSqlSuffix];
//                
//            }
//            
//            [sql deleteCharactersInRange:NSMakeRange([sql length]-1, 1)];
//            SZLog(@"----++++%@",sql);
//            BOOL a = [db executeUpdate:sql];
//            if (!a) {
//                NSLog(@"错误：t_REPORT_ITEM_COMPLETE_STATE_Download插入失败1");
//            }
//        }
        
        NSMutableString *sql = [NSMutableString stringWithFormat:@"%@", @"INSERT INTO t_REPORT_ITEM_COMPLETE_STATE_Download (ItemCode, State,EmployeeID,ScheduleId) VALUES"];
        
        int userCount=0;
        for (NSInteger i =0; i<operations.count; i++) {
            
            SZReportOperation *operation= operations[i];
            if (operation.State  == 99) {
                continue;
            }
            userCount++;
            NSString *strSqlSuffix = [NSString stringWithFormat:@"('%@',\
                                      %d,\
                                      '%@',\
                                      %d ),",
                                      operation.Code,
                                      operation.State,
                                      employeeID,
                                      scheduleID];
            [sql appendString:strSqlSuffix];
        }
        if(userCount>0){
            [sql deleteCharactersInRange:NSMakeRange([sql length]-1, 1)];
            
            SZLog(@"SQL  输出COMPLETE_STATE：%@",sql);
            BOOL a = [db executeUpdate:sql];
            if (!a) {
                SZLog(@"错误：t_REPORT_ITEM_COMPLETE_STATE_Download插入失败2");
            }
        }
        SZLog(@"t_REPORT_ITEM_COMPLETE_STATE_Download储完成！%@",[NSThread currentThread]);
        
        
        
        
    }];
    
}

// 维修换件上传完成处理
+(void)updateUploadedWithScheduleId:(NSString *)scheduleId{

    [OTISDB inDatabase:^(FMDatabase *db) {
        
        // 删除已经完成的项目
        NSString *sql = [NSString stringWithFormat:@"DELETE FROM t_FIX_DOWNLOAD WHERE ScheduleId=%ld AND State=2;",(long)scheduleId.integerValue];
        BOOL ret = [db executeUpdate:sql];
        
        if (!ret) {
            SZLog(@"错误：维修换件完成 t_FIX_DOWNLOAD更新失败");
        }
        
        // 判断是否全部上传完成
        int isCompleteRepair = 0;
        sql = [NSString stringWithFormat:@"SELECT count() AS isCompleaeRepair \
                                 FROM t_FIX_DOWNLOAD \
                                 WHERE  ScheduleId=%ld ;",
                                 scheduleId.integerValue];
        SZLog(@"SQL 判断是否全部上传完成:%@",sql);
        FMResultSet *set = [db executeQuery:sql];
        while ([set next]) {
            isCompleteRepair = [set intForColumn:@"isCompleaeRepair"];
        }
        
        // IsRepairItem 0,非维修换件项，1维修换件项目，2已经完成的维修换件项目
        // 全部完成的话，将IsRepairItem设置为2
      
        sql = [NSString stringWithFormat:@"UPDATE t_Report SET  IsUploaded = 1, IsRepairItem=%d \
                            WHERE ScheduleId = %d AND EmployeeId = '%@' AND IsRepairItem=1;",
                          isCompleteRepair>0?1:2,
                          scheduleId.intValue,
                          [OTISConfig EmployeeID]];
        ret = [db executeUpdate:sql];
        if (!ret) {
            SZLog(@"错误：维修换件完成 t_Report更新失败");
        }
        
        // 删除已经做的JHA项目
        sql = [NSString stringWithFormat:@"DELETE \
                                          FROM t_JHA_USER_SELECTED_SCHEDULE_ITEM \
                                          WHERE ScheduleId=%ld AND EmployeeId='%@' AND IsFixItem=1 ;",
                                (long)scheduleId.integerValue,[OTISConfig EmployeeID]];
        ret = [db executeUpdate:sql];
        
        if (!ret) {
            SZLog(@"SQL 维修换件完成:%@",sql);
            SZLog(@"错误：维修换件完成 删除已经做的JHA项目失败");
        }
        
        // 删除位置信息,Fix的qr记录保存的时候，groupid=0，IsFixMode=1；
        ret = [db executeUpdateWithFormat:@"DELETE \
               FROM t_QRCode \
               WHERE GroupID=0 AND EmployeeID=%@ AND ScheduleID=%ld AND IsFixItem=1 AND GroupID=0;",
               [OTISConfig EmployeeID],(long)scheduleId.integerValue];
        if (!ret) {
            SZLog(@"错误：维修换件完成 删除位置信息失败");
        }
        
    }];


}

/**
 *  存储到t_REPORT_ITEM_COMPLETE_STATE
 *
 *  @param params
 */
+(void)storageReportOperations:(NSArray *)operations {
    
    
    if (operations.count == 0)return;
    
    
    [OTISDB inDatabase:^(FMDatabase *db) {
        
        NSInteger cal = operations.count%kNumberOfEachDeposit;
        NSInteger frequency = operations.count/kNumberOfEachDeposit;
        
        for (NSInteger fre = 0; fre<frequency; fre++){
            
            NSMutableString *sql = [NSMutableString stringWithFormat:@"%@", @"INSERT INTO t_REPORT_ITEM_COMPLETE_STATE (ItemCode, State,EmployeeID,ScheduleId) VALUES"];
            
            for (NSInteger i =kNumberOfEachDeposit*fre; i<kNumberOfEachDeposit*(fre +1); i++) {
                SZreportItem *operation= operations[i];
                if (operation.State == 99) {
                    continue;
                }
                NSString *strSqlSuffix = [NSString stringWithFormat:@"('%@',\
                                          %d,\
                                          '%@',\
                                          %d),",
                                          operation.ItemCode,
                                          operation.State,
                                          operation.EmployeeID,
                                          operation.ScheduleId];
                [sql appendString:strSqlSuffix];
                
            }
            
            
            [sql deleteCharactersInRange:NSMakeRange([sql length]-1, 1)];
            BOOL a = [db executeUpdate:sql];
            if (!a) {
                NSLog(@"错误：存储到t_REPORT_ITEM_COMPLETE_STATE 失败1");
            }
            
            
        }
        
        NSMutableString *sql = [NSMutableString stringWithFormat:@"%@", @"INSERT INTO t_REPORT_ITEM_COMPLETE_STATE (ItemCode, State,EmployeeID,ScheduleId) VALUES"];
        
        for (NSInteger i =kNumberOfEachDeposit*frequency; i<kNumberOfEachDeposit*frequency +cal; i++) {
            
            SZreportItem *operation= operations[i];
            if (operation.State  == 99) {
                continue;
            }
            NSString *strSqlSuffix = [NSString stringWithFormat:@"('%@',\
                                      %d,\
                                      '%@',\
                                      %d),",
                                      operation.ItemCode,
                                      operation.State,
                                      operation.EmployeeID,
                                      operation.ScheduleId];
            [sql appendString:strSqlSuffix];
        }
        
        [sql deleteCharactersInRange:NSMakeRange([sql length]-1, 1)];
        BOOL a = [db executeUpdate:sql];
        if (!a) {
            NSLog(@"错误：存储到t_REPORT_ITEM_COMPLETE_STATE 失败2");
        }
        
        
        
        
        SZLog(@"t_REPORT_ITEM_COMPLETE_STATE储完成！%@",[NSThread currentThread]);
    }];
    
}


/**
 *  查询其他人已经做的保养项目 EMPLOYEE_ID!='%s' 注意是!=
 *
 *  @param params 请求参数
 */
+(NSDictionary *)queryItemCodeOtherWithScheduleId:(int)scheduleId{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    [OTISDB inDatabase:^(FMDatabase *db) {
        
        FMResultSet *set = [db executeQueryWithFormat:@"\
                            SELECT ItemCode \
                            from t_REPORT_ITEM_COMPLETE_STATE \
                            WHERE ScheduleId = %d AND EmployeeId != %@;",scheduleId,[OTISConfig EmployeeID]];
        while ([set next]) {
            
            
            NSString *itemCode = [set stringForColumn:@"ItemCode"];
 
            [dic  setObject:itemCode forKey:itemCode];
        }
        
    }];
    
    
    return dic;
}


@end
