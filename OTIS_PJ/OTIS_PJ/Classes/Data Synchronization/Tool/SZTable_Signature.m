//
//  SZTable_Signature.m
//  OTIS_PJ
//
//  Created by sunze on 16/4/29.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "SZTable_Signature.h"
#import "TablesAndFields.h"
#import "NSDate+Extention.h"

@implementation SZTable_Signature



/**
 *  存储到SignatureDB
 *
 *  @param params
 */
+(void)storageWithAttitude:(OTISEvaluateType)attitude quality:(OTISEvaluateType)quality signComment:(NSString *)signComment isAbsent:(BOOL)isAbsent customer:(NSString *)customer signature:(NSString *)signature isEmail:(BOOL)isEmail emailAddr:(NSString *)emailAddr isImageUploaded:(BOOL)isImageUploaded andScheduleIDs:(NSArray *)scheduleIDs{

    [OTISDB inDatabase:^(FMDatabase *db) {
        int signId = 1;
        FMResultSet *set = [db executeQueryWithFormat:@"SELECT MAX(SinId) AS MaxSignId FROM t_Signature ;"];
        while ([set next]) {
            
            signId = [set intForColumn:@"MaxSignId"]+1;
        }

        if (isAbsent==0) {//zai
            int count = 0;
            for (SZFinalMaintenanceUnitItem *item in scheduleIDs) {
                
               NSString * comment = [USER_DEFAULT objectForKey:[NSString stringWithFormat:@"Comments_%d",count]];
                count ++;
                NSString *sql ;
        
                sql = [NSString stringWithFormat:@"UPDATE t_Report SET IsAbsent=0 WHERE EmployeeID='%@' AND ScheduleId=%d AND IsRepairItem=0;",
                       [OTISConfig EmployeeID],(int)item.ScheduleID];
                BOOL ret =[db executeUpdate:sql];
                if (!ret) {
                    SZLog(@"t_Signature update t_Report失败！！！");
                }
                
                NSInteger RouteNoCount = 0;
                FMResultSet *set = [db executeQueryWithFormat:@"SELECT count() as RouteNoCount from t_Signature WHERE ScheduleID = %d AND EmployeeID = %@ AND IsUploaded = 0;",(int)item.ScheduleID,[OTISConfig EmployeeID]];
                while ([set next]) {
                    RouteNoCount = [set intForColumn:@"RouteNoCount"];
                }
                
                if (RouteNoCount ) {
                    sql = [NSString stringWithFormat:@"UPDATE t_Signature SET  \
                           Attitude = %d, \
                           Quality = %d , \
                           SignComment = '%@' , \
                           IsAbsent = %d , \
                           Customer = '%@', \
                           Signature = '%@' , \
                           IsEmail = %d , \
                           EmailAddr = '%@' , \
                           SinId = %d , \
                           SignDate = '%@' \
                           WHERE EmployeeID = %@ AND ScheduleID = %d",attitude,quality,
                           comment == nil ?@"":comment,
                           isAbsent,customer,
                           isAbsent==1?@"":signature,
                           isEmail,
                           emailAddr,
                           signId,
                           [NSString stringWithFormat:@"%ld",[NSDate sinceDistantPastTime]],[OTISConfig EmployeeID],(int)item.ScheduleID];
                    
                }else{
                    
                    
                    sql = [NSString stringWithFormat:@"INSERT INTO t_Signature (\
                           EmployeeID,\
                           ScheduleID ,\
                           SignDate,\
                           Attitude,\
                           Quality ,\
                           SignComment ,\
                           IsAbsent ,\
                           Customer ,\
                           Signature ,\
                           IsEmail ,\
                           EmailAddr ,\
                           IsImageUploaded,\
                           SinId, \
                           IsUploaded) VALUES ('%@',%d,'%@', %d,%d, '%@',%d, '%@','%@',%d,'%@',%d,%d,%d);",
                           [OTISConfig EmployeeID],
                           (int)item.ScheduleID,
                           [NSString stringWithFormat:@"%ld",[NSDate sinceDistantPastTime]],
                           attitude,
                           quality,
                           comment == nil ?@"":comment,
                           isAbsent,
                           customer,
                           isAbsent==1?@"":signature,
                           isEmail,
                           emailAddr,
                           0,
                           signId,
                           0];
                    
                }
                SZLog(@"SQL 客户签字插入更新%@",sql);
                ret =[db executeUpdate:sql];
                
                if (ret) {
                }else{
                    SZLog(@"错误：客户签字t_Signature表插入数据失败");
                }
                
                // 更新计划表中的状态
                [SZTable_Schedules updateIsComplete:3 andScheduleID:(int)item.ScheduleID];
            }
            
        }else{//客户不在
            int count = 0;

            for (SZFinalMaintenanceUnitItem *item in scheduleIDs) {
                NSString * comment = [USER_DEFAULT objectForKey:[NSString stringWithFormat:@"Comments_%d",count]];
                count ++;
                NSString *sql ;
                
                sql = [NSString stringWithFormat:@"UPDATE t_Report SET IsAbsent=1,ItemDate=%ld WHERE EmployeeID='%@' AND ScheduleId=%d AND IsRepairItem=0;",
                      [NSDate sinceDistantPastTime], [OTISConfig EmployeeID],(int)item.ScheduleID];
                
                BOOL ret =[db executeUpdate:sql];
                if (!ret) {
                    SZLog(@"错误：客户签字t_Signature update t_Report失败！！！");
                }
                
                NSInteger RouteNoCount = 0;
                FMResultSet *set = [db executeQueryWithFormat:@"SELECT count() as RouteNoCount from t_Signature WHERE ScheduleID = %d AND EmployeeID = %@ AND IsUploaded = 0;",(int)item.ScheduleID,[OTISConfig EmployeeID]];
                while ([set next]) {
                    RouteNoCount = [set intForColumn:@"RouteNoCount"];
                }
                
                if (RouteNoCount ) {
                    sql = [NSString stringWithFormat:@"UPDATE t_Signature SET  \
                           Attitude = %d, \
                           Quality = %d , \
                           SignComment = '%@' , \
                           IsAbsent = %d , \
                           Customer = '%@', \
                           Signature = '%@' , \
                           IsEmail = %d , \
                           EmailAddr = '%@' , \
                           SinId = %d , \
                           SignDate = '%@' \
                           WHERE EmployeeID = %@ AND ScheduleID = %d",0,0,
                           comment == nil ?@"":comment,
                           isAbsent,customer,
                           isAbsent==1?@"":signature,
                           0,emailAddr,
                           signId,[NSString stringWithFormat:@"%ld",
                          [NSDate sinceDistantPast]],[OTISConfig EmployeeID],(int)item.ScheduleID];
                    
                }else{
                    sql = [NSString stringWithFormat:@"INSERT INTO t_Signature (\
                           EmployeeID,\
                           ScheduleID ,\
                           SignDate,\
                           Attitude,\
                           Quality ,\
                           SignComment ,\
                           IsAbsent ,\
                           Customer ,\
                           Signature ,\
                           IsEmail ,\
                           EmailAddr ,\
                           IsImageUploaded,\
                           SinId, \
                           IsUploaded) VALUES ('%@',%d,'%@', %d,%d, '%@',%d, '%@','%@',%d,'%@',%d,%d,%d);",
                           [OTISConfig EmployeeID],
                           (int)item.ScheduleID,
                           [NSString stringWithFormat:@"%ld",[NSDate sinceDistantPast]],
                           0,
                           0,
                           signComment == nil ?@"":signComment,
                           isAbsent,
                           customer,
                           isAbsent==1?@"":signature,
                           0,
                           emailAddr,
                           0,
                           signId,
                           0];
                    
                }
                SZLog(@"SQL客户签字:%@",sql);
                ret =[db executeUpdate:sql];
                
                if (!ret) {
                    SZLog(@"错误：客户签字 t_Signature表插入数据失败");
                }
            }
        }
    }];
}

