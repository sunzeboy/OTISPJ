//
//  SZTable_Report.m
//  OTIS_PJ
//
//  Created by sunze on 16/5/25.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "SZTable_Report.h"
#import "TablesAndFields.h"
#import "NSDate+Extention.h"
#import "SZModuleQueryTool.h"

@implementation SZAdjustment


@end


@implementation SZReportQuestionItem


@end

@implementation SZMaintenanceRemarks

+(instancetype)remarkWithQuestion:(NSString *)question isrepiar:(BOOL)isrepiar isreplace:(BOOL)isresplace{
    SZMaintenanceRemarks *remark = [[SZMaintenanceRemarks alloc] init];
    remark.Question = question ;
    remark.isRepair = isrepiar ;
    remark.isReplace = isresplace ;
    return remark;
}

@end

@implementation SZTable_Report





/**
 *  非Fix维保项JHA完成操作
 */
+(void)storageJHAWithDetialItem:(SZFinalMaintenanceUnitDetialItem *)unitDetialItem andinputMode:(int)inputMode{
    
   
    [OTISDB inDatabase:^(FMDatabase *db) {
        /**
         *  如果有一样的jhaCodeId，先删除再存储
         */
        
        
        NSString *strEmployeeID = [OTISConfig EmployeeID];
        NSInteger scheduleID = unitDetialItem.ScheduleID;
        NSInteger miaoshu = [NSDate sinceDistantPastTime];
       
        FMResultSet *set = [db executeQueryWithFormat:@"select count() as reportCount from t_Report \
                                                        WHERE ScheduleId = %ld \
                                                                AND EmployeeId = %@ \
                                                                AND IsRepairItem=0;",
                                                    (long)scheduleID,strEmployeeID];
        int reportCount=0;
        
        while ([set next]) {
            reportCount = [set intForColumn:@"reportCount"];
        }
        
        BOOL ret=0;
        NSString * sql;
        
        if (reportCount) {
            // 只要有更新，保养时间就修改了，IsUploaded=0需要设置，此时代表需要上传维保记录
            
            // 如果LastStatus是同步下来的，更新的时候，需要将其设置为2状态，否则不更新LastStatus状态
            
            int curLastStatus =-1;
            NSString *sql = [NSString stringWithFormat:@"SELECT LastStatus \
                              FROM t_Report \
                              WHERE  ScheduleId=%ld \
                                    AND EmployeeID='%@' \
                                    AND IsRepairItem=0;",
                              (long)scheduleID,
                              strEmployeeID];
            SZLog(@"SQL JHA 查询维保中report记录数:%@",sql);
            FMResultSet *setRepair = [db executeQuery:sql];
            while ([setRepair next]) {
                curLastStatus = [setRepair intForColumn:@"LastStatus"];
            }
            
            if(inputMode==2){ // 灰色进入的时候，不需要修改上传状态
                if(curLastStatus==-1){
                    sql =[NSString stringWithFormat:@"UPDATE t_Report \
                          SET  JhaDate = %ld ,LastStatus=2 \
                          WHERE ScheduleId = %ld \
                                AND EmployeeId = %@  \
                                AND IsRepairItem=0;",
                          (long)miaoshu,(long)scheduleID,strEmployeeID];
                    SZLog(@"SQL JHA保存report:%@",sql);
                    ret = [db executeUpdate:sql];
                    
                    SZLog(@"SQL JHA保存report:%@",sql);
                    if (ret) {
                        SZLog(@"成功：JHA 操作report表1");
                    }else{
                        SZLog(@"错误：JHA 操作report表1");
                    }

                }else{
                    
                    sql =[NSString stringWithFormat:@"UPDATE t_Report SET  JhaDate = %ld  \
                          WHERE ScheduleId = %ld \
                                AND EmployeeId = %@ \
                                AND IsRepairItem=0;",
                          (long)miaoshu,(long)scheduleID,strEmployeeID];
                    ret = [db executeUpdate:sql];
                    
                    SZLog(@"SQL JHA保存report:%@",sql);
                    if (ret) {
                        SZLog(@"成功：JHA 操作report表2");
                    }else{
                        SZLog(@"错误：JHA 操作report表3");
                    }
                }
            }else{
                if(curLastStatus==-1){
                    sql =[NSString stringWithFormat:@"UPDATE t_Report SET  JhaDate = %ld ,IsUploaded=0 ,LastStatus=2 \
                          WHERE ScheduleId = %ld \
                                AND EmployeeId = %@ \
                                AND  IsRepairItem=0;",
                          (long)miaoshu,(long)scheduleID,strEmployeeID];
                    ret = [db executeUpdate:sql];
                    
                    SZLog(@"SQL JHA保存report:%@",sql);
                    if (ret) {
                        SZLog(@"成功：JHA 操作report表3");
                    }else{
                        SZLog(@"错误：JHA 操作report表3");
                    }
                }else{
                    sql =[NSString stringWithFormat:@"UPDATE t_Report SET  JhaDate = %ld ,IsUploaded=0 \
                          WHERE ScheduleId = %ld \
                                AND EmployeeId = %@ \
                                AND IsRepairItem=0;",
                          (long)miaoshu,(long)scheduleID,strEmployeeID];
                    ret = [db executeUpdate:sql];
                    
                    SZLog(@"SQL JHA保存report:%@",sql);
                    if (ret) {
                        SZLog(@"成功：JHA 操作report表4");
                    }else{
                        SZLog(@"错误：JHA 操作report表4");
                    }
                    
                }
            }
        }else{
            sql =[NSString stringWithFormat:@"INSERT INTO t_Report (\
                  EmployeeId, \
                  ScheduleId, \
                  JhaDate,\
                  IsUploaded,\
                  IsAbsent,\
                  IsRepair,\
                  IsReplace,\
                  LastStatus,\
                  IsRepairItem)\
                  VALUES (\
                  %@,%ld,%ld,%d,%d,%d,%d,%d,%d);",
                  strEmployeeID,
                  (long)scheduleID,
                  (long)miaoshu,
                  0,0,0,0,2,0];
            
            ret = [db executeUpdate:sql];
            
            SZLog(@"SQL JHA保存report:%@",sql);
            if (ret) {
                SZLog(@"成功：JHA 操作report表5");
            }else{
                SZLog(@"错误：JHA 操作report表5");
            }
        }
       
    
    }];
    

    // 正常保养完成，将complate更新;维修换件不做完成进度标示
    if (inputMode == 0 && unitDetialItem.isFixMode==NO) {
        
        //更新IsComplete
        [SZTable_Schedules updateIsComplete:1 andScheduleID:(int)unitDetialItem.ScheduleID];
    }
    
}

