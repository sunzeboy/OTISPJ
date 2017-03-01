//
//  SZTable_QRCode.m
//  OTIS_PJ
//
//  Created by sunze on 16/4/29.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "SZTable_QRCode.h"
#import "TablesAndFields.h"
#import "INTULocationManager/INTULocationManager.h"
#import "NSDate+Extention.h"
@implementation SZTable_QRCode

// 查询QRCode字段数据
+(NSString*)selectQRCode:(SZFinalMaintenanceUnitDetialItem *)item{
    
    __block NSString* QRCode=nil;
    [OTISDB inDatabase:^(FMDatabase *db) {
        
        NSString *strEmployeeID = [OTISConfig EmployeeID];
        NSString *sql = [NSString stringWithFormat:@"\
                         SELECT QRCode \
                         FROM t_QRCode \
                         WHERE ScheduleId=%ld AND \
                         EmployeeID='%@' AND \
                         IsFixItem=%d AND \
                         GroupID=0;",
                         (long)item.ScheduleID,strEmployeeID,item.isFixMode];
        FMResultSet *set = [db executeQuery:sql];
        
        while ([set next]) {
            QRCode = [set stringForColumn:@"QRCode"];
        }
    }];
    
    if (QRCode== nil || [QRCode isEqualToString:@""]) {
        QRCode = @"无二维码";
    }
    return QRCode;
}

+(BOOL)isShowQRSelectDlg:(BOOL)isFixItem andScheduleID:(int)ScheduleID{
    
    __block NSInteger notUploadCount=0;
    __block NSString *qrCode=@"";
    
    [OTISDB inDatabase:^(FMDatabase *db) {
        
        NSString *sql;
        
        if(isFixItem){
            sql = [NSString stringWithFormat:@"SELECT  count() NotUploadCount \
                   FROM t_FIX_DOWNLOAD \
                   WHERE ScheduleId=%d AND State=2;",ScheduleID];
            FMResultSet *set = [db executeQuery:sql];
            
            while ([set next]) {
                notUploadCount = [set intForColumn:@"NotUploadCount"];
            }
        }else{
            sql = [NSString stringWithFormat:@"SELECT count() NotUploadCount \
                   FROM t_REPORT_ITEM_COMPLETE_STATE \
                   WHERE ScheduleId=%d AND isUpload=0;",ScheduleID];
            sql = [NSString stringWithFormat:@"SELECT QRCode \
                   FROM t_QRCode \
                   WHERE ScheduleID=%d AND EmployeeID='%@';",ScheduleID,[OTISConfig EmployeeID]];
            FMResultSet *set = [db executeQuery:sql];
            
            while ([set next]) {
                qrCode = [set stringForColumn:@"QRCode"];
            }
        }
        
        //        while ([set next]) {
        //            notUploadCount = [set intForColumn:@"NotUploadCount"];
        //            qrCode =
        //        }
    }];
    if (isFixItem == NO ) {
        if (qrCode.length) {
            return NO;
        }else{
            return YES;
        }
    }
    if(notUploadCount >0){
        return NO;
    }
    
    return YES;
}

/**
 *  存储到QRCodeDB(从维保进入)
 *
 *  @param params
 */
+(void)storageWeiBaoWorkingHoursWithParams:(SZFinalMaintenanceUnitDetialItem *)item andGroupID:(int)groupID withProperty:(int)property{
    
    if (!item) {
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        INTULocationManager *locMgr = [INTULocationManager sharedInstance];
        [locMgr requestLocationWithDesiredAccuracy:INTULocationAccuracyBlock
                                           timeout:1.0
                              delayUntilAuthorized:YES  // This parameter is optional, defaults to NO if omitted
                                             block:^(CLLocation *currentLocation, INTULocationAccuracy achievedAccuracy, INTULocationStatus status) {
                                                 if (status == INTULocationStatusSuccess) {
                                                     // Request succeeded, meaning achievedAccuracy is at least the requested accuracy, and
                                                     // currentLocation contains the device's current location.
                                                     
                                                     NSNumber *numlongitude = [NSNumber numberWithDouble:currentLocation.coordinate.longitude];
                                                     NSNumber *numlatitude = [NSNumber numberWithDouble:currentLocation.coordinate.latitude];
                                                     
                                                     item.EndLocalX = [numlongitude stringValue];
                                                     item.EndLocalY = [numlatitude stringValue];
                                                     if (!item.StartLocalX) {
                                                         item.StartLocalX = [numlongitude stringValue];
                                                         item.StartLocalY = [numlatitude stringValue];
                                                     }
                                                     [self storageWithParams:item andGroupID:groupID withProperty:property];
                                                 }
                                                 else {
                                                     NSString *locaX = [USER_DEFAULT objectForKey:@"userLastLocationLat"];
                                                     NSString *locaY = [USER_DEFAULT objectForKey:@"userLastLocationLon"];
                                                     item.EndLocalX = locaX;
                                                     item.EndLocalY = locaY;
                                                     if (!item.StartLocalX) {
                                                         item.StartLocalX = item.EndLocalX;
                                                         item.StartLocalY = item.EndLocalY;
                                                     }
                                                     [self storageWithParams:item andGroupID:groupID withProperty:property];
                                                 }
                                             }];
    });
}