/**
 *  保存SignatureDB（IsUploaded）
 */
+(void)uploadedwithSignId:(int)signid{
    
    [OTISDB inDatabase:^(FMDatabase *db) {

        NSString *strEmployeeID = [OTISConfig EmployeeID];
        BOOL ret=0;
        
        // 签字完成，将签字列表中的签字项目删除
        NSString *sql = [NSString stringWithFormat:@"\
                         SELECT ScheduleID \
                         FROM t_Signature \
                         WHERE EmployeeID= '%@' AND IsUploaded =0 AND IsAbsent=0 AND SinId = %d;",
                         [OTISConfig EmployeeID],signid];
        
        SZLog(@"SQL 签字完成：%@",sql);
        FMResultSet *set1 = [db executeQuery:sql];
        while ([set1 next]) {
            int ScheduleID = [set1 intForColumn:@"ScheduleID"];
            
            // 将保养项目列表中的保养项删除
            sql = [NSString stringWithFormat:@" DELETE \
                                                FROM t_REPORT_ITEM_COMPLETE_STATE  \
                                                WHERE  ScheduleId=%d ;",
                                                ScheduleID];
            ret = [db executeUpdate:sql];
            if (!ret) {
                SZLog(@"SQL 签字完删除保养项:%@",sql);
                SZLog(@"错误：签字完成 删除t_REPORT_ITEM_COMPLETE_STATE中的保养项失败");
            }
        }
        
        sql = [NSString stringWithFormat:@"DELETE \
                                            FROM t_Signature \
                                            WHERE   EmployeeID= '%@' \
                                                    AND IsUploaded =0 \
                                                    AND IsAbsent=0 AND SinId = %d;",
                                            strEmployeeID,signid];
        ret = [db executeUpdate:sql];
        if (!ret) {
            SZLog(@"SQL 签字完成删除已经上传的签字信息:%@",sql);
            SZLog(@"错误：签字完成 删除已经上传的签字信息");
        }
    }];
    
}