/**
 *  保养项目完成，更新report数据和状态
 */
+(void)storageCheckItemWithDetialItem:(SZFinalMaintenanceUnitDetialItem *)unitDetialItem andLastStatus:(int)lastStatus andRemark:(SZMaintenanceRemarks *)remark{

    [OTISDB inDatabase:^(FMDatabase *db) {
    
        NSString *strEmployeeID = [OTISConfig EmployeeID];
        NSInteger scheduleID = unitDetialItem.ScheduleID;
        NSInteger miaoshu = [NSDate sinceDistantPastTime];
        
        BOOL ret = [db executeUpdateWithFormat:@"UPDATE t_Report SET  ItemDate = %ld, LastStatus = %d,Question = %@,IsRepair = %d,IsReplace = %d  \
                    WHERE ScheduleId = %ld AND EmployeeId = %@ AND IsRepairItem=0;",
                    (long)miaoshu,lastStatus,remark.Question,remark.isRepair,remark.isReplace,(long)scheduleID,strEmployeeID];
        if (ret) {
            SZLog(@"t_Report更新成功！！！");
        }else{
            SZLog(@"t_Report更新失败！！！");
        }
    }];

    /**
     *  保存图片
     */
    [SZTable_Report storageItemPhotoWithDetialItem:unitDetialItem];
}

