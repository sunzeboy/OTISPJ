//
//  SZT_MD_Maintenance.m
//  OTIS_PJ
//
//  Created by sunze on 2017/3/10.
//  Copyright © 2017年 sunzeboy. All rights reserved.
//

#import "SZT_MD_Maintenance.h"
#import "TablesAndFields.h"


@implementation ItemInfo


@end

@implementation ReqEventLogAndMaintenance

+(NSDictionary *)mj_objectClassInArray
{
    return @{
             @"item" : @"ItemInfo"
             };
    
}

@end


@implementation SZT_MD_Maintenance

+(void)storge:(ReqEventLogAndMaintenance *)model {
    
    [OTISDB inDatabase:^(FMDatabase *db) {

            NSString *sqlInsert = [NSString stringWithFormat:@"Insert or replace into t_MD_Maintenance (ScheduleID, \
                                   UnitNo, \
                                   EmployeeID, \
                                   AppVer, \
                                   StartTime, \
                                   EndTime, \
                                   EventLog, \
                                   IsCompleteCtrl, \
                                   IsCompleteDri, \
                                   UserName, \
                                   CtrlSoftwareVer, \
                                   DriSoftwareVer) VALUES (%ld,'%@','%@','%@','%@','%@','%@',%d,%d,'%@','%@','%@')",
                                   model.scheduleID,
                                   model.unitNo,
                                   model.employeeID,
                                   model.appVer,
                                   model.startTime,
                                   model.endTime,
                                   model.eventLog,
                                   model.isCompleteCtrl,
                                   model.isCompleteDri,
                                   model.username,
                                   model.ctrlSoftwareVer,
                                   model.driSoftwareVer];
            
            BOOL a = [db executeUpdate:sqlInsert];
            if (!a) {
                NSLog(@"错误：插入t_MD_Maintenance失败");
            }

        
    }];
    [self storage:model.item withModel:model];
}


+(void)storage:(NSArray<ItemInfo *> *)items withModel:(ReqEventLogAndMaintenance *)model{

    if (items == nil || items.count == 0)
    {
        return;
    }
    [OTISDB inDatabase:^(FMDatabase *db) {
        
        for (ItemInfo *itemInfo in items) {
             NSLog(@"---------------------------%@",itemInfo.itemCode);
            NSString *sqlInsert = [NSString stringWithFormat:@"Insert or replace into t_MD_ItemInfo (ScheduleID, UnitNo, ItemCode,ItemState,ItemStateAuto,Reason) VALUES (%ld,'%@','%@',%ld,%ld,'%@')",
                                   model.scheduleID,
                                   model.unitNo,
                                   itemInfo.itemCode,
                                   (long)itemInfo.itemState,
                                   itemInfo.itemStateAuto,
                                   itemInfo.reason];
            NSLog(@"---------------------------%@",sqlInsert);
            
            BOOL a = [db executeUpdate:sqlInsert];
            if (!a) {
                NSLog(@"错误：插入t_MD_ItemInfo失败");
            }else{
                NSLog(@"数据插入成功");
            }
        }
        
    }];
}


+(NSArray<ReqEventLogAndMaintenance *> *)mdList {
    
    NSMutableArray *arrayData = [NSMutableArray array];

    [OTISDB inDatabase:^(FMDatabase *db) {
        
        NSString *sqlQury = [NSString stringWithFormat:@"select ScheduleID, \
                             UnitNo, \
                             EmployeeID, \
                             AppVer, \
                             StartTime, \
                             EndTime, \
                             EventLog, \
                             IsCompleteCtrl, \
                             IsCompleteDri, \
                             UserName, \
                             CtrlSoftwareVer, \
                             DriSoftwareVer from t_MD_Maintenance  ;"];
        
        FMResultSet *set = [db executeQuery:sqlQury];
        
        while ([set next]) {
            ReqEventLogAndMaintenance *model = [[ReqEventLogAndMaintenance alloc] init];
            model.scheduleID = [set intForColumn:@"ScheduleID"];
            model.unitNo = [set stringForColumn:@"UnitNo"];
            model.appVer = [set stringForColumn:@"AppVer"];
            model.startTime = [set stringForColumn:@"StartTime"];
            model.endTime = [set stringForColumn:@"EndTime"];
            model.eventLog = [set stringForColumn:@"EventLog"];
            model.isCompleteCtrl = [set intForColumn:@"IsCompleteCtrl"];
            model.isCompleteDri = [set stringForColumn:@"IsCompleteDri"];
            model.username = [set stringForColumn:@"UserName"];
            model.ctrlSoftwareVer = [set stringForColumn:@"CtrlSoftwareVer"];
            model.driSoftwareVer = [set stringForColumn:@"DriSoftwareVer"];
            model.employeeID = [set stringForColumn:@"EmployeeID"];
            
            model.item = [NSMutableArray array];
            
            NSString *sqlQury2 = [NSString stringWithFormat:@"select ScheduleID, \
                                  UnitNo, \
                                  ItemCode, \
                                  ItemState, \
                                  ItemStateAuto, \
                                  Reason from t_MD_ItemInfo WHERE ScheduleID = %ld;",model.scheduleID];
            FMResultSet *set2 = [db executeQuery:sqlQury2];
            
            NSLog(@"---------------------------%@",sqlQury2);
            
            while ([set2 next]) {
                ItemInfo *itemInfo = [[ItemInfo alloc] init];
                itemInfo.itemCode = [set2 stringForColumn:@"ItemCode"];
                itemInfo.itemState = [set2 intForColumn:@"ItemState"];
                itemInfo.itemStateAuto = [set2 intForColumn:@"ItemStateAuto"];
                itemInfo.reason = [set2 stringForColumn:@"Reason"];
                [model.item addObject:itemInfo];
            }
            [arrayData addObject:model];
        }
    }];

    return arrayData;
}

+(ReqEventLogAndMaintenance *)modelWith:(int) scheduleID {
    
    ReqEventLogAndMaintenance *model = [[ReqEventLogAndMaintenance alloc] init];

    [OTISDB inDatabase:^(FMDatabase *db) {
        
        NSString *sqlQury = [NSString stringWithFormat:@"select ScheduleID, \
                             UnitNo, \
                             EmployeeID, \
                             AppVer, \
                             StartTime, \
                             EndTime, \
                             EventLog, \
                             IsCompleteCtrl, \
                             IsCompleteDri, \
                             UserName, \
                             CtrlSoftwareVer, \
                             DriSoftwareVer from t_MD_Maintenance WHERE ScheduleID = %d ;",scheduleID];
        
        FMResultSet *set = [db executeQuery:sqlQury];
        while ([set next]) {
            model.scheduleID = scheduleID;
            model.unitNo = [set stringForColumn:@"UnitNo"];
            model.appVer = [set stringForColumn:@"AppVer"];
            model.startTime = [set stringForColumn:@"StartTime"];
            model.endTime = [set stringForColumn:@"EndTime"];
            model.eventLog = [set stringForColumn:@"EventLog"];
            model.isCompleteCtrl = [set intForColumn:@"IsCompleteCtrl"];
            model.isCompleteDri = [set stringForColumn:@"IsCompleteDri"];
            model.username = [set stringForColumn:@"UserName"];
            model.ctrlSoftwareVer = [set stringForColumn:@"CtrlSoftwareVer"];
            model.driSoftwareVer = [set stringForColumn:@"DriSoftwareVer"];
        }
    }];

    return model;
}


@end