/**
 *  保存SignatureDB（IsUploaded）
 */
+(void)uploadedImagewithSignId:(int)scheduleID{
    
    [OTISDB inDatabase:^(FMDatabase *db) {
        
        NSString *strEmployeeID = [OTISConfig EmployeeID];
        
        BOOL ret = [db executeUpdateWithFormat:@"UPDATE t_Signature SET  IsImageUploaded = %d WHERE ScheduleID = %d AND EmployeeId = %@;",1,scheduleID,strEmployeeID];
        if (ret) {
        }else{
            SZLog(@"错误：保存Signature更新失败");
        }
    }];
}


/**
 *  删除维保图片（IsUploaded）
 */
+(void)uploadedWeibaoImagewithScheduleID:(int)scheduleID{
    
    [OTISDB inDatabase:^(FMDatabase *db) {
        
        NSString *strEmployeeID = [OTISConfig EmployeeID];
        
        BOOL ret2 = [db executeUpdateWithFormat:@"UPDATE t_Report SET ItemPhoto='0' WHERE EmployeeID=%@ AND ScheduleId=%d ;",strEmployeeID,scheduleID];
        if (ret2) {
        }else{
            SZLog(@"错误：删除维保图片t_Signature更新失败");
        }
    }];
    
}


/**
 *  根据请求参数去沙盒中加载缓存的Signature数据
 *
 *  @param params 请求参数
 */
+(NSArray *)readSignatureWithParams:(NSDictionary *)params{

    return nil;
}


+(void)deleteImagewithScheduleID:(int)scheduleID{
    
    [OTISDB inDatabase:^(FMDatabase *db) {
        
        NSString *strEmployeeID = [OTISConfig EmployeeID];
        
        BOOL ret = [db executeUpdateWithFormat:@"UPDATE t_Report SET  ItemPhoto = '0' WHERE ScheduleID = %d AND EmployeeId = %@;",scheduleID,strEmployeeID];
        if (ret) {
        }else{
            SZLog(@"错误：deleteImagewithScheduleID 更新失败");
        }
        
        
    }];
    
}


@end