/**
 *  保养项目完成，更新report数据和状态
 */
+(void)updateReportState:(SZFinalMaintenanceUnitDetialItem *)unitDetialItem {
    
    [OTISDB inDatabase:^(FMDatabase *db) {
        
        NSString *strEmployeeID = [OTISConfig EmployeeID];
        NSInteger scheduleID = unitDetialItem.ScheduleID;
        
        BOOL ret = [db executeUpdateWithFormat:@"UPDATE t_Report SET   LastStatus = 0 \
                    WHERE ScheduleId = %ld AND EmployeeId = %@ AND IsRepairItem=0;",
                    (long)scheduleID,strEmployeeID];
        if (ret) {
            SZLog(@"t_Report更新成功！！！");
        }else{
            SZLog(@"t_Report更新失败！！！");
        }
    }];
    

}


// 维修换件项更新的时候，保存更新状态
+(void)updateCheckItemWithDetialItemForFix:(NSMutableArray *)datas andCheckItem:(SZFinalMaintenanceUnitDetialItem *)item1 isModify:(BOOL)isModify{
    
    [OTISDB inDatabase:^(FMDatabase *db) {

        NSString *strEmployeeID = [OTISConfig EmployeeID];
        
        for (SZMaintenanceCheckItem * item in datas) {
            if (item.ischanged) {
                SZLog(@"item.ischanged: %d ---- ",item.ischanged);

                NSString *sql = [NSString stringWithFormat:@"UPDATE t_FIX_DOWNLOAD SET State = %d \
                                 WHERE ScheduleId = %d AND  ItemCode = '%@' ;",
                                 item.state,(int)item1.ScheduleID,item.ItemCode];
                BOOL ret = [db executeUpdate:sql];
                
                if (ret) {
                    
                }else{
                    SZLog(@"错误：t_FIX_DOWNLOAD更新失败！！！");
                }
            }
            
        }
        
        FMResultSet *set = [db executeQueryWithFormat:@"SELECT count() as modifyCount \
                            FROM t_FIX_DOWNLOAD \
                            WHERE ScheduleId = %ld AND State=2",(long)item1.ScheduleID];
        
        while ([set next]) {
            int modifyCount = [set intForColumn:@"modifyCount"];
            
            NSInteger miaoshu = [NSDate sinceDistantPastTime];
            NSString *sql = [NSString stringWithFormat:@"UPDATE t_Report SET ItemDate = %ld ,IsUploaded=%d\
                             WHERE ScheduleId = %d AND EmployeeId = '%@' AND IsRepairItem=1;",
                             (long)miaoshu,
                             modifyCount>0?0:1,
                             (int)item1.ScheduleID,
                             strEmployeeID];
              
            BOOL ret = [db executeUpdate:sql];
                
            if (ret) {
                    
            }else{
                SZLog(@"错误：t_Report更新失败！！！");
            }
        }
  
    }];

}


// 正常维保有更新，则将上传状态更改为
+(void)updateCheckItemWithDetialItem2:(NSMutableArray *)datas andCheckItem:(SZFinalMaintenanceUnitDetialItem *)item1 isModify:(BOOL)isModify{
    
    [OTISDB inDatabase:^(FMDatabase *db) {
        
        NSString *strEmployeeID = [OTISConfig EmployeeID];
        
        for (SZMaintenanceCheckItem * item in datas) {
            // 只要有保养项更新则，更新report表
            if (item.ischanged) {
                
                NSInteger miaoshu = [NSDate sinceDistantPastTime];

                    NSString *sql = [NSString stringWithFormat:@"UPDATE t_Report SET  IsUploaded = 0 ,ItemDate = %ld \
                                     WHERE ScheduleId = %d AND EmployeeId = '%@' AND IsRepairItem=0;",
                                     (long)miaoshu,(int)item1.ScheduleID,strEmployeeID];
                    
                    BOOL ret = [db executeUpdate:sql];
                    
                    if (ret) {
                        
                    }else{
                        SZLog(@"错误：正常维保有更新 t_REPORT_ITEM_COMPLETE_STATE更新失败！！！");
                    }
                    break;
            }
        }
        
    }];
}



