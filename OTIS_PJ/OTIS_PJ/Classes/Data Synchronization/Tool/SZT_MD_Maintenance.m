//
//  SZT_MD_Maintenance.m
//  OTIS_PJ
//
//  Created by sunze on 2017/3/10.
//  Copyright © 2017年 sunzeboy. All rights reserved.
//

#import "SZT_MD_Maintenance.h"
#import "TablesAndFields.h"




@implementation SZT_MD_Maintenance

+(void)storge:(ReqEventLogAndMaintenance *)model {
    
    [OTISDB inDatabase:^(FMDatabase *db) {
        
        NSString *sqlQury = [NSString stringWithFormat:@"SELECT count() as mDCount \
                             FROM t_MD_Maintenance \
                             WHERE ScheduleID=%ld ;",model.scheduleID];
        FMResultSet *set = [db executeQuery:sqlQury];
        int mDCount=0;
        
        while ([set next]) {
            mDCount = [set intForColumn:@"mDCount"];
        }
        
        if (mDCount>0) {
            
            NSString *sqlInsert = [NSString stringWithFormat:@"UPDATE t_MD_Maintenance SET UnitNo = %@, \
                EmployeeID = %@ ,AppVer = %@,StartTime = %@,EndTime= %@,EventLog= %@,IsCompleteCtrl= %d,IsCompleteDri= %d,UserName= %@,CtrlSoftwareVer= %@,DriSoftwareVer= %@ WHERE ScheduleID=%ld ",model.unitNo,model.employeeID,model.appVer,model.startTime,model.endTime,model.eventLog,model.isCompleteCtrl,model.isCompleteDri,model.username,model.ctrlSoftwareVer,model.driSoftwareVer,model.scheduleID];
            
            BOOL a = [db executeUpdate:sqlInsert];
            if (!a) {
                NSLog(@"错误：更新t_MD_Maintenance失败");
            }

            
        }else{
            NSString *sqlInsert = [NSString stringWithFormat:@"INSERT INTO t_MD_Maintenance (ScheduleID, UnitNo, EmployeeID,AppVer,StartTime,EndTime,EventLog,IsCompleteCtrl,IsCompleteDri,UserName,CtrlSoftwareVer,DriSoftwareVer) VALUES (%ld,'%@','%@','%@','%@','%@','%@',%d,%d,'%@','%@','%@')",model.scheduleID,model.unitNo,model.employeeID,model.appVer,model.startTime,model.endTime,model.eventLog,model.isCompleteCtrl,model.isCompleteDri,model.username,model.ctrlSoftwareVer,model.driSoftwareVer];
            
            BOOL a = [db executeUpdate:sqlInsert];
            if (!a) {
                NSLog(@"错误：插入t_MD_Maintenance失败");
            }

        }
    
        
        
        
    }];

}


+(void)storage:(NSArray<ItemInfo *> *)items withModel:(ReqEventLogAndMaintenance *)model{

    if (items.count == 0) return
    
    [OTISDB inDatabase:^(FMDatabase *db) {
        
        NSString *sqlDelete = [NSString stringWithFormat:@"DELETE FROM t_MD_ItemInfo WHERE ScheduleID = %ld AND UnitNo = %@",model.scheduleID,model.unitNo];
        
        BOOL ret1 = [db executeUpdate:sqlDelete];
        if (ret1) {
            
        }else{
            SZLog(@"清除t_MD_ItemInfo数据失败!");
        }
        
        for (ItemInfo *itemInfo in items) {
            NSString *sqlInsert = [NSString stringWithFormat:@"INSERT INTO t_MD_ItemInfo (ScheduleID, UnitNo, ItemCode,ItemState,ItemStateAuto,Reason) VALUES (%ld,'%@','%@',%ld,%ld,'%@')",model.scheduleID,model.unitNo,itemInfo.itemCode,(long)itemInfo.itemState,itemInfo.itemStateAuto,itemInfo.reason];
            
            BOOL a = [db executeUpdate:sqlInsert];
            if (!a) {
                NSLog(@"错误：插入t_MD_ItemInfo失败");
            }

        }
        
    }];


}


+(NSArray<ReqEventLogAndMaintenance *> *)mdList {
    NSMutableArray *arrayData = [NSMutableArray array];

    [OTISDB inDatabase:^(FMDatabase *db) {
        
    }];

}

@end