+(void)storageWithParams:(SZFinalMaintenanceUnitDetialItem *)item andGroupID:(int)groupID withProperty:(int)property{
    NSString *strEmployeeID = [OTISConfig EmployeeID];
    
    NSInteger scheduleID = item.ScheduleID;
    
    [OTISDB inDatabase:^(FMDatabase *db) {
        
        NSString* sql1 = [NSString stringWithFormat:@"select count() as QRCodeCount \
                          from t_QRCode \
                          WHERE ScheduleId = %ld AND EmployeeId = %@ AND GroupID = %d AND IsFixItem=%d;",
                          (long)scheduleID,strEmployeeID,groupID,item.isFixMode];
        
        SZLog(@"SQL storageWithParams:%@",sql1);
        FMResultSet *set = [db executeQuery:sql1];
        
        NSInteger yymmdd =  [NSDate currentYYMMDD];
        NSString *strKey = [NSString stringWithFormat:@"%ld_%@START",yymmdd,item.UnitNo];
        NSString *strKey2 = [NSString stringWithFormat:@"%ld_%@END",yymmdd,item.UnitNo];

        while ([set next]) {
            int QRCodeCount = [set intForColumn:@"QRCodeCount"];
            NSInteger  endTime =[[USER_DEFAULT objectForKey:strKey2] longValue]; // 结束时间使用当前时间
            
            if (QRCodeCount) {
                
                NSString *sql = [NSString stringWithFormat:@"UPDATE t_QRCode SET \
                                 StartLon= '%@', \
                                 StartLat= '%@', \
                                 EndTime = %ld, \
                                 EndLon = '%@', \
                                 EndLat = '%@', \
                                 UpdateTime = %ld, \
                                 Reason  = %d \
                                 WHERE  ScheduleId = %ld AND \
                                 EmployeeId = '%@' AND \
                                 GroupID = %d AND \
                                 IsFixItem=%d;",
                                 item.StartLocalX,
                                 item.StartLocalY,
                                 (endTime == 0)? [NSDate sinceDistantPastTime]:endTime,
                                 (item.EndLocalX==nil)?@"0":item.EndLocalX,
                                 (item.EndLocalY==nil)?@"0":item.EndLocalY,
                                 (long)item.UpdateTime,
                                 (int)item.Reason,
                                 (long)scheduleID,
                                 strEmployeeID,
                                 groupID,
                                 item.isFixMode];
                
                BOOL ret = [db executeUpdate:sql];
                if (!ret) {
                    SZLog(@"错误：t_QRCode更新失败！！！");
                }
            }else{
                long startTime = [[USER_DEFAULT objectForKey:strKey] longValue];
                NSString *sql = [NSString stringWithFormat:@"INSERT INTO t_QRCode ( \
                                 GroupID, \
                                 EmployeeId, \
                                 ScheduleId, \
                                 IsFixItem, \
                                 QRCode, \
                                 StratTime, \
                                 EndTime, \
                                 StartLon, \
                                 StartLat, \
                                 EndLon, \
                                 EndLat, \
                                 Reason, \
                                 CreateTime, \
                                 UpdateTime, \
                                 AppVersion, \
                                 Property) \
                                 VALUES (%d,'%@',%ld,%d,'%@',%ld,%ld,'%@','%@','%@','%@',%ld,%ld,%ld,'%@',%d);",
                                 groupID,
                                 strEmployeeID,
                                 (long)scheduleID,
                                 item.isFixMode,
                                 item.QRCode,
                                 (startTime == 0)? [NSDate sinceDistantPastTime]:startTime,
                                 (endTime == 0)? [NSDate sinceDistantPastTime]:endTime,
                                 (item.StartLocalX==nil)?@"0":item.StartLocalX,
                                 (item.StartLocalY==nil)?@"0":item.StartLocalY,
                                 (item.EndLocalX==nil)?@"0":item.EndLocalX,
                                 (item.EndLocalY==nil)?@"0":item.EndLocalY,
                                 (long)item.Reason,
                                 (long)item.CreateTime,
                                 (long)item.UpdateTime,
                                 APIVersion,
                                 property];
                BOOL ret = [db executeUpdate:sql];
                if (!ret) {
                    SZLog(@"错误：%@",sql);
                    SZLog(@"错误：t_QRCode插入失败！！！");
                }
            }
        }
    }];
}


/**
 *  根据请求参数去沙盒中加载缓存的QRCode数据
 *
 *  @param params 请求参数
 */
+(NSArray *)readWorkingHoursWithParams:(NSDictionary *)params{
    return nil;
}

+(BOOL)hasScandWithUnitNo:(NSString *)unitNo{
    
    __block BOOL isScaned = NO;
    [OTISDB inDatabase:^(FMDatabase *db) {
        FMResultSet *set1 = [db executeQueryWithFormat:@"SELECT IsScaned ,IsNeedDialog \
                             FROM TAB_UNIT_UN_SCANED_REASON \
                             WHERE UnitNo=%@;",unitNo];
        while ([set1 next]) {
            
            isScaned = [set1 boolForColumn:@"IsScaned"];
        }
    }];
    
    return isScaned;
}


@end