/**
 *  维保，保存照片名称信息到report表
 */
+(void)storageItemPhotoWithDetialItem:(SZFinalMaintenanceUnitDetialItem *)unitDetialItem{
    
    [OTISDB inDatabase:^(FMDatabase *db) {
   
        NSString *strEmployeeID = [OTISConfig EmployeeID];
        
        NSInteger scheduleID = unitDetialItem.ScheduleID;
        
        NSString *strPhotoName = [self itemPhotoNameStrWithScheduleId:[NSString stringWithFormat:@"%ld",(long)scheduleID]];
        if (strPhotoName.length>0) {
            FMResultSet *set = [db executeQueryWithFormat:@"SELECT count() as reportCount \
                                FROM t_Report \
                                WHERE ScheduleId = %ld AND EmployeeId = %@  AND IsRepairItem=0;",(long)scheduleID,strEmployeeID];
            while ([set next]) {
                int reportCount = [set intForColumn:@"reportCount"];
                if (reportCount) {
                    BOOL ret = [db executeUpdateWithFormat:@"UPDATE t_Report SET  ItemPhoto = %@ \
                                WHERE ScheduleId = %ld AND EmployeeId = %@;",strPhotoName,(long)scheduleID,strEmployeeID];
                    if (ret) {
                        SZLog(@"ItemPhoto更新成功");
                    }else{
                        SZLog(@"错误：ItemPhoto更新失败1");
                    }
                }else{
                    BOOL ret = [db executeUpdateWithFormat:@"INSERT INTO t_Report (EmployeeId, ScheduleId, ItemPhoto) \
                                VALUES (%@,%ld,%@ );",
                                strEmployeeID,(long)scheduleID,strPhotoName];
                    
                    if (ret) {
                        SZLog(@"ItemPhoto插入成功！！！");
                    }else{
                        SZLog(@"错误：ItemPhoto插入失败2");
                    }
                }
            }
        }
        
        
        
        
    }];
    
}


+(NSString *)itemPhotoNameStrWithScheduleId:(NSString *)scheduleId{
    NSString *strPath = [NSString stringWithFormat:@"%@_%@",[OTISConfig EmployeeID],scheduleId];
    NSString *path=PicDataDir(strPath); // 要列出来的目录
    
    NSFileManager *myFileManager=[NSFileManager defaultManager];
    
    NSDirectoryEnumerator *myDirectoryEnumerator;
    
    myDirectoryEnumerator=[myFileManager enumeratorAtPath:path];

    NSMutableString *strF = [NSMutableString string];
    while((path=[myDirectoryEnumerator nextObject])!=nil){
        [strF appendString:path];
        [strF appendString:@";"];
        
    }
    return strF;

}


/**
 *  保存中断信息
 */
+(void)storageWithAdjustmentType:(NSString *)adjustmentType adjustmentComment:(NSString *)adjustmentComment andDetialItem:(SZFinalMaintenanceUnitDetialItem *)unitDetialItem{
    
    [OTISDB inDatabase:^(FMDatabase *db) {
       
        NSString *strEmployeeID = [OTISConfig EmployeeID];
        
        NSInteger scheduleID = unitDetialItem.ScheduleID;
        
        FMResultSet *set = [db executeQueryWithFormat:@"select count() as reportCount from t_Report \
                            WHERE ScheduleId = %ld AND EmployeeId = %@ AND IsRepairItem=0;",
                            (long)scheduleID,strEmployeeID];
        while ([set next]) {
            int reportCount = [set intForColumn:@"reportCount"];
            if (reportCount) {
                BOOL ret = [db executeUpdateWithFormat:@"UPDATE t_Report SET  AdjustmentType = %@ ,AdjustmentComment = %@  \
                            WHERE ScheduleId = %ld AND EmployeeId = %@ AND IsRepairItem=0;",adjustmentType,adjustmentComment,(long)scheduleID,strEmployeeID];
                if (ret) {
                    SZLog(@"Adjustment更新成功！！！");
                }else{
                    SZLog(@"Adjustment更新失败！！！");
                }
            }else{
                BOOL ret = [db executeUpdateWithFormat:@"INSERT INTO t_Report (EmployeeId, ScheduleId, AdjustmentType,AdjustmentComment,AdjustmentHours,IsRepairItem) \
                            VALUES (%@,%ld,%@,%@,%d,0);",strEmployeeID,(long)scheduleID,adjustmentType,adjustmentComment,0];
                if (ret) {
                    SZLog(@"Adjustment插入成功！！！");
                }else{
                    SZLog(@"错误：Adjustment插入失败！！！");
                }
            }
        }
        
        
        
    }];
    
}
/**
 *  中断后，查询终端原因和类型
 */
+(SZAdjustment *)quarywithDetialItem:(SZFinalMaintenanceUnitDetialItem *)unitDetialItem{
    
    SZAdjustment *adjustment = [[SZAdjustment alloc] init];
    [OTISDB inDatabase:^(FMDatabase *db) {
        /**
         *  如果有一样的jhaCodeId，先删除再存储
         */
        NSString *strEmployeeID = [OTISConfig EmployeeID];
        
        NSInteger scheduleID = unitDetialItem.ScheduleID;
        
        FMResultSet *set = [db executeQueryWithFormat:@"SELECT AdjustmentType,AdjustmentComment \
                            FROM t_Report \
                            WHERE ScheduleId = %ld AND EmployeeId = %@ AND IsRepairItem=0;",
                            (long)scheduleID,strEmployeeID];
        while ([set next]) {
            adjustment.AdjustmentComment = [set stringForColumn:@"AdjustmentComment"];
            adjustment.AdjustmentType = [set stringForColumn:@"AdjustmentType"];

        }
        
    }];
    
    return adjustment;
}

/**
 *  维保上传完成操作
 */
+(void)storageIsUploaded:(BOOL )isUploaded withScheduleId:(int)scheduleId{

    /**
     *  (如果没有进行过正常维保操作就保存一条操作记录，如果有进行过完整的维保操作，就不保存)
     */
    [USER_DEFAULT setObject:@"" forKey:[NSString stringWithFormat:@"%d",scheduleId]];
    
    //检查一下如果是全做完的（除了每年一次），有99项的要删掉
    [USER_DEFAULT setObject:@(0) forKey:[NSString stringWithFormat:@"%d",(int)scheduleId]];
    
    [OTISDB inDatabase:^(FMDatabase *db) {
        BOOL ret=0;
        NSString *strEmployeeID = [OTISConfig EmployeeID];

        // 如果上传有Fix选项，则将Fix选项的数据插入更新到report和Fix表中;状态更新为未上传状态，后面就会上传
        
        // 获取维修换件项目的数量
        NSString *sql =[NSString stringWithFormat:@"SELECT count() AS fixItemCount \
                        FROM t_REPORT_ITEM_COMPLETE_STATE \
                        WHERE ScheduleId=%d AND EmployeeID='%@' AND isUpload=0 AND State=1;",scheduleId,strEmployeeID];
        
        FMResultSet *set = [db executeQuery:sql];
        int fixItemCount=0;
        while ([set next]) {
            fixItemCount = [set intForColumn:@"fixItemCount"];
        }
        // 存在
        if(fixItemCount>0){
        
            // 将新生成的维修换件记录保存到Fix表中
            sql =[NSString stringWithFormat:@"REPLACE INTO t_FIX_DOWNLOAD( \
                                        ScheduleId, \
                                        ItemCode, \
                                        State, \
                                        IsComplete) \
                            SELECT t_REPORT_ITEM_COMPLETE_STATE.ScheduleId, \
                            ItemCode, \
                            State, \
                            IsComplete \
                            FROM t_REPORT_ITEM_COMPLETE_STATE ,t_Schedules \
                            WHERE t_REPORT_ITEM_COMPLETE_STATE.ScheduleId=%d \
                            AND t_REPORT_ITEM_COMPLETE_STATE.EmployeeID='%@' \
                            AND isUpload=0 \
                            AND State=1 \
                            AND t_Schedules.ScheduleID=t_REPORT_ITEM_COMPLETE_STATE.ScheduleId;",scheduleId,strEmployeeID];
            
            SZLog(@"%@",sql);
            ret = [db executeUpdate:sql];
            if(!ret){
                SZLog(@"REPLACE INTO t_FIX_DOWNLOAD失败!!");
            }
            // 更新report表，添加fix项，上传状态标志为未上传状态，后面就会上传了
            sql =[NSString stringWithFormat:@"REPLACE INTO t_Report( \
                  EmployeeID, \
                  ScheduleId, \
                  LastStatus, \
                  IsUploaded, \
                  ItemPhoto, \
                  ItemDate, \
                  JhaDate, \
                  IsRepairItem \
                  ) \
                  SELECT \
                          EmployeeID, \
                          ScheduleId, \
                          -1 AS LastStatus, \
                          0 AS IsUploaded, \
                          ItemPhoto, \
                          ItemDate, \
                          0 AS JhaDate, \
                          1 AS IsRepairItem \
                  FROM t_Report \
                  WHERE ScheduleId=%d AND EmployeeID='%@' AND IsRepairItem=0;",scheduleId,strEmployeeID];
            
            SZLog(@"%@",sql);
            ret = [db executeUpdate:sql];
            if(!ret){
                SZLog(@"错误：REPLACE INTO t_Report失败!!");
            }
        }
        
        // 客户在的情况下，上传完成后，将IsAbsent 设置为2;避免重复上传
        ret = [db executeUpdateWithFormat:@"UPDATE t_Report SET  IsAbsent = 2 \
                                    WHERE ScheduleId = %d AND EmployeeId = %@ AND IsRepairItem=0 AND IsUploaded=1;",
                        scheduleId,strEmployeeID];
        if (!ret) {
            SZLog(@"错误：户在的情况下，上传完成后，将IsAbsent 设置为2;避免重复上传");
        }
                
        // 修改上传状态
        sql = [NSString stringWithFormat:@"UPDATE t_REPORT_ITEM_COMPLETE_STATE SET isUpload=1 \
                         WHERE  EmployeeID='%@' AND ScheduleId=%d AND isUpload = 0 ",strEmployeeID,scheduleId];
        
        ret = [db executeUpdate:sql];
        if (!ret) {
            SZLog(@"错误：修改上传状态 UPDATE t_REPORT_ITEM_COMPLETE_STATE SET失败1");
        }
        
        // 更新上传状态
        ret = [db executeUpdateWithFormat:@"UPDATE t_Report SET  IsUploaded = %d \
               WHERE ScheduleId = %d AND EmployeeId = %@ AND IsRepairItem=0;",
               isUploaded,scheduleId,strEmployeeID];
        if (!ret) {
            SZLog(@"错误：IsUploaded更新失败！！！");
        }
        
        // 如果是仅仅添加的共识，还原状态为0
        sql = [NSString stringWithFormat:@"UPDATE t_Schedules SET AddLaborHoursState=0 WHERE ScheduleID=%d AND EmployeeID='%@' AND AddLaborHoursState=2;",scheduleId,strEmployeeID];
        ret = [db executeUpdate:sql];
        if (!ret) {
            SZLog(@"错误：修改上传状态 UPDATE t_REPORT_ITEM_COMPLETE_STATE SET失败2");
        }
        
        // 如果有工时删除工时信息,保养项目保存操作的时候，此操作执行无效，所以没有关系
        NSString *sql3 = [NSString stringWithFormat:@"DELETE FROM t_LaborHours WHERE EmployeeID='%@' AND ScheduleId=%d AND GroupID=0 ",strEmployeeID,scheduleId];
        SZLog(@"qqqq  %@",sql3);
        ret = [db executeUpdate:sql3];
        if (!ret) {
            SZLog(@"错误：清除维保t_LaborHours数据失败!");
        }
        
        // 删除位置信息
        ret = [db executeUpdateWithFormat:@"DELETE \
               FROM t_QRCode \
               WHERE GroupID=0 AND EmployeeID=%@ AND ScheduleID=%d AND IsFixItem=0;",
               strEmployeeID,scheduleId];
        if (!ret) {
            SZLog(@"错误：IsComplete更新失败1");
        }
        // 删除JHA信息
        ret = [db executeUpdateWithFormat:@"DELETE FROM t_JHA_USER_SELECTED_SCHEDULE_ITEM  \
                                            WHERE  EmployeeID=%@ AND ScheduleID=%d AND IsFixItem=0;",strEmployeeID,scheduleId];
        if (!ret) {
            SZLog(@"错误：IsComplete更新失败2");
        }
        
    }];
    
}

 // 判断非Fix维保是否已经上传
+(BOOL)quaryIsUploadedWithScheduleId:(int)scheduleId{

    __block int isUploaded = 0;
    __block int lastStatus = 0;

    [OTISDB inDatabase:^(FMDatabase *db) {
        /**
         *  如果有一样的jhaCodeId，先删除再存储
         */
        NSString *strEmployeeID = [OTISConfig EmployeeID];
        FMResultSet *set = [db executeQueryWithFormat:@"select IsUploaded,LastStatus from t_Report WHERE ScheduleId = %d AND EmployeeId = %@ AND IsRepairItem=0;",scheduleId,strEmployeeID];
        while ([set next]) {
            isUploaded = [set intForColumn:@"IsUploaded"];
            lastStatus = [set intForColumn:@"LastStatus"];
        }
    }];
    return isUploaded;
}


/**
 *  下载更新Report_Download表
 */
+(void)storageWithSZReportDowndload:(SZReport *)report{
    
    [OTISDB inDatabase:^(FMDatabase *db) {
       
        NSString *strEmployeeID = report.User;
        
        int scheduleID = report.ScheduleID;
        
        
        BOOL ret1 = [db executeUpdateWithFormat:@"INSERT INTO t_Report_Download (EmployeeId, ScheduleId,IsRepair,IsReplace,Question,IsComplete)\
                     VALUES (%@,%d,%d,%d,%@,%d);",
                     strEmployeeID,scheduleID,report.IsRepair,report.IsReplace,report.Question,report.IsComplete];
        if (ret1) {

        }else{
            SZLog(@"t_Report_Download插入失败！！！");
        }
       
        
    }];
    
}


// 查找维保备注的信息
+(SZMaintenanceRemarks *)quaryRemarkWithScheduleID:(int)scheduleID{

    SZMaintenanceRemarks *unitItem = [[SZMaintenanceRemarks alloc] init];

    [OTISDB inDatabase:^(FMDatabase *db) {
        FMResultSet *set = [db executeQueryWithFormat:@"select Question,IsRepair,IsReplace from t_Report WHERE ScheduleId = %d AND EmployeeId = %@ AND IsRepairItem=0;",scheduleID,[OTISConfig EmployeeID]];
        while ([set next]) {
            
            unitItem.Question = [set stringForColumn:@"Question"];
            unitItem.isRepair = [set intForColumn:@"IsRepair"];
            unitItem.isReplace = [set intForColumn:@"IsReplace"];
            
        }
    }];
    
    return unitItem;

}


@end
