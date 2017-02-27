//
//  SZTable_LaborHours.m
//  OTIS_PJ
//
//  Created by sunze on 16/6/3.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "SZTable_LaborHours.h"
#import "TablesAndFields.h"
#import "NSDate+Extention.h"
#import "SZLabor.h"
#import "SZTable_LaborType.h"
#import "SZCheckLookModel.h"
#import "NSString+Extention.h"
#import "SZUploadFullLaborHoursRequest.h"
#import "SZUploadMaintenancemRequest.h"
#import "FMResultSet+Extention.h"
#import "SZModuleQueryTool.h"
#import "AppDelegate.h"
#import "NSDate+Format.h"

@implementation SZLaborHoursItem

-(float)gongshi{
    float time1 = [NSString floatWithString:_Hour1Str];
    float time15 = [NSString floatWithString:_Hour15Str];
    float time2 = [NSString floatWithString:_Hour2Str];
    float time3 = [NSString floatWithString:_Hour3Str];
    
    return time1+time15+time2+time3;
}

-(float)Hour1Rate{
    if (!_Hour1Rate) {
        return 0;
    }
    return _Hour1Rate;
}

-(NSString *)Hour1RateStr{
//    return [NSString stringWithFormat:@"%.2f",( (float)( (int)( (self.Hour1Rate+0.005)*100 ) ) )/100];
    return [NSString stringWithFormat:@"%.2f",[NSString floatWithString:_Hour1Str]];
}

-(NSString *)Hour1Str{
    if (!_Hour1Str) {
        return @"00:00";
    }
    return _Hour1Str;
}

-(NSString *)Hour1FormatStr{
    return [NSString stringWithFormat:@"%02d:%02d",(int)_Hour1Rate,(int)((_Hour1Rate-(int)_Hour1Rate)*60.00)];
}


-(float)Hour15Rate{
    if (!_Hour15Rate) {
        return 0;
    }
    return _Hour15Rate;
}
-(NSString *)Hour15RateStr{
//    return [NSString stringWithFormat:@"%.2f",( (float)( (int)( (self.Hour15Rate+0.005)*100 ) ) )/100];
    return [NSString stringWithFormat:@"%.2f",[NSString floatWithString:_Hour15Str]];

}
-(NSString *)Hour15Str{
    if (!_Hour15Str) {
        return @"00:00";
    }
    return _Hour15Str;
}
-(NSString *)Hour15FormatStr{
    return [NSString stringWithFormat:@"%02d:%02d",(int)_Hour15Rate,(int)((_Hour15Rate-(int)_Hour15Rate)*60.00)];
}


-(float)Hour2Rate{
    if (!_Hour2Rate) {
        return 0;
    }
    return _Hour2Rate;
}
-(NSString *)Hour2RateStr{
//    return [NSString stringWithFormat:@"%.2f",( (float)( (int)( (self.Hour2Rate+0.005)*100 ) ) )/100];
    return [NSString stringWithFormat:@"%.2f",[NSString floatWithString:_Hour2Str]];

}
-(NSString *)Hour2Str{
    if (!_Hour2Str) {
        return @"00:00";
    }
    return _Hour2Str;
}
-(NSString *)Hour2FormatStr{
    return [NSString stringWithFormat:@"%02d:%02d",(int)_Hour2Rate,(int)((_Hour2Rate-(int)_Hour2Rate)*60.00)];
}

-(float)Hour3Rate{
    if (!_Hour3Rate) {
        return 0;
    }
    return _Hour3Rate;
}
-(NSString *)Hour3RateStr{
//    return [NSString stringWithFormat:@"%.2f",( (float)( (int)( (self.Hour3Rate+0.005)*100 ) ) )/100];
    return [NSString stringWithFormat:@"%.2f",[NSString floatWithString:_Hour3Str]];

}
-(NSString *)Hour3Str{
    if (!_Hour3Str) {
        return @"00:00";
    }
    return _Hour3Str;
}
-(NSString *)Hour3FormatStr{
    return [NSString stringWithFormat:@"%02d:%02d",(int)_Hour3Rate,(int)((_Hour3Rate-(int)_Hour3Rate)*60.00)];
}


-(NSString *)CreateTimeStr{
    return [_CreateTime substringWithRange:NSMakeRange(10, 6)];
}

-(NSString *)LaborName{
    return [SZTable_LaborType quaryLaborNameWithLaborTypeID:_LaborTypeId];
}

@end

@implementation SZTable_LaborHours



/**
 *  保存t_LaborHours（工时）
 */
+(int)storageLaborHoursItems:(NSMutableArray *)items withScheduleID:(NSInteger)scheduleID andUnitNo:(NSString *)unitNo andOpration:(SZFinalMaintenanceUnitDetialItem *)opreationItem andGenerateDate:(NSString *)generateDate{

    __block int groupId = 1;
    [OTISDB inDatabase:^(FMDatabase *db) {
 
        FMResultSet *set = [db executeQueryWithFormat:@"SELECT MAX(GroupId) AS MaxSignId \
                            FROM t_LaborHours ;"];
        while ([set next]) {
            
            groupId = [set intForColumn:@"MaxSignId"]+1;
        }

        
        NSString *strEmployeeID = [OTISConfig EmployeeID];
        for (SZLabor *item in items) {
            
            if (item.item1.LaborTypeId) {
                SZLaborHoursItem *item1 = item.item1;
                if (item1.PUINo) {
                    NSString *sql = [NSString stringWithFormat:@"INSERT INTO t_LaborHours \
                                     (GenerateDate, \
                                     CreateTime, \
                                     CreateDate,\
                                     UpdateTime,\
                                     Hour1Rate,\
                                     Hour15Rate,\
                                     Hour2Rate,\
                                     Hour3Rate,\
                                     ScheduleId,\
                                     EmployeeId,\
                                     LaborTypeId,\
                                     Property,\
                                     GroupId,\
                                     PUINo,\
                                     UnitNo) \
                                     VALUES ('%@','%@','%@','%@','%@','%@','%@','%@',%d,'%@',%d,%d,%d,'%@','%@');",
                                     generateDate,
                                     [NSDate currentTime],
                                     [NSDate currentDate],
                                    [NSDate currentTime],
                                    item1.Hour1Str,
                                    item1.Hour15Str,
                                    item1.Hour2Str,
                                    item1.Hour3Str,
                                    (int)scheduleID,
                                    strEmployeeID,
                                    8,1,
                                    groupId,
                                    item1.PUINo,
                                    unitNo];
                    SZLog(@"SQL 插入工时 : %@",sql);
                    BOOL ret = [db executeUpdate:sql];
                    if (ret) {
                        SZLog(@"成功：t_LaborHours插入");
                    }else{
                        SZLog(@"失败 ：t_LaborHours插入");
                    }

                }else{
                    NSString *sql = [NSString stringWithFormat:@"INSERT INTO t_LaborHours \
                                     (GenerateDate,\
                                     CreateTime,\
                                     CreateDate,\
                                     Hour1Rate,\
                                     Hour15Rate,\
                                     Hour2Rate,\
                                     Hour3Rate,\
                                     ScheduleId,\
                                     EmployeeId,\
                                     LaborTypeId,\
                                     Property,\
                                     GroupId,\
                                     UnitNo) \
                                     VALUES ('%@','%@','%@','%@','%@','%@','%@',%d,'%@',%d,%d,%d,'%@');",
                                     generateDate,
                                     [NSDate currentTime],
                                     [NSDate currentDate],
                                     item1.Hour1Str,
                                     item1.Hour15Str,
                                     item1.Hour2Str,
                                     item1.Hour3Str,
                                     (int)scheduleID,
                                     strEmployeeID,
                                     item1.LaborTypeId,
                                     1,
                                     groupId,
                                     unitNo];
                    BOOL ret = [db executeUpdate:sql];
                    if (ret) {
                        SZLog(@"t_LaborHours插入成功！！！");
                    }else{
                        SZLog(@"t_LaborHours插入失败！！！");
                    }

                    
                }
               
            }else{
                SZLaborHoursItem *item1 = [[SZLaborHoursItem alloc] init];

                if (item1.PUINo) {
                    NSString *sql = [NSString stringWithFormat:@"INSERT INTO t_LaborHours ( \
                                     GenerateDate, \
                                     CreateTime, \
                                     CreateDate, \
                                     Hour1Rate, \
                                     Hour15Rate, \
                                     Hour2Rate, \
                                     Hour3Rate, \
                                     ScheduleId, \
                                     EmployeeId, \
                                     LaborTypeId, \
                                     Property, \
                                     GroupId, \
                                     PUINo, \
                                     UnitNo) VALUES ('%@','%@','%@','%@','%@','%@','%@',%d,'%@',%d,%d,%d,'%@','%@');",
                                     generateDate,
                                     [NSDate currentTime],
                                     [NSDate currentDate],
                                     item1.Hour1Str,
                                     item1.Hour15Str,
                                     item1.Hour2Str,
                                     item1.Hour3Str,
                                     (int)scheduleID,
                                     strEmployeeID,
                                     8,
                                     1,
                                     groupId,
                                     item1.PUINo,
                                     unitNo];
                    BOOL ret = [db executeUpdate:sql];
                    if (ret) {
                        SZLog(@"t_LaborHours插入成功！！！");
                    }else{
                        SZLog(@"t_LaborHours插入失败！！！");
                    }

                }else{
                    NSString *sql = [NSString stringWithFormat:@"INSERT INTO t_LaborHours (GenerateDate, CreateTime, CreateDate,Hour1Rate,Hour15Rate,Hour2Rate,Hour3Rate,ScheduleId,EmployeeId,LaborTypeId,Property,GroupId,UnitNo) VALUES ('%@','%@','%@','%@','%@','%@','%@',%d,'%@',%d,%d,%d,'%@');",generateDate,[NSDate currentTime],[NSDate currentDate],item1.Hour1Str,item1.Hour15Str,item1.Hour2Str,item1.Hour3Str,(int)scheduleID,strEmployeeID,item.LaborTypeID,1,groupId,unitNo];
                    BOOL ret = [db executeUpdate:sql];
                    
                    
                    if (ret) {
                        SZLog(@"t_LaborHours插入成功！！！");
                    }else{
                        SZLog(@"t_LaborHours插入失败！！！");
                    }

                
                
                }
               
            
            }
            
           
            if (item.item2.LaborTypeId) {
                
               
                 SZLaborHoursItem *item2 = item.item2;
                
                if (item2.PUINo) {
                    NSString *sql = [NSString stringWithFormat:@"INSERT INTO t_LaborHours (GenerateDate, CreateTime, CreateDate,Hour1Rate,Hour15Rate,Hour2Rate,Hour3Rate,ScheduleId,EmployeeId,LaborTypeId,Property,GroupId,PUINo,UnitNo) VALUES ('%@','%@','%@','%@','%@','%@','%@',%d,'%@',%d,%d,%d,'%@','%@');",generateDate,[NSDate currentTime],[NSDate currentDate],item2.Hour1Str,item2.Hour15Str,item2.Hour2Str,item2.Hour3Str,(int)scheduleID,strEmployeeID,26,1,groupId,item2.PUINo,unitNo];
                    BOOL ret = [db executeUpdate:sql];

                    
                    if (ret) {
                        SZLog(@"t_LaborHours插入成功！！！");
                    }else{
                        SZLog(@"t_LaborHours插入失败！！！");
                    }
                }else{
                    NSString *sql = [NSString stringWithFormat:@"INSERT INTO t_LaborHours (GenerateDate, CreateTime, CreateDate,Hour1Rate,Hour15Rate,Hour2Rate,Hour3Rate,ScheduleId,EmployeeId,LaborTypeId,Property,GroupId,UnitNo) VALUES ('%@','%@','%@','%@','%@','%@','%@',%d,'%@',%d,%d,%d,'%@');",generateDate,[NSDate currentTime],[NSDate currentDate],item2.Hour1Str,item2.Hour15Str,item2.Hour2Str,item2.Hour3Str,(int)scheduleID,strEmployeeID,item2.LaborTypeId,1,groupId,unitNo];
                    BOOL ret = [db executeUpdate:sql];
                    if (ret) {
                        SZLog(@"t_LaborHours插入成功！！！");
                    }else{
                        SZLog(@"t_LaborHours插入失败！！！");
                    }
                
                
                }
                
            }else{
                SZLaborHoursItem *item2 = item.item2;
                if (item2.PUINo) {
                    if ([SZTable_LaborType quaryLuTuLaborTypeIDWithLaborTypeID:item.LaborTypeID]) {
                        
                        NSString *sql = [NSString stringWithFormat:@"INSERT INTO t_LaborHours (GenerateDate, CreateTime, CreateDate,Hour1Rate,Hour15Rate,Hour2Rate,Hour3Rate,ScheduleId,EmployeeId,LaborTypeId,Property,GroupId,PUINo,UnitNo) VALUES ('%@','%@','%@','%@','%@','%@','%@',%d,'%@',%d,%d,%d,'%@','%@');",generateDate,[NSDate currentTime],[NSDate currentDate],item2.Hour1Str,item2.Hour15Str,item2.Hour2Str,item2.Hour3Str,(int)scheduleID,strEmployeeID,26,1,groupId,item2.PUINo,unitNo];
                        BOOL ret = [db executeUpdate:sql];
                        
                        if (ret) {
                            SZLog(@"t_LaborHours插入成功！！！");
                        }else{
                            SZLog(@"t_LaborHours插入失败！！！");
                        }
                        
                    }

                }else{
                
                    if ([SZTable_LaborType quaryLuTuLaborTypeIDWithLaborTypeID:item.LaborTypeID]) {
                        
                        NSString *sql = [NSString stringWithFormat:@"INSERT INTO t_LaborHours (GenerateDate, CreateTime, CreateDate,Hour1Rate,Hour15Rate,Hour2Rate,Hour3Rate,ScheduleId,EmployeeId,LaborTypeId,Property,GroupId,UnitNo) VALUES ('%@','%@','%@','%@','%@','%@','%@',%d,'%@',%d,%d,%d,'%@');",generateDate,[NSDate currentTime],[NSDate currentDate],item2.Hour1Str,item2.Hour15Str,item2.Hour2Str,item2.Hour3Str,(int)scheduleID,strEmployeeID,[SZTable_LaborType quaryLuTuLaborTypeIDWithLaborTypeID:item.LaborTypeID],1,groupId,unitNo];
                        BOOL ret = [db executeUpdate:sql];
                        
                        if (ret) {
                            SZLog(@"t_LaborHours插入成功！！！");
                        }else{
                            SZLog(@"t_LaborHours插入失败！！！");
                        }
                        
                    }
                
                
                }
                
                
                
            
            }
           

        }
        
        /**
         *  保存SZTable_QRCode（操作表）
         */
        [SZTable_QRCode storageWeiBaoWorkingHoursWithParams:opreationItem andGroupID:groupId withProperty:1];
        
        
    }];

    return groupId;
}


/**
 *  保存t_LaborHours（工时）
 */
+(void)storageLaborHoursItems:(NSMutableArray *)items withCONTACT_NO:(NSString *)contact_No  andCustomerName:(NSString *)customerName andGenerateDate:(NSString *)generateDate{
    
    
    [OTISDB inDatabase:^(FMDatabase *db) {
        
        int groupId = 1;
        FMResultSet *set = [db executeQueryWithFormat:@"SELECT MAX(GroupId) AS MaxSignId \
                            FROM t_LaborHours ;"];
        while ([set next]) {
            
            groupId = [set intForColumn:@"MaxSignId"]+1;
        }
        
        
        NSString *strEmployeeID = [OTISConfig EmployeeID];
        for (SZLabor *item in items) {
            
            if (item.item1.LaborTypeId) {
                SZLaborHoursItem *item1 = item.item1;
                if (item1.PUINo) {
                    BOOL ret = [db executeUpdateWithFormat:@"INSERT INTO t_LaborHours (GenerateDate, CreateTime, CreateDate,UpdateTime,Hour1Rate,Hour15Rate,Hour2Rate,Hour3Rate,EmployeeId,LaborTypeId,Property,GroupId,PUINo,ContactNo,UnitNo,CustomerName) VALUES (%@,%@,%@,%@,%@,%@,%@,%@,%@,%d,%d,%d,%@,%@,%@,%@);",generateDate,[NSDate currentTime],[NSDate currentDate],item1.UpdateTime,item1.Hour1Str,item1.Hour15Str,item1.Hour2Str,item1.Hour3Str,strEmployeeID,item1.LaborTypeId,4,groupId,item1.PUINo,contact_No,@"",customerName];
                    if (ret) {

                    }else{
                        SZLog(@"t_LaborHours插入失败！！！");
                    }
                    
                }else{
                    
                    BOOL ret = [db executeUpdateWithFormat:@"INSERT INTO t_LaborHours (GenerateDate, CreateTime, CreateDate,UpdateTime,Hour1Rate,Hour15Rate,Hour2Rate,Hour3Rate,EmployeeId,LaborTypeId,Property,GroupId,ContactNo,UnitNo,CustomerName) VALUES (%@,%@,%@,%@,%@,%@,%@,%@,%@,%d,%d,%d,%@,%@,%@);",generateDate,[NSDate currentTime],[NSDate currentDate],item1.UpdateTime,item1.Hour1Str,item1.Hour15Str,item1.Hour2Str,item1.Hour3Str,strEmployeeID,item1.LaborTypeId,4,groupId,contact_No,@"",customerName];
                    if (ret) {

                    }else{
                        SZLog(@"t_LaborHours插入失败！！！");
                    }
                    
                    
                }
                
            }else{
                SZLaborHoursItem *item1 = [[SZLaborHoursItem alloc] init];
                
                if (item1.PUINo) {
                    BOOL ret = [db executeUpdateWithFormat:@"INSERT INTO t_LaborHours (GenerateDate, CreateTime, CreateDate,UpdateTime,Hour1Rate,Hour15Rate,Hour2Rate,Hour3Rate,EmployeeId,LaborTypeId,Property,GroupId,PUINo,ContactNo,UnitNo,CustomerName) VALUES (%@,%@,%@,%@,%@,%@,%@,%@,%@,%d,%d,%d,%@,%@,%@,%@);",generateDate,[NSDate currentTime],[NSDate currentDate],item1.UpdateTime,item1.Hour1Str,item1.Hour15Str,item1.Hour2Str,item1.Hour3Str,strEmployeeID,item.LaborTypeID,4,groupId,item1.PUINo,contact_No,@"",customerName];
                    if (ret) {

                    }else{
                        SZLog(@"t_LaborHours插入失败！！！");
                    }
                    
                }else{
                    
                    BOOL ret = [db executeUpdateWithFormat:@"INSERT INTO t_LaborHours (GenerateDate, CreateTime, CreateDate,UpdateTime,Hour1Rate,Hour15Rate,Hour2Rate,Hour3Rate,EmployeeId,LaborTypeId,Property,GroupId,ContactNo,UnitNo,CustomerName) VALUES (%@,%@,%@,%@,%@,%@,%@,%@,%@,%d,%d,%d,%@,%@,%@);",generateDate,[NSDate currentTime],[NSDate currentDate],item1.UpdateTime,item1.Hour1Str,item1.Hour15Str,item1.Hour2Str,item1.Hour3Str,strEmployeeID,item.LaborTypeID,4,groupId,contact_No,@"",customerName];
                    if (ret) {

                    }else{
                        SZLog(@"t_LaborHours插入失败！！！");
                    }
                    
                    
                    
                }
                
                
            }
            
            
            if (item.item2.LaborTypeId) {
                
                
                SZLaborHoursItem *item2 = item.item2;
                
                if (item2.PUINo) {
                    BOOL ret1 = [db executeUpdateWithFormat:@"INSERT INTO t_LaborHours (GenerateDate, CreateTime, CreateDate,UpdateTime,Hour1Rate,Hour15Rate,Hour2Rate,Hour3Rate,EmployeeId,LaborTypeId,Property,GroupId,PUINo,ContactNo,UnitNo,CustomerName) VALUES (%@,%@,%@,%@,%@,%@,%@,%@,%@,%d,%d,%d,%@,%@,%@,%@);",generateDate,[NSDate currentTime],[NSDate currentDate],item2.UpdateTime,item2.Hour1Str,item2.Hour15Str,item2.Hour2Str,item2.Hour3Str,strEmployeeID,item2.LaborTypeId,4,groupId,item2.PUINo,contact_No,@"",customerName];
                    if (ret1) {

                    }else{
                        SZLog(@"t_LaborHours插入失败！！！");
                    }
                }else{
                    
                    BOOL ret1 = [db executeUpdateWithFormat:@"INSERT INTO t_LaborHours (GenerateDate, CreateTime, CreateDate,UpdateTime,Hour1Rate,Hour15Rate,Hour2Rate,Hour3Rate,EmployeeId,LaborTypeId,Property,GroupId,ContactNo,UnitNo,CustomerName) VALUES (%@,%@,%@,%@,%@,%@,%@,%@,%@,%d,%d,%d,%@,%@,%@);",generateDate,[NSDate currentTime],[NSDate currentDate],item2.UpdateTime,item2.Hour1Str,item2.Hour15Str,item2.Hour2Str,item2.Hour3Str,strEmployeeID,item2.LaborTypeId,4,groupId,contact_No,@"",customerName];
                    if (ret1) {

                    }else{
                        SZLog(@"t_LaborHours插入失败！！！");
                    }
                    
                    
                }
                
            }else{
                SZLaborHoursItem *item2 = item.item2;
                if (item2.PUINo) {
                    if ([SZTable_LaborType quaryLuTuLaborTypeIDWithLaborTypeID:item.LaborTypeID]) {
                        BOOL ret1 = [db executeUpdateWithFormat:@"INSERT INTO t_LaborHours (GenerateDate, CreateTime, CreateDate,UpdateTime,Hour1Rate,Hour15Rate,Hour2Rate,Hour3Rate,EmployeeId,LaborTypeId,Property,GroupId,PUINo,ContactNo,UnitNo,CustomerName) VALUES (%@,%@,%@,%@,%@,%@,%@,%@,%@,%d,%d,%d,%@,%@,%@,%@);",generateDate,[NSDate currentTime],[NSDate currentDate],item2.UpdateTime,item2.Hour1Str,item2.Hour15Str,item2.Hour2Str,item2.Hour3Str,strEmployeeID,[SZTable_LaborType quaryLuTuLaborTypeIDWithLaborTypeID:item.LaborTypeID],4,groupId,item2.PUINo,contact_No,@"",customerName];
                        if (ret1) {

                        }else{
                            SZLog(@"t_LaborHours插入失败！！！");
                        }
                        
                    }
                    
                }else{
                    
                    if ([SZTable_LaborType quaryLuTuLaborTypeIDWithLaborTypeID:item.LaborTypeID]) {
                        BOOL ret1 = [db executeUpdateWithFormat:@"INSERT INTO t_LaborHours (GenerateDate, CreateTime, CreateDate,UpdateTime,Hour1Rate,Hour15Rate,Hour2Rate,Hour3Rate,EmployeeId,LaborTypeId,Property,GroupId,ContactNo,UnitNo,CustomerName) VALUES (%@,%@,%@,%@,%@,%@,%@,%@,%@,%d,%d,%d,%@,%@,%@);",generateDate,[NSDate currentTime],[NSDate currentDate],item2.UpdateTime,item2.Hour1Str,item2.Hour15Str,item2.Hour2Str,item2.Hour3Str,strEmployeeID,[SZTable_LaborType quaryLuTuLaborTypeIDWithLaborTypeID:item.LaborTypeID],4,groupId,contact_No,@"",customerName];
                        if (ret1) {

                        }else{
                            SZLog(@"t_LaborHours插入失败！！！");
                        }
                        
                    }
                    
                    
                }
                
                
                
                
            }
            
            
        }
        
        
        
        
    }];
    
    
}


/**
 *  工时分摊
 */
+(void)storageLaborHoursItems:(NSMutableArray *)items withUnits:(NSArray *)units andGenerateDate:(NSString *)generateDate{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSMutableArray *unitsArray = [NSMutableArray array];
    for (SZFinalMaintenanceUnitItem *unitItem in units) {
     
        if (unitItem.selected == YES) {
            NSString *strUnitNo = [NSString stringWithFormat:@"%@",unitItem.UnitNo];
            [dic setValue:unitItem forKey:strUnitNo];
        }
    }
    
    for (SZFinalMaintenanceUnitItem *unitItem in dic.allValues) {
        if (unitItem.UnitNo) {
            [unitsArray addObject:unitItem.UnitNo];
        }else{
            [unitsArray addObject:@""];
            
        }
    }
    int length = (int)dic.allKeys.count;
    
    SZLabor *labor = [items lastObject];
    
    NSString *str1 = labor.item1.Hour1Str;
    NSString *str15 = labor.item1.Hour15Str;
    NSString *str2 = labor.item1.Hour2Str;
    NSString *str3 = labor.item1.Hour3Str;
    
    NSString *str21 = labor.item2.Hour1Str;
    NSString *str215 = labor.item2.Hour15Str;
    NSString *str22 = labor.item2.Hour2Str;
    NSString *str23 = labor.item2.Hour3Str;
    

    SZLaborHoursItem *item1 = [[SZLaborHoursItem alloc] init];
    SZLaborHoursItem *item2 = [[SZLaborHoursItem alloc] init];

    item1 = labor.item1;
    item2 = labor.item2;
    
    NSString *str1Per = [NSString perfenzhongWithString:str1 andCount:length];
    NSString *str15Per = [NSString perfenzhongWithString:str15 andCount:length];
    NSString *str2Per = [NSString perfenzhongWithString:str2 andCount:length];
    NSString *str3Per = [NSString perfenzhongWithString:str3 andCount:length];

    
    if (labor.item2.LaborTypeId) {
        
        NSString *str1Per2 = [NSString perfenzhongWithString:str21 andCount:length];
        NSString *str15Per2 = [NSString perfenzhongWithString:str215 andCount:length];
        NSString *str2Per2 = [NSString perfenzhongWithString:str22 andCount:length];
        NSString *str3Per2 = [NSString perfenzhongWithString:str23 andCount:length];

        item1.Hour1Str = str1Per;
        item1.Hour15Str = str15Per;
        item1.Hour2Str = str2Per;
        item1.Hour3Str = str3Per;
        
        
        item2.Hour1Str = str1Per2;
        item2.Hour15Str = str15Per2;
        item2.Hour2Str = str2Per2;
        item2.Hour3Str = str3Per2;

    }else{
        item1.Hour1Str = str1Per;
        item1.Hour15Str = str15Per;
        item1.Hour2Str = str2Per;
        item1.Hour3Str = str3Per;
    
    }
    
    
    NSString *str1s = [NSString shengyufenzhongstrWithString:str1 andCount:length];
    NSString *str15s = [NSString shengyufenzhongstrWithString:str15 andCount:length];
    NSString *str2s = [NSString shengyufenzhongstrWithString:str2 andCount:length];
    NSString *str3s = [NSString shengyufenzhongstrWithString:str3 andCount:length];
    
    NSString *str1s2 ;
    NSString *str15s2 ;
    NSString *str2s2 ;
    NSString *str3s2 ;
    if (labor.item2.LaborTypeId) {
        str1s2 = [NSString shengyufenzhongstrWithString:str21 andCount:length];
        str15s2 = [NSString shengyufenzhongstrWithString:str215 andCount:length];
        str2s2 = [NSString shengyufenzhongstrWithString:str22 andCount:length];
        str3s2 = [NSString shengyufenzhongstrWithString:str23 andCount:length];
    }
    
    
    
    [OTISDB inDatabase:^(FMDatabase *db) {
        
        int groupId = 1;
        FMResultSet *set = [db executeQueryWithFormat:@"SELECT MAX(GroupId) AS MaxSignId FROM t_LaborHours ;"];
        while ([set next]) {
            
            groupId = [set intForColumn:@"MaxSignId"];
        }

        
        
        NSString *strEmployeeID = [OTISConfig EmployeeID];

        for (int i=0;i<length;i++) {
            groupId += 1;
//            NSString *strScheduleID = dic.allKeys[i];
            SZFinalMaintenanceUnitItem *uItem = dic.allValues[i];
            NSInteger strScheduleID  = uItem.ScheduleID;
            if (i==length-1) {
                
                BOOL ret = [db executeUpdateWithFormat:@"INSERT INTO t_LaborHours (GenerateDate, CreateTime, CreateDate,UpdateTime,Hour1Rate,Hour15Rate,Hour2Rate,Hour3Rate,ScheduleId,EmployeeId,LaborTypeId,Property,GroupId,UnitNo) VALUES (%@,%@,%@,%@,%@,%@,%@,%@,%ld,%@,%d,%d,%d,%@);",generateDate,[NSDate currentTime],[NSDate currentDate],item1.UpdateTime,str1s,str15s,str2s,str3s,strScheduleID,strEmployeeID,item1.LaborTypeId,1,groupId,unitsArray[i]];
                if (ret) {
                    
                }else{
                    SZLog(@"t_LaborHours插入失败！！！");
                }
                
                
                if (labor.item2.LaborTypeId) {
                    BOOL ret = [db executeUpdateWithFormat:@"INSERT INTO t_LaborHours (GenerateDate, CreateTime, CreateDate,UpdateTime,Hour1Rate,Hour15Rate,Hour2Rate,Hour3Rate,ScheduleId,EmployeeId,LaborTypeId,Property,GroupId,UnitNo) VALUES (%@,%@,%@,%@,%@,%@,%@,%@,%ld,%@,%d,%d,%d,%@);",generateDate,[NSDate currentTime],[NSDate currentDate],item2.UpdateTime,str1s2,str15s2,str2s2,str3s2,strScheduleID,strEmployeeID,item2.LaborTypeId,1,groupId,unitsArray[i]];
                    if (ret) {
                        
                    }else{
                        SZLog(@"t_LaborHours插入失败！！！");
                    }
                    
                }
                
                SZFinalMaintenanceUnitDetialItem *itemD = [SZModuleQueryTool queryGongshiDetialMaintenanceWithUnitNo:uItem.UnitNo];
                itemD.Reason = 6;
                itemD.ScheduleID = strScheduleID;
                
                /**
                 *  更新t_QRCode
                 */
                [SZTable_QRCode storageWeiBaoWorkingHoursWithParams:itemD andGroupID:groupId withProperty:1];

                continue;
            }
            
            BOOL ret = [db executeUpdateWithFormat:@"INSERT INTO t_LaborHours (GenerateDate, CreateTime, CreateDate,UpdateTime,Hour1Rate,Hour15Rate,Hour2Rate,Hour3Rate,ScheduleId,EmployeeId,LaborTypeId,Property,GroupId,UnitNo) VALUES (%@,%@,%@,%@,%@,%@,%@,%@,%ld,%@,%d,%d,%d,%@);",generateDate,[NSDate currentTime],[NSDate currentDate],item1.UpdateTime,item1.Hour1Str,item1.Hour15Str,item1.Hour2Str,item1.Hour3Str,strScheduleID,strEmployeeID,item1.LaborTypeId,1,groupId,unitsArray[i]];
            if (ret) {

            }else{
                SZLog(@"t_LaborHours插入失败！！！");
            }
            
            
            if (labor.item2.LaborTypeId) {
                BOOL ret = [db executeUpdateWithFormat:@"INSERT INTO t_LaborHours (GenerateDate, CreateTime, CreateDate,UpdateTime,Hour1Rate,Hour15Rate,Hour2Rate,Hour3Rate,ScheduleId,EmployeeId,LaborTypeId,Property,GroupId,UnitNo) VALUES (%@,%@,%@,%@,%@,%@,%@,%@,%ld,%@,%d,%d,%d,%@);",generateDate,[NSDate currentTime],[NSDate currentDate],item2.UpdateTime,item2.Hour1Str,item2.Hour15Str,item2.Hour2Str,item2.Hour3Str,strScheduleID,strEmployeeID,item2.LaborTypeId,1,groupId,unitsArray[i]];
                if (ret) {

                }else{
                    SZLog(@"t_LaborHours插入失败！！！");
                }

            }
            
         SZFinalMaintenanceUnitDetialItem *itemD = [SZModuleQueryTool queryGongshiDetialMaintenanceWithUnitNo:uItem.UnitNo];
            itemD.Reason = 6;
            itemD.ScheduleID = strScheduleID;

            /**
             *  更新t_QRCode
             */
            [SZTable_QRCode storageWeiBaoWorkingHoursWithParams:itemD andGroupID:groupId withProperty:1];
        }
        
        
    }];

    
}

/**
 *  保存t_LaborHours（非生产性工时）
 */
+(void)storageFeiShengchanLaborHoursItems:(SZLaborHoursItem *)item {
    
    
    [OTISDB inDatabase:^(FMDatabase *db) {
   
        int groupId = 1;
        FMResultSet *set = [db executeQueryWithFormat:@"SELECT MAX(GroupId) AS MaxSignId \
                            FROM t_LaborHours ;"];
        while ([set next]) {
            
            groupId = [set intForColumn:@"MaxSignId"]+1;
        }
        
        BOOL ret = [db executeUpdateWithFormat:@"INSERT INTO t_LaborHours (GenerateDate, CreateTime, CreateDate,Hour1Rate,Hour15Rate,Hour2Rate,Hour3Rate,EmployeeId,LaborTypeId,Property,ScheduleId,GroupID,Remark) VALUES (%@,%@,%@,%@,%@,%@,%@,%@,%d,%d,%d,%d,%@);",item.GenerateDate,[NSDate currentTime],[NSDate currentDate],item.Hour1Str,item.Hour15Str,item.Hour2Str,item.Hour3Str,[OTISConfig EmployeeID],item.LaborTypeId,2 ,0,groupId,item.Remark];
        if (ret) {

        }else{
            SZLog(@"t_LaborHours插入失败！！！");
        }
        
        
        
    }];
    
    
}

+(void)updateFeiShengchanLaborHoursItems:(SZLaborHoursItem *)item {
    
    
    [OTISDB inDatabase:^(FMDatabase *db) {
        
        NSString *sql = [NSString stringWithFormat:@"UPDATE t_LaborHours SET GenerateDate = '%@',UpdateTime = '%@' ,Hour1Rate = '%@',Hour15Rate = '%@',Hour2Rate = '%@',Hour3Rate = '%@' ,Remark = '%@' WHERE EmployeeId = '%@' AND LaborTypeId = %d AND CreateTime = '%@' ",item.GenerateDate,[NSDate currentTime],item.Hour1Str,item.Hour15Str,item.Hour2Str,item.Hour3Str,item.Remark,[OTISConfig EmployeeID],item.LaborTypeId,item.CreateTime];
        BOOL ret = [db executeUpdate:sql];
        if (ret) {
            SZLog(@"t_LaborHours更新成功！！！");
        }else{
            SZLog(@"t_LaborHours更新失败！！！");
        }
        
        
        
    }];
    
    
}



/**
 *  更新t_LaborHours（工时）
 */
+(void)updateLaborHoursItems:(NSMutableArray *)items withScheduleID:(NSInteger)scheduleID andUnitNo:(NSString *)unitNo{
    
    
    [OTISDB inDatabase:^(FMDatabase *db) {
        
        NSString *strEmployeeID = [OTISConfig EmployeeID];
        /**
         *  如果有一样的scheduleID，先删除再存储
         */
        NSString *sqlQ = [NSString stringWithFormat:@"SELECT count(LaborTypeId) as LaborTypeIdCount FROM t_LaborHours WHERE EmployeeId = '%@' AND ScheduleId = %d AND Property in (0,3) AND GroupID = 0;",strEmployeeID,(int)scheduleID];
        FMResultSet *set = [db executeQuery:sqlQ];
        int laborTypeIdCount = 0;
        while ([set next]) {
            laborTypeIdCount = [set intForColumn:@"LaborTypeIdCount"];
        }
        if (laborTypeIdCount) {//updete
            NSString *sqlDelet = [NSString stringWithFormat:@"DELETE  FROM t_LaborHours WHERE EmployeeId = '%@' AND ScheduleId = %d AND Property in (0,3);",strEmployeeID,(int)scheduleID];
            BOOL ret = [db executeUpdate:sqlDelet];
            if (ret) {
                SZLog(@"删除t_LaborHours成功");
            }else{
                SZLog(@"删除t_LaborHours失败");
            }
            
        }
        for (SZLabor *item in items) {
            
            if (item.item1.LaborTypeId) {
                SZLaborHoursItem *item1 = item.item1;
                if (item1.PUINo) {
                   BOOL ret = [db executeUpdateWithFormat:@"INSERT INTO t_LaborHours (GenerateDate, CreateTime, CreateDate,UpdateTime,Hour1Rate,Hour15Rate,Hour2Rate,Hour3Rate,ScheduleId,EmployeeId,LaborTypeId,Property,GroupId,PUINo,UnitNo) VALUES (%@,%@,%@,%@,%@,%@,%@,%@,%d,%@,%d,%d,%d,%@,%@);",item1.GenerateDate,[NSDate currentTime],[NSDate currentDate],item1.UpdateTime,item1.Hour1Str,item1.Hour15Str,item1.Hour2Str,item1.Hour3Str,(int)scheduleID,strEmployeeID,item1.LaborTypeId,item1.Property,0,item1.PUINo,unitNo];
                    if (ret) {
                        
                    }else{
                        SZLog(@"t_LaborHours插入失败！！！");
                    }
                    
                }else{
                    BOOL ret = [db executeUpdateWithFormat:@"INSERT INTO t_LaborHours (GenerateDate, CreateTime, CreateDate,UpdateTime,Hour1Rate,Hour15Rate,Hour2Rate,Hour3Rate,ScheduleId,EmployeeId,LaborTypeId,Property,GroupId,UnitNo) VALUES (%@,%@,%@,%@,%@,%@,%@,%@,%d,%@,%d,%d,%d,%@);",item1.GenerateDate,[NSDate currentTime],[NSDate currentDate],item1.UpdateTime,item1.Hour1Str,item1.Hour15Str,item1.Hour2Str,item1.Hour3Str,(int)scheduleID,strEmployeeID,item1.LaborTypeId,item1.Property,0,unitNo];
                    if (ret) {
                        
                    }else{
                        SZLog(@"t_LaborHours插入失败！！！");
                    }
                    
                    
                }
                
            }else{
                SZLaborHoursItem *item1 = [[SZLaborHoursItem alloc] init];
                
                if (item1.PUINo) {
                    BOOL ret = [db executeUpdateWithFormat:@"INSERT INTO t_LaborHours (GenerateDate, CreateTime, CreateDate,UpdateTime,Hour1Rate,Hour15Rate,Hour2Rate,Hour3Rate,ScheduleId,EmployeeId,LaborTypeId,Property,GroupId,PUINo,UnitNo) VALUES (%@,%@,%@,%@,%@,%@,%@,%@,%d,%@,%d,%d,%d,%@,%@);",item1.GenerateDate,[NSDate currentTime],[NSDate currentDate],item1.UpdateTime,item1.Hour1Str,item1.Hour15Str,item1.Hour2Str,item1.Hour3Str,(int)scheduleID,strEmployeeID,item1.LaborTypeId,item1.Property,0,item1.PUINo,unitNo];
                    if (ret) {
                        
                    }else{
                        SZLog(@"t_LaborHours插入失败！！！");
                    }
                    
                }else{
                    
                    BOOL ret = [db executeUpdateWithFormat:@"INSERT INTO t_LaborHours (GenerateDate, CreateTime, CreateDate,UpdateTime,Hour1Rate,Hour15Rate,Hour2Rate,Hour3Rate,ScheduleId,EmployeeId,LaborTypeId,Property,GroupId,UnitNo) VALUES (%@,%@,%@,%@,%@,%@,%@,%@,%d,%@,%d,%d,%d,%@);",item1.GenerateDate,[NSDate currentTime],[NSDate currentDate],item1.UpdateTime,item1.Hour1Str,item1.Hour15Str,item1.Hour2Str,item1.Hour3Str,(int)scheduleID,strEmployeeID,item1.LaborTypeId,item1.Property,0,unitNo];
                    if (ret) {
                        
                    }else{
                        SZLog(@"t_LaborHours插入失败！！！");
                    }
                    
                    
                    
                }
                
                
            }

            
            
            if (item.item2.LaborTypeId) {
                SZLaborHoursItem *item2 = item.item2;
                if (item2.PUINo) {
                    BOOL ret = [db executeUpdateWithFormat:@"INSERT INTO t_LaborHours (GenerateDate, CreateTime, CreateDate,UpdateTime,Hour1Rate,Hour15Rate,Hour2Rate,Hour3Rate,ScheduleId,EmployeeId,LaborTypeId,Property,GroupId,PUINo,UnitNo) VALUES (%@,%@,%@,%@,%@,%@,%@,%@,%d,%@,%d,%d,%d,%@,%@);",item2.GenerateDate,[NSDate currentTime],[NSDate currentDate],item2.UpdateTime,item2.Hour1Str,item2.Hour15Str,item2.Hour2Str,item2.Hour3Str,(int)scheduleID,strEmployeeID,item2.LaborTypeId,item2.Property,0,item2.PUINo,unitNo];
                    if (ret) {
                        
                    }else{
                        SZLog(@"t_LaborHours插入失败！！！");
                    }
                    
                }else{
                    BOOL ret = [db executeUpdateWithFormat:@"INSERT INTO t_LaborHours (GenerateDate, CreateTime, CreateDate,UpdateTime,Hour1Rate,Hour15Rate,Hour2Rate,Hour3Rate,ScheduleId,EmployeeId,LaborTypeId,Property,GroupId,UnitNo) VALUES (%@,%@,%@,%@,%@,%@,%@,%@,%d,%@,%d,%d,%d,%@);",item2.GenerateDate,[NSDate currentTime],[NSDate currentDate],item2.UpdateTime,item2.Hour1Str,item2.Hour15Str,item2.Hour2Str,item2.Hour3Str,(int)scheduleID,strEmployeeID,item2.LaborTypeId,item2.Property,0,unitNo];
                    if (ret) {
                        
                    }else{
                        SZLog(@"t_LaborHours插入失败！！！");
                    }
                    
                    
                }
                
            }else{
                SZLaborHoursItem *item2 = [[SZLaborHoursItem alloc] init];

                if ([SZTable_LaborType quaryLuTuLaborTypeIDWithLaborTypeID:item.LaborTypeID]) {
                    if (item2.PUINo) {
                        BOOL ret = [db executeUpdateWithFormat:@"INSERT INTO t_LaborHours (GenerateDate, CreateTime, CreateDate,UpdateTime,Hour1Rate,Hour15Rate,Hour2Rate,Hour3Rate,ScheduleId,EmployeeId,LaborTypeId,Property,GroupId,PUINo,UnitNo) VALUES (%@,%@,%@,%@,%@,%@,%@,%@,%d,%@,%d,%d,%d,%@,%@);",item2.GenerateDate,[NSDate currentTime],[NSDate currentDate],item2.UpdateTime,item2.Hour1Str,item2.Hour15Str,item2.Hour2Str,item2.Hour3Str,(int)scheduleID,strEmployeeID,[SZTable_LaborType quaryLuTuLaborTypeIDWithLaborTypeID:item.LaborTypeID],item2.Property,0,item2.PUINo,unitNo];
                        if (ret) {
                            
                        }else{
                            SZLog(@"t_LaborHours插入失败！！！");
                        }
                        
                    }else{
                        
                        BOOL ret = [db executeUpdateWithFormat:@"INSERT INTO t_LaborHours (GenerateDate, CreateTime, CreateDate,UpdateTime,Hour1Rate,Hour15Rate,Hour2Rate,Hour3Rate,ScheduleId,EmployeeId,LaborTypeId,Property,GroupId,UnitNo) VALUES (%@,%@,%@,%@,%@,%@,%@,%@,%d,%@,%d,%d,%d,%@);",item2.GenerateDate,[NSDate currentTime],[NSDate currentDate],item2.UpdateTime,item2.Hour1Str,item2.Hour15Str,item2.Hour2Str,item2.Hour3Str,(int)scheduleID,strEmployeeID,[SZTable_LaborType quaryLuTuLaborTypeIDWithLaborTypeID:item.LaborTypeID],item2.Property,0,unitNo];
                        if (ret) {
                            
                        }else{
                            SZLog(@"t_LaborHours插入失败！！！");
                        }
                        
                        
                        
                    }
                }
                
             
                
                
            }
        }
            
            
            

        
        
        
        
        
        
    }];
    
    
}


+(void)updateLaborHoursItemsWithCheckLookModel:(SZCheckLookModel *)model andDeleteArray:(NSMutableArray *)deleteArray andDate:(NSString *)dateStr{

    [OTISDB inDatabase:^(FMDatabase *db) {
        
        NSString *strEmployeeID = [OTISConfig EmployeeID];

        if (model.laborHours && model.laborHours.count) {
            for (SZLaborHoursItem *item in model.laborHours) {
                
                
                if (!item.ContactNo) {
                    NSString *sql = @"";
                    if (model.feishengchanxing) {
                        sql = [NSString stringWithFormat:@"UPDATE  t_LaborHours SET GenerateDate = '%@' , UpdateTime = '%@',Hour1Rate = '%@',Hour15Rate= '%@',Hour2Rate= '%@',Hour3Rate= '%@' WHERE EmployeeId = '%@' AND CreateTime = '%@' AND LaborTypeId = %d ",dateStr,[NSDate currentTime],item.Hour1Str,item.Hour15Str,item.Hour2Str,item.Hour3Str,strEmployeeID,item.CreateTime,item.LaborTypeId];
                        
                    }else{
                        if (item.PUINo) {
                            sql = [NSString stringWithFormat:@"UPDATE  t_LaborHours SET GenerateDate = '%@' , UpdateTime = '%@',Hour1Rate = '%@',Hour15Rate= '%@',Hour2Rate= '%@',Hour3Rate= '%@' ,  PUINo = '%@' WHERE EmployeeId = '%@' AND ScheduleId = %d  AND CreateTime = '%@' AND LaborTypeId = %d AND GroupID = %d ",dateStr,[NSDate currentTime],item.Hour1Str,item.Hour15Str,item.Hour2Str,item.Hour3Str,item.PUINo,strEmployeeID,model.ScheduleID,item.CreateTime,item.LaborTypeId,item.GroupID];
                        }else{
                            sql = [NSString stringWithFormat:@"UPDATE  t_LaborHours SET GenerateDate = '%@' , UpdateTime = '%@',Hour1Rate = '%@',Hour15Rate= '%@',Hour2Rate= '%@',Hour3Rate= '%@'  WHERE EmployeeId = '%@' AND ScheduleId = %d  AND CreateTime = '%@' AND LaborTypeId = %d AND GroupID = %d ",dateStr,[NSDate currentTime],item.Hour1Str,item.Hour15Str,item.Hour2Str,item.Hour3Str,strEmployeeID,model.ScheduleID,item.CreateTime,item.LaborTypeId,item.GroupID];
                            
                        }
                        
                    }
                    
                    
                    SZLog(@"%@",sql);
                    BOOL ret = [db executeUpdate:sql];
                    if (ret) {
                        SZLog(@"t_LaborHours更新成功！！！");
                    }else{
                        SZLog(@"t_LaborHours更新失败！！！");
                    }
                    
                }else{
                    NSString *sql = @"";
                    if (item.PUINo) {
                        sql = [NSString stringWithFormat:@"UPDATE  t_LaborHours SET GenerateDate = '%@' , UpdateTime = '%@',Hour1Rate = '%@',Hour15Rate= '%@',Hour2Rate= '%@',Hour3Rate= '%@' , PUINo = '%@' WHERE EmployeeId = '%@' AND ContactNo = '%@'  AND CreateTime = '%@' AND LaborTypeId = %d ",dateStr,[NSDate currentTime],item.Hour1Str,item.Hour15Str,item.Hour2Str,item.Hour3Str,item.PUINo,strEmployeeID,model.contactNo,item.CreateTime,item.LaborTypeId];
                    }else{
                        sql = [NSString stringWithFormat:@"UPDATE  t_LaborHours SET GenerateDate = '%@' , UpdateTime = '%@',Hour1Rate = '%@',Hour15Rate= '%@',Hour2Rate= '%@',Hour3Rate= '%@'  WHERE EmployeeId = '%@' AND ContactNo = '%@'  AND CreateTime = '%@' AND LaborTypeId = %d ",dateStr,[NSDate currentTime],item.Hour1Str,item.Hour15Str,item.Hour2Str,item.Hour3Str,strEmployeeID,model.contactNo,item.CreateTime,item.LaborTypeId];
                        
                    }
                    
                    
                    BOOL ret = [db executeUpdate:sql];
                    if (ret) {
                        SZLog(@"t_LaborHours更新成功！！！");
                    }else{
                        SZLog(@"t_LaborHours更新失败！！！");
                    }
                    
                    
                }
                
                
                
            }

        }
        
        if (deleteArray&&deleteArray.count) {
            for (SZLaborHoursItem *item  in deleteArray) {
                item.UnitNo = model.unitNo;
                
                
                
                if (item.ContactNo && item.ContactNo.length) {
                    NSString *sql = [NSString stringWithFormat:@"DELETE FROM t_LaborHours  \
                                     WHERE EmployeeId = '%@' AND CreateTime = '%@' AND ( LaborTypeId = %d OR LaborTypeId = %d ) AND ContactNo = '%@'",
                                     strEmployeeID,item.CreateTime,item.LaborTypeId,[SZTable_LaborType quaryOtherLaborTypeIDWithLaborTypeID:item.LaborTypeId],item.ContactNo];
                    BOOL ret = [db executeUpdate:sql];
                    if (ret) {
                    }else{
                        SZLog(@"t_LaborHours删除失败！！！");
                    }
                }else{
                    NSString *sql;
                    if(model.ScheduleID == 0){
                        sql = [NSString stringWithFormat:@"DELETE FROM t_LaborHours  \
                               WHERE EmployeeId = '%@' AND CreateTime = '%@' AND ( LaborTypeId = %d OR LaborTypeId = %d ) AND UnitNo = '%@' AND ScheduleId=0 ;",
                               strEmployeeID,item.CreateTime,item.LaborTypeId,[SZTable_LaborType quaryOtherLaborTypeIDWithLaborTypeID:item.LaborTypeId],item.UnitNo];
                    }else{
                        sql = [NSString stringWithFormat:@"DELETE FROM t_LaborHours  \
                               WHERE EmployeeId = '%@' AND CreateTime = '%@' AND ( LaborTypeId = %d OR LaborTypeId = %d ) AND ScheduleId = %d;",
                               strEmployeeID,item.CreateTime,item.LaborTypeId,[SZTable_LaborType quaryOtherLaborTypeIDWithLaborTypeID:item.LaborTypeId],model.ScheduleID];
                    }
                    SZLog(@"SQL删除工时:%@",sql);
                    BOOL ret = [db executeUpdate:sql];
                    if (ret) {
                    }else{
                        SZLog(@"t_LaborHours删除失败！！！");
                    }
                }
                
            }

        }
        
        
        
        
        
        
    }];


}

+(void)deleteFeiProductiveWithCreateTime:(NSString *)createTime{

    [OTISDB inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"DELETE FROM t_LaborHours  \
                         WHERE EmployeeId = '%@' AND CreateTime = '%@' ;",
                         [OTISConfig EmployeeID],createTime];
        SZLog(@"SQL删除工时:%@",sql);
        BOOL ret = [db executeUpdate:sql];
        if (ret) {
        }else{
            SZLog(@"t_LaborHours删除失败！！！");
        }
        
    }];

}

+(SZCheckLookModel *)quaryLaborHoursItemsWithCheckLookModel:(SZCheckLookModel *)model {
    
    SZCheckLookModel *item1 = [[SZCheckLookModel alloc] init];


    [OTISDB inDatabase:^(FMDatabase *db) {
        
        
        item1.laborHours = [NSMutableArray array];
        
        
        if (model.ScheduleID) {
            item1.ScheduleID = model.ScheduleID;
            item1.unitNo = [SZTable_Schedules quaryUnitNoWithScheduleID:model.ScheduleID];
            NSString *sql = [NSString stringWithFormat:@"SELECT UnitNo \
                             ,GenerateDate \
                             ,CreateTime \
                             ,UpdateTime \
                             ,Hour1Rate \
                             ,Hour15Rate \
                             ,Hour2Rate  \
                             ,Hour3Rate \
                             ,Property \
                             ,LaborTypeId \
                             ,CustomerName \
                             ,ContactNo \
                             ,Remark \
                             ,PUINo \
                             ,GroupID\
                             FROM t_LaborHours,t_Schedules \
                             WHERE EmployeeID=%@  \
                             AND t_LaborHours.ScheduleID= %d \
                             AND t_LaborHours.ScheduleID=t_Schedules.ScheduleID \
                             AND CreateDate = '%@' \
                             ORDER BY  CreateTime;",[OTISConfig EmployeeID],model.ScheduleID,model.createDate];
            FMResultSet *set2 = [db executeQuery:sql];
            //        SZLog(@"%@",sql);
            while ([set2 next]) {
                item1.contactNo = model.contactNo;

                SZLaborHoursItem *item = [[SZLaborHoursItem alloc] init];
                item.UnitNo = [set2 stringForColumn:@"UnitNo"];
                item.CreateTime = [set2 stringForColumn:@"CreateTime"];
                item.UpdateTime = [set2 stringForColumn:@"UpdateTime"];
                item.Hour1Str = [set2 stringForColumn:@"Hour1Rate"];
                item.Hour15Str = [set2 stringForColumn:@"Hour15Rate"];
                item.Hour2Str = [set2 stringForColumn:@"Hour2Rate"];
                item.Hour3Str = [set2 stringForColumn:@"Hour3Rate"];
                item.GenerateDate = [set2 stringForColumn:@"GenerateDate"];
                item.LaborTypeId = [set2 intForColumn:@"LaborTypeId"];
                item.Property = [set2 intForColumn:@"Property"];
                item.CustomerName = [set2 stringForColumn:@"CustomerName"];
                item.ContactNo = [set2 stringForColumn:@"ContactNo"];
                item.Remark = [set2 stringForColumn:@"Remark"];
                item.PUINo = [set2 stringForColumn:@"PUINo"];
                item.GroupID = [set2 intForColumn:@"GroupID"];
                [item1.laborHours addObject:item];
                
            }
          
        }else{

            if (model.feishengchanxing) {
                item1.feishengchanxing = model.feishengchanxing;
                NSString *sql = [NSString stringWithFormat:@"SELECT \
                                 GenerateDate,\
                                 CreateTime, \
                                 UpdateTime, \
                                 Property, \
                                 LaborTypeId, \
                                 Hour1Rate, \
                                 Hour15Rate, \
                                 Hour2Rate, \
                                 Hour3Rate, \
                                 CustomerName, \
                                 ContactNo, \
                                 Remark, \
                                 PUINo ,\
                                 GroupID\
                                 FROM t_LaborHours \
                                 WHERE EmployeeID='%@'  AND \
                                 Property= 2 AND \
                                 CreateDate='%@' \
                                 ORDER BY  CreateTime;",[OTISConfig EmployeeID],model.createDate];
                SZLog(@"%@",sql);
                FMResultSet *set2 = [db executeQuery:sql];
                //        SZLog(@"%@",sql);
                while ([set2 next]) {
                    SZLaborHoursItem *item = [[SZLaborHoursItem alloc] init];
                    item.CreateTime = [set2 stringForColumn:@"CreateTime"];
                    item.UpdateTime = [set2 stringForColumn:@"UpdateTime"];
                    item.Hour1Str = [set2 stringForColumn:@"Hour1Rate"];
                    item.Hour15Str = [set2 stringForColumn:@"Hour15Rate"];
                    item.Hour2Str = [set2 stringForColumn:@"Hour2Rate"];
                    item.Hour3Str = [set2 stringForColumn:@"Hour3Rate"];
                    item.GenerateDate = [set2 stringForColumn:@"GenerateDate"];
                    item.LaborTypeId = [set2 intForColumn:@"LaborTypeId"];
                    item.Property = [set2 intForColumn:@"Property"];
                    item.CustomerName = [set2 stringForColumn:@"CustomerName"];
                    item.ContactNo = [set2 stringForColumn:@"ContactNo"];
                    item.Remark = [set2 stringForColumn:@"Remark"];
                    item.PUINo = [set2 stringForColumn:@"PUINo"];
                    item.GroupID = [set2 intForColumn:@"GroupID"];
//                    model.feishengchanxing = item.LaborName;
                    
                    [item1.laborHours addObject:item];

                }
                
            }else{
                item1.contactNo = model.contactNo;
                NSString *sql = [NSString stringWithFormat:@"SELECT \
                                 GenerateDate,\
                                 CreateTime, \
                                 UpdateTime, \
                                 Property, \
                                 LaborTypeId, \
                                 Hour1Rate, \
                                 Hour15Rate, \
                                 Hour2Rate, \
                                 Hour3Rate, \
                                 CustomerName, \
                                 ContactNo, \
                                 Remark, \
                                 PUINo ,\
                                 GroupID\
                                 FROM t_LaborHours \
                                 WHERE EmployeeID='%@'  AND \
                                 ContactNo='%@' AND \
                                 CreateDate='%@' \
                                 ORDER BY  CreateTime;",[OTISConfig EmployeeID],model.contactNo,model.createDate];
                FMResultSet *set2 = [db executeQuery:sql];
                //        SZLog(@"%@",sql);
                while ([set2 next]) {
                    
                    SZLaborHoursItem *item = [[SZLaborHoursItem alloc] init];
                    item.CreateTime = [set2 stringForColumn:@"CreateTime"];
                    item.UpdateTime = [set2 stringForColumn:@"UpdateTime"];
                    item.Hour1Str = [set2 stringForColumn:@"Hour1Rate"];
                    item.Hour15Str = [set2 stringForColumn:@"Hour15Rate"];
                    item.Hour2Str = [set2 stringForColumn:@"Hour2Rate"];
                    item.Hour3Str = [set2 stringForColumn:@"Hour3Rate"];
                    item.GenerateDate = [set2 stringForColumn:@"GenerateDate"];
                    item.LaborTypeId = [set2 intForColumn:@"LaborTypeId"];
                    item.Property = [set2 intForColumn:@"Property"];
                    item.CustomerName = [set2 stringForColumn:@"CustomerName"];
                    item.ContactNo = [set2 stringForColumn:@"ContactNo"];
                    item.Remark = [set2 stringForColumn:@"Remark"];
                    item.PUINo = [set2 stringForColumn:@"PUINo"];
                    item.GroupID = [set2 intForColumn:@"GroupID"];
                    [item1.laborHours addObject:item];
                    
                    
                }
            
            
            }
        
            
            
        }
        
        
    }];
    
    return item1;
}

/**
 *  查找所有时间的工时
 */
+(NSArray *)quaryAllDateLaborHours{
    NSMutableArray *dates = [NSMutableArray array];
    [OTISDB inDatabase:^(FMDatabase *db) {
        FMResultSet *set = [db executeQueryWithFormat:@"SELECT CreateDate \
                            FROM   t_LaborHours \
                            WHERE  EmployeeID=%@ \
                            GROUP BY  CreateDate  \
                            ORDER BY CreateDate DESC;",[OTISConfig EmployeeID]];
        while ([set next]) {
            if ([set stringForColumn:@"CreateDate"]) {
                [dates addObject:[set stringForColumn:@"CreateDate"]];

            }
        }
        
    }];
    
    return [NSArray arrayWithArray:dates];
}

+(BOOL)isLaborHoursed{
    
   __block BOOL ret = NO;
    [OTISDB inDatabase:^(FMDatabase *db) {
        FMResultSet *set = [db executeQueryWithFormat:@"SELECT CreateDate \
                            FROM   t_LaborHours \
                            WHERE  EmployeeID=%@ \
                            GROUP BY  CreateDate  \
                            ORDER BY CreateDate DESC;",[OTISConfig EmployeeID]];
        while ([set next]) {
            NSString *date = [set stringForColumn:@"CreateDate"];
            
            NSString *strDay = [USER_DEFAULT objectForKey:SZLaborHoursDay];
            
            //上次保存的日期和今天的日期不相同（今天没有做过工时录入）
            if (![strDay isEqualToString:[NSString stringWithFormat:@"%ld%ld%ld",[NSDate date].year,[NSDate date].month,[NSDate date].day]]) {
                [USER_DEFAULT setObject:@0 forKey:SZIsLaborHoursed];
            }
            if ([date isEqualToString:[NSDate currentDate]]) {
                ret = YES;
                [USER_DEFAULT setObject:@1 forKey:SZIsLaborHoursed];
                [USER_DEFAULT setObject:[NSString stringWithFormat:@"%ld%ld%ld",[NSDate date].year,[NSDate date].month,[NSDate date].day] forKey:SZLaborHoursDay];

            }
        }
        
    }];

    return ret;
}


/**
 *  查找当前时间下所有电梯
 */
+(NSArray *)quaryAllUnitsWithDate:(NSString *)date{
    
    NSMutableArray *dates = [NSMutableArray array];
    
    [OTISDB inDatabase:^(FMDatabase *db) {
 
        FMResultSet *set = [db executeQueryWithFormat:@"SELECT  t_LaborHours.ScheduleID,ContactNo \
                             FROM t_LaborHours,t_Schedules \
                             WHERE EmployeeID=%@ AND \
                             CreateDate=%@ \
                             GROUP BY t_LaborHours.ScheduleID,ContactNo \
                             ORDER BY CreateTime ;",[OTISConfig EmployeeID],date];
        while ([set next]) {
            
            [dates addObject:@([set intForColumn:@"ScheduleID"])];
        }
        
    }];
    
    return [NSArray arrayWithArray:dates];
}


/**
 *  查找指定电梯的所有工时
 */
+(NSArray *)quaryWithScheduleID:(int )scheduleID andCreateDate:(NSString *)createDate{
    
    NSMutableArray *dates = [NSMutableArray array];
    
    [OTISDB inDatabase:^(FMDatabase *db) {

        NSString *sql = [NSString stringWithFormat:@"SELECT UnitNo \
                         ,GenerateDate \
                         ,CreateTime \
                         ,UpdateTime \
                         ,Hour1Rate \
                         ,Hour15Rate \
                         ,Hour2Rate  \
                         ,Hour3Rate \
                         ,Property \
                         ,LaborTypeId \
                         ,CustomerName \
                         ,ContactNo \
                         ,Remark \
                         ,PUINo \
                         FROM t_LaborHours,t_Schedules \
                         WHERE EmployeeID=%@  \
                         AND t_LaborHours.ScheduleID= %d \
                         AND t_LaborHours.ScheduleID=t_Schedules.ScheduleID \
                         AND CreateDate= '%@'  \
                         ORDER BY  CreateTime;",[OTISConfig EmployeeID],scheduleID,createDate];
        FMResultSet *set = [db executeQuery:sql];
//        SZLog(@"%@",sql);
        while ([set next]) {
            
            SZLaborHoursItem *item = [[SZLaborHoursItem alloc] init];
            item.UnitNo = [set stringForColumn:@"UnitNo"];
            item.CreateTime = [set stringForColumn:@"CreateTime"];
            item.UpdateTime = [set stringForColumn:@"UpdateTime"];
            item.Hour1Str = [set stringForColumn:@"Hour1Rate"];
            item.Hour15Str = [set stringForColumn:@"Hour15Rate"];
            item.Hour2Str = [set stringForColumn:@"Hour2Rate"];
            item.Hour3Str = [set stringForColumn:@"Hour3Rate"];
            item.GenerateDate = [set stringForColumn:@"GenerateDate"];
            item.LaborTypeId = [set intForColumn:@"LaborTypeId"];
            item.Property = [set intForColumn:@"Property"];
            item.CustomerName = [set stringForColumn:@"CustomerName"];
            item.ContactNo = [set stringForColumn:@"ContactNo"];
            item.Remark = [set stringForColumn:@"Remark"];
            item.PUINo = [set stringForColumn:@"PUINo"];
            [dates addObject:item];

        }
        
    }];
    
    return [NSArray arrayWithArray:dates];
}


/**
 *  查找指定合同号的所有工时
 */
+(NSArray *)quaryWithContactNo:(NSString *)contactNo andCreateDate:(NSString *)createDate{
    NSMutableArray *dates = [NSMutableArray array];
    [OTISDB inDatabase:^(FMDatabase *db) {
        
        
        FMResultSet *set = [db executeQueryWithFormat:@"SELECT UnitNo \
                            ,GenerateDate \
                            ,CreateTime \
                            ,UpdateTime \
                            ,Hour1Rate \
                            ,Hour15Rate \
                            ,Hour2Rate  \
                            ,Hour3Rate \
                            ,Property \
                            ,LaborTypeId \
                            ,CustomerName \
                            ,ContactNo \
                            ,Remark \
                            ,PUINo \
                            FROM t_LaborHours \
                            WHERE EmployeeID=%@  AND \
                            ContactNo =%@ AND \
                            CreateDate =%@ \
                            ORDER BY  CreateTime;",[OTISConfig EmployeeID],contactNo,createDate];
        while ([set next]) {
            
            SZLaborHoursItem *item = [[SZLaborHoursItem alloc] init];
            item.UnitNo = [set stringForColumn:@"UnitNo"];
            item.CreateTime = [set stringForColumn:@"CreateTime"];
            item.UpdateTime = [set stringForColumn:@"UpdateTime"];
            item.Hour1Str = [set stringForColumn:@"Hour1Rate"];
            item.Hour15Str = [set stringForColumn:@"Hour15Rate"];
            item.Hour2Str = [set stringForColumn:@"Hour2Rate"];
            item.Hour3Str = [set stringForColumn:@"Hour3Rate"];
            item.GenerateDate = [set stringForColumn:@"GenerateDate"];
            item.LaborTypeId = [set intForColumn:@"LaborTypeId"];
            item.Property = [set intForColumn:@"Property"];
            item.CustomerName = [set stringForColumn:@"CustomerName"];
            item.ContactNo = [set stringForColumn:@"ContactNo"];
            item.Remark = [set stringForColumn:@"Remark"];
            item.PUINo = [set stringForColumn:@"PUINo"];
            [dates addObject:item];
            
        }
        
    }];
    
    return [NSArray arrayWithArray:dates];
}


/**
 *  计算生产性工时和非生产性工时总时间
 */

+(float)quaryTotlaTimesWithDate:(NSString *)date{
    
    __block float ti = 0 ;
    
    [OTISDB inDatabase:^(FMDatabase *db) {
        
        NSString *sql = [NSString stringWithFormat:@"SELECT Hour1Rate,Hour15Rate,Hour2Rate,Hour3Rate  \
                         FROM t_LaborHours \
                         WHERE EmployeeID= '%@' AND CreateDate= '%@' ;",[OTISConfig EmployeeID],date];
        FMResultSet *set2 = [db executeQuery:sql];
        while ([set2 next]) {
            
            ti += [set2 floatForColumn:@"Hour1Rate"];
            ti += [set2 floatForColumn:@"Hour15Rate"];
            ti += [set2 floatForColumn:@"Hour2Rate"];
            ti += [set2 floatForColumn:@"Hour3Rate"];
            
        }
        
    }];
    
    return ti;
}


+(float)quaryTimesWithDate:(NSString *)date{
    
//    __block int time = 0;
    __block float ti = 0 ;

    [OTISDB inDatabase:^(FMDatabase *db) {
        
//        FMResultSet *set = [db executeQueryWithFormat:@"SELECT (sum(Hour1Rate)+sum(Hour15Rate)+sum(Hour2Rate)+sum(Hour3Rate)) AS PRODUCTION_HOUR \
//                            FROM t_LaborHours \
//                            WHERE EmployeeID= %@ AND CreateDate= %@ \
//                            AND Property IN (0,1,4);",[OTISConfig EmployeeID],date];
//        while ([set next]) {
//            
//            time = [set intForColumn:@"PRODUCTION_HOUR"];
//        }
        
        FMResultSet *set2 = [db executeQueryWithFormat:@"SELECT Hour1Rate,Hour15Rate,Hour2Rate,Hour3Rate  \
                            FROM t_LaborHours \
                            WHERE EmployeeID= %@ AND CreateDate= %@ \
                            AND Property IN (0,1,4);",[OTISConfig EmployeeID],date];
        while ([set2 next]) {
            
            ti += [set2 floatForColumn:@"Hour1Rate"];
            ti += [set2 floatForColumn:@"Hour15Rate"];
            ti += [set2 floatForColumn:@"Hour2Rate"];
            ti += [set2 floatForColumn:@"Hour3Rate"];

        }
       
    }];
    
    return ti;
}

/**
 *  计算非生产性工时总时间
 */
+(float)quaryNonProductiveTimesWithDate:(NSString *)date{
    
    __block float ti = 0;
    
    [OTISDB inDatabase:^(FMDatabase *db) {
        
        FMResultSet *set2 = [db executeQueryWithFormat:@"SELECT Hour1Rate,Hour15Rate,Hour2Rate,Hour3Rate  \
                            FROM t_LaborHours \
                            WHERE EmployeeID= %@ AND CreateDate= %@ \
                            AND Property = 2;",[OTISConfig EmployeeID],date];
        while ([set2 next]) {
            
            ti += [set2 floatForColumn:@"Hour1Rate"];
            ti += [set2 floatForColumn:@"Hour15Rate"];
            ti += [set2 floatForColumn:@"Hour2Rate"];
            ti += [set2 floatForColumn:@"Hour3Rate"];

        }
        
    }];
    
    return ti;
}





/**
 *  查找指定电梯的维保工时
 */
+(NSArray *)quaryMaintenanceWithScheduleID:(int )scheduleID {
    
    NSMutableArray *laborTypeIDs = [NSMutableArray array];
    
    [OTISDB inDatabase:^(FMDatabase *db) {
        
        NSString *sql = [NSString stringWithFormat:@"SELECT  * \
                         FROM t_LaborHours ,t_LaborType \
                         WHERE ScheduleId= %d AND t_LaborHours.EmployeeID=%@ \
                         AND t_LaborType.LaborTypeID = t_LaborHours.LaborTypeId AND t_LaborType.RelationID = t_LaborType.LaborTypeID \
                         ORDER BY CreateDate;",scheduleID,[OTISConfig EmployeeID]];
        FMResultSet *set = [db executeQuery:sql];
        //        SZLog(@"%@",sql);
        while ([set next]) {
            SZLabor *labor = [[SZLabor alloc] init];
            labor.LaborTypeID = [set intForColumn:@"LaborTypeID"];
            labor.LaborType = [set stringForColumn:@"LaborType"];
            labor.LaborName = [set stringForColumn:@"LaborName"];
            labor.RelationID = [set intForColumn:@"RelationID"];
            
            NSString *sql1 = [NSString stringWithFormat:@"SELECT t_Schedules.UnitNo \
                             ,GenerateDate \
                             ,CreateTime \
                             ,UpdateTime \
                             ,Hour1Rate \
                             ,Hour15Rate \
                             ,Hour2Rate  \
                             ,Hour3Rate \
                             ,Property \
                             ,LaborTypeId \
                             ,CustomerName \
                             ,ContactNo \
                             ,Remark \
                             ,PUINo \
                             FROM t_LaborHours,t_Schedules \
                             WHERE t_LaborHours.EmployeeID=%@  \
                             AND t_LaborHours.ScheduleID= %d \
                             AND t_LaborHours.ScheduleID=t_Schedules.ScheduleID \
                             AND LaborTypeId= %d  \
                             ORDER BY  CreateTime;",[OTISConfig EmployeeID],scheduleID,labor.LaborTypeID];
            FMResultSet *set1 = [db executeQuery:sql1];
            while ([set1 next]) {
                SZLaborHoursItem *item = [[SZLaborHoursItem alloc] init];
                item.UnitNo = [set1 stringForColumn:@"UnitNo"];
                item.CreateTime = [set1 stringForColumn:@"CreateTime"];
                item.UpdateTime = [set1 stringForColumn:@"UpdateTime"];
                item.Hour1Str = [set stringForColumn:@"Hour1Rate"];
                item.Hour15Str = [set stringForColumn:@"Hour15Rate"];
                item.Hour2Str = [set stringForColumn:@"Hour2Rate"];
                item.Hour3Str = [set stringForColumn:@"Hour3Rate"];
                item.GenerateDate = [set1 stringForColumn:@"GenerateDate"];
                item.LaborTypeId = [set1 intForColumn:@"LaborTypeId"];
                item.Property = [set1 intForColumn:@"Property"];
                item.CustomerName = [set1 stringForColumn:@"CustomerName"];
                item.ContactNo = [set1 stringForColumn:@"ContactNo"];
                item.Remark = [set1 stringForColumn:@"Remark"];
                item.PUINo = [set1 stringForColumn:@"PUINo"];
                labor.item1 = item;
            }
            NSString *sql2 = [NSString stringWithFormat:@"SELECT t_Schedules.UnitNo \
                              ,GenerateDate \
                              ,CreateTime \
                              ,UpdateTime \
                              ,Hour1Rate \
                              ,Hour15Rate \
                              ,Hour2Rate  \
                              ,Hour3Rate \
                              ,Property \
                              ,LaborTypeId \
                              ,CustomerName \
                              ,ContactNo \
                              ,Remark \
                              ,PUINo \
                              FROM t_LaborHours,t_Schedules \
                              WHERE t_LaborHours.EmployeeID=%@  \
                              AND t_LaborHours.ScheduleID= %d \
                              AND t_LaborHours.ScheduleID=t_Schedules.ScheduleID \
                              AND LaborTypeId= %d  \
                              ORDER BY  CreateTime;",[OTISConfig EmployeeID],scheduleID,[SZTable_LaborType quaryLuTuLaborTypeIDWithLaborTypeID:labor.LaborTypeID]];
            FMResultSet *set2 = [db executeQuery:sql2];
            while ([set2 next]) {
                SZLaborHoursItem *item = [[SZLaborHoursItem alloc] init];
                item.UnitNo = [set2 stringForColumn:@"UnitNo"];
                item.CreateTime = [set2 stringForColumn:@"CreateTime"];
                item.UpdateTime = [set2 stringForColumn:@"UpdateTime"];
                item.Hour1Str = [set2 stringForColumn:@"Hour1Rate"];
                item.Hour15Str = [set2 stringForColumn:@"Hour15Rate"];
                item.Hour2Str = [set2 stringForColumn:@"Hour2Rate"];
                item.Hour3Str = [set2 stringForColumn:@"Hour3Rate"];
                item.GenerateDate = [set2 stringForColumn:@"GenerateDate"];
                item.LaborTypeId = [set2 intForColumn:@"LaborTypeId"];
                item.Property = [set2 intForColumn:@"Property"];
                item.CustomerName = [set2 stringForColumn:@"CustomerName"];
                item.ContactNo = [set2 stringForColumn:@"ContactNo"];
                item.Remark = [set2 stringForColumn:@"Remark"];
                item.PUINo = [set2 stringForColumn:@"PUINo"];
                labor.item2 = item;
            }

            
            [laborTypeIDs addObject:labor];
            
        }
        
        //1.查找所有主工时Id
        //2.查找对应主工时下的子项
        
    }];
    
    return [NSArray arrayWithArray:laborTypeIDs];
}


/**
 *  查找所有时间的工时
 */
+(NSArray *)quaryAllDateLaborHours111{
    NSMutableArray *dates = [NSMutableArray array];
    [OTISDB inDatabase:^(FMDatabase *db) {
        FMResultSet *set = [db executeQueryWithFormat:@"SELECT CreateDate \
                            FROM   t_LaborHours \
                            WHERE  EmployeeID=%@ \
                            GROUP BY  CreateDate  \
                            ORDER BY CreateDate DESC;",[OTISConfig EmployeeID]];
        while ([set next]) {
            NSMutableArray *units = [NSMutableArray array];
            FMResultSet *set1 = [db executeQueryWithFormat:@"SELECT  t_LaborHours.ScheduleID,ContactNo \
                                FROM t_LaborHours,t_Schedules \
                                WHERE EmployeeID=%@ AND \
                                CreateDate=%@ \
                                GROUP BY t_LaborHours.ScheduleID,ContactNo \
                                ORDER BY CreateTime ;",[OTISConfig EmployeeID],[set stringForColumn:@"CreateDate"]];
            while ([set1 next]) {
                
                [units addObject:@([set1 intForColumn:@"ScheduleID"])];
            }

            
            [dates addObject:units];
        }
        
    }];
    
    return [NSArray arrayWithArray:dates];
}


/**
 *  查找所有时间的工时
 */
+(NSArray *)quaryAllDateLaborHours222{
    NSMutableArray *dates = [NSMutableArray array];
    [OTISDB inDatabase:^(FMDatabase *db) {
        FMResultSet *set = [db executeQueryWithFormat:@"SELECT CreateDate \
                            FROM   t_LaborHours \
                            WHERE  EmployeeID=%@ \
                            GROUP BY  CreateDate \
                            ORDER BY CreateDate DESC;",[OTISConfig EmployeeID]];
        while ([set next]) {
            NSString *createDate = [set stringForColumn:@"CreateDate"];
            NSMutableArray *day = [NSMutableArray array];
            FMResultSet *set1 = [db executeQueryWithFormat:@"SELECT  t_LaborHours.GenerateDate,t_LaborHours.ScheduleID,ContactNo,Property,LaborTypeId,t_LaborHours.UnitNo \
                                 FROM t_LaborHours,t_Schedules \
                                 WHERE t_LaborHours.EmployeeID=%@ \
                                 AND CreateDate = %@ \
                                 GROUP BY t_LaborHours.ScheduleID,t_LaborHours.ContactNo , t_LaborHours.UnitNo\
                                 ORDER BY CreateTime ;",[OTISConfig EmployeeID],createDate];
            while ([set1 next]) {
                SZCheckLookModel *model = [[SZCheckLookModel alloc] init];
                model.createDate = createDate;
                NSString *GenerateDate = [[set1 stringForColumn:@"GenerateDate"] stringByReplacingOccurrencesOfString:@"/" withString:@"-"];
                model.GenerateDate = GenerateDate;
                model.laborHours = [NSMutableArray array];
                int schid = [set1 intForColumn:@"ScheduleID"];
                NSString *unitNo = [set1 stringForColumn:@"UnitNo"];

                model.ScheduleID = schid;
                if (schid>0||unitNo.length>2) {
                    if (schid >0) {
                        model.unitNo = [SZTable_Schedules quaryUnitNoWithScheduleID:schid];
                        NSString *sql = [NSString stringWithFormat:@"SELECT t_Schedules.UnitNo \
                                         ,GenerateDate \
                                         ,CreateTime \
                                         ,UpdateTime \
                                         ,Hour1Rate \
                                         ,Hour15Rate \
                                         ,Hour2Rate  \
                                         ,Hour3Rate \
                                         ,Property \
                                         ,LaborTypeId \
                                         ,CustomerName \
                                         ,ContactNo \
                                         ,Remark \
                                         ,PUINo \
                                         ,GroupID\
                                         FROM t_LaborHours,t_Schedules \
                                         WHERE t_LaborHours.EmployeeID=%@  \
                                         AND t_LaborHours.ScheduleID= %d \
                                         AND t_LaborHours.ScheduleID=t_Schedules.ScheduleID \
                                         AND CreateDate = '%@' \
                                         ORDER BY  CreateTime;",[OTISConfig EmployeeID],schid,createDate];
                        FMResultSet *set2 = [db executeQuery:sql];
                        //        SZLog(@"%@",sql);
                        while ([set2 next]) {
                            
                            SZLaborHoursItem *item = [[SZLaborHoursItem alloc] init];
                            item.UnitNo = [set2 stringForColumn:@"UnitNo"];
                            item.CreateTime = [set2 stringForColumn:@"CreateTime"];
                            item.UpdateTime = [set2 stringForColumn:@"UpdateTime"];
                            item.Hour1Str = [set2 stringForColumn:@"Hour1Rate"];
                            item.Hour15Str = [set2 stringForColumn:@"Hour15Rate"];
                            item.Hour2Str = [set2 stringForColumn:@"Hour2Rate"];
                            item.Hour3Str = [set2 stringForColumn:@"Hour3Rate"];
                            
                            item.GenerateDate = [set2 stringForColumn:@"GenerateDate"];
                            item.LaborTypeId = [set2 intForColumn:@"LaborTypeId"];
                            item.Property = [set2 intForColumn:@"Property"];
                            item.CustomerName = [set2 stringForColumn:@"CustomerName"];
                            item.ContactNo = [set2 stringForColumn:@"ContactNo"];
                            item.Remark = [set2 stringForColumn:@"Remark"];
                            item.PUINo = [set2 stringForColumn:@"PUINo"];
                            item.GroupID = [set2 intForColumn:@"GroupID"];
                            [model.laborHours addObject:item];
                            
                        }
                        if (model.unitNo.length>2) {
                            [day addObject:model];
                        }

                    }else{
                    
                        model.unitNo = unitNo;

                        NSString *sql2 = [NSString stringWithFormat:@"SELECT \
                                          GenerateDate \
                                          ,CreateTime \
                                          ,UpdateTime \
                                          ,Hour1Rate \
                                          ,Hour15Rate \
                                          ,Hour2Rate  \
                                          ,Hour3Rate \
                                          ,Property \
                                          ,LaborTypeId \
                                          ,CustomerName \
                                          ,ContactNo \
                                          ,Remark \
                                          ,PUINo \
                                          ,GroupID\
                                          FROM t_LaborHours \
                                          WHERE EmployeeID='%@'  \
                                          AND UnitNo= '%@' \
                                          AND CreateDate = '%@' \
                                          ORDER BY  CreateTime;",[OTISConfig EmployeeID],unitNo,createDate];
                        FMResultSet *set23 = [db executeQuery:sql2];
                        while ([set23 next]) {
                            
                            SZLaborHoursItem *item = [[SZLaborHoursItem alloc] init];
                            item.UnitNo = unitNo;
                            item.CreateTime = [set23 stringForColumn:@"CreateTime"];
                            item.UpdateTime = [set23 stringForColumn:@"UpdateTime"];
                            item.Hour1Str = [set23 stringForColumn:@"Hour1Rate"];
                            item.Hour15Str = [set23 stringForColumn:@"Hour15Rate"];
                            item.Hour2Str = [set23 stringForColumn:@"Hour2Rate"];
                            item.Hour3Str = [set23 stringForColumn:@"Hour3Rate"];
                            
                            item.GenerateDate = [set23 stringForColumn:@"GenerateDate"];
                            item.LaborTypeId = [set23 intForColumn:@"LaborTypeId"];
                            item.Property = [set23 intForColumn:@"Property"];
                            item.CustomerName = [set23 stringForColumn:@"CustomerName"];
                            item.ContactNo = [set23 stringForColumn:@"ContactNo"];
                            item.Remark = [set23 stringForColumn:@"Remark"];
                            item.PUINo = [set23 stringForColumn:@"PUINo"];
                            item.GroupID = [set23 intForColumn:@"GroupID"];
                            [model.laborHours addObject:item];
                        }

                        [day addObject:model];

                    }
                    
                    
                    
                }else{
                    
                    if ([set1 intForColumn:@"Property"] == 2) {
                        NSString *sql = [NSString stringWithFormat:@"SELECT \
                                         GenerateDate,\
                                         CreateTime, \
                                         UpdateTime, \
                                         Property, \
                                         LaborTypeId, \
                                         Hour1Rate, \
                                         Hour15Rate, \
                                         Hour2Rate, \
                                         Hour3Rate, \
                                         CustomerName, \
                                         ContactNo, \
                                         Remark, \
                                         PUINo ,\
                                         GroupID\
                                         FROM t_LaborHours \
                                         WHERE EmployeeID='%@'  AND \
                                         Property= %d AND \
                                         CreateDate='%@' \
                                         ORDER BY  CreateTime;",[OTISConfig EmployeeID],2,createDate];
                        SZLog(@"%@",sql);
                        FMResultSet *set2 = [db executeQuery:sql];
                        //        SZLog(@"%@",sql);
                        while ([set2 next]) {
                            SZCheckLookModel *modelSub = [[SZCheckLookModel alloc] init];
                            modelSub.createDate = createDate;
                            modelSub.laborHours = [NSMutableArray array];
                            modelSub.ScheduleID = 0;
                            
                            SZLaborHoursItem *item = [[SZLaborHoursItem alloc] init];
                            item.CreateTime = [set2 stringForColumn:@"CreateTime"];
                            item.UpdateTime = [set2 stringForColumn:@"UpdateTime"];
                            item.Hour1Str = [set2 stringForColumn:@"Hour1Rate"];
                            item.Hour15Str = [set2 stringForColumn:@"Hour15Rate"];
                            item.Hour2Str = [set2 stringForColumn:@"Hour2Rate"];
                            item.Hour3Str = [set2 stringForColumn:@"Hour3Rate"];
                            item.GenerateDate = [set2 stringForColumn:@"GenerateDate"];
                            item.LaborTypeId = [set2 intForColumn:@"LaborTypeId"];
                            item.Property = [set2 intForColumn:@"Property"];
                            item.CustomerName = [set2 stringForColumn:@"CustomerName"];
                            item.ContactNo = [set2 stringForColumn:@"ContactNo"];
                            item.Remark = [set2 stringForColumn:@"Remark"];
                            item.PUINo = [set2 stringForColumn:@"PUINo"];
                            item.GroupID = [set2 intForColumn:@"GroupID"];
                            
                            modelSub.feishengchanxing = item.LaborName;
                            
                            modelSub.LaborTypeID = [set2 intForColumn:@"LaborTypeId"];

                            [modelSub.laborHours addObject:item];

//                            int ok = YES;
//                            for (SZCheckLookModel *modelItem in day) {
//                                if ([modelItem.feishengchanxing isEqualToString:model.feishengchanxing]) {
//                                    ok = NO;
//                                    continue;
//                                }
//                            }
//                            if (ok) {
                                [day addObject:modelSub];
//                            }
                        
                        }
                    }else{
                    
                        model.contactNo = [set1 stringForColumn:@"ContactNo"];
                        NSString *sql = [NSString stringWithFormat:@"SELECT \
                                         GenerateDate,\
                                         CreateTime, \
                                         UpdateTime, \
                                         Property, \
                                         LaborTypeId, \
                                         Hour1Rate, \
                                         Hour15Rate, \
                                         Hour2Rate, \
                                         Hour3Rate, \
                                         CustomerName, \
                                         ContactNo, \
                                         Remark, \
                                         PUINo ,\
                                         GroupID\
                                         FROM t_LaborHours \
                                         WHERE EmployeeID='%@'  AND \
                                         ContactNo='%@' AND \
                                         CreateDate='%@' \
                                         ORDER BY  CreateTime;",[OTISConfig EmployeeID],[set1 stringForColumn:@"ContactNo"],createDate];
                        FMResultSet *set2 = [db executeQuery:sql];
                        //        SZLog(@"%@",sql);
                        while ([set2 next]) {
                            
                            SZLaborHoursItem *item = [[SZLaborHoursItem alloc] init];
                            item.CreateTime = [set2 stringForColumn:@"CreateTime"];
                            item.UpdateTime = [set2 stringForColumn:@"UpdateTime"];
                            item.Hour1Str = [set2 stringForColumn:@"Hour1Rate"];
                            item.Hour15Str = [set2 stringForColumn:@"Hour15Rate"];
                            item.Hour2Str = [set2 stringForColumn:@"Hour2Rate"];
                            item.Hour3Str = [set2 stringForColumn:@"Hour3Rate"];
                            item.GenerateDate = [set2 stringForColumn:@"GenerateDate"];
                            item.LaborTypeId = [set2 intForColumn:@"LaborTypeId"];
                            item.Property = [set2 intForColumn:@"Property"];
                            item.CustomerName = [set2 stringForColumn:@"CustomerName"];
                            item.ContactNo = [set2 stringForColumn:@"ContactNo"];
                            item.Remark = [set2 stringForColumn:@"Remark"];
                            item.PUINo = [set2 stringForColumn:@"PUINo"];
                            item.GroupID = [set2 intForColumn:@"GroupID"];
                            [model.laborHours addObject:item];
                            int ok = YES;
                            for (SZCheckLookModel *modelItem in day) {
                                if ([modelItem.contactNo isEqualToString:model.contactNo]) {
                                    ok = NO;
                                    continue;
                                }
                            }
                            if (ok) {
                                [day addObject:model];
                            }
                            
                        }
                    
                    }
               
                
                
                }
                

            }
            
            [dates addObject:day];

        }
        
    }];
    
    
    return [NSArray arrayWithArray:dates];
}


+(NSString *)queryDatetime{
    
    __block NSString *strDate = @"";
    
    [OTISDB inDatabase:^(FMDatabase *db) {
        FMResultSet *setAll = [db executeQueryWithFormat:@"SELECT CreateDate \
                               FROM t_LaborHours \
                               WHERE EmployeeID=%@ GROUP BY GroupID;",[OTISConfig EmployeeID]];
        while ([setAll next]) {
            strDate = [setAll stringForColumn:@"CreateDate"];
        }
    }];
    
    return strDate;
    
}

+(BOOL)clearData{
    __block BOOL ret = NO;

    [OTISDB inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"DELETE FROM t_LaborHours "];

         BOOL ret1 = [db executeUpdate:sql];
        if (ret1) {
            ret = YES;
        }else{
            ret = NO;
            SZLog(@"清除t_LaborHours数据失败!");
        }
    }];

    AppDelegate *appD = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appD.annualInspectionCount =0 ;
    [[NSNotificationCenter defaultCenter] postNotificationName:SZNotificationUpdateBadgeViewCount object:self userInfo:nil];
    return ret;
}
/**
 * 全工时数据数据上传(是否有数据)
 *
 *  @param params 请求参数
 */
+(BOOL)queryhasHoursUploadData{
    
    
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
    
    [OTISDB inDatabase:^(FMDatabase *db) {
        NSString *sqlAll = [NSString stringWithFormat:@"SELECT GroupID ,ScheduleID,CreateDate,GenerateDate,Property,Remark \
                            FROM t_LaborHours \
                            WHERE EmployeeID=%@ GROUP BY GroupID;",[OTISConfig EmployeeID]];
        SZLog(@"SQL 全工时数据数据上传:%@",sqlAll);
        FMResultSet *setAll = [db executeQuery:sqlAll];
        
        while ([setAll next]) {
            
            int property = [setAll intForColumn:@"Property"];
            
            if (property == 1) {//本公司生产性工时
                
                SZProductHours *productHours = [[SZProductHours alloc] init];
                productHours.GroupID = [NSString stringWithFormat:@"%d",[setAll intForColumn:@"GroupID"]];
                
                FMResultSet *setSc = [db executeQueryWithFormat:@"SELECT  UnitNo \
                                      FROM t_Schedules \
                                      WHERE ScheduleID=%ld ;",(long)[setAll longForColumn:@"ScheduleID"]];
                while ([setSc next]) {
                    productHours.UnitNo = [setSc stringForColumn:@"UnitNo"];
                }
                if ([setAll stringForColumn:@"CreateTime"]) {
                    productHours.SaveHourDate = [NSDate sinceDistantPastToDateTime:[NSDate dateTimeFromString:[setAll stringForColumn:@"CreateTime"]]];
                    
                }
                request.dateTime = [setAll stringForColumn:@"CreateDate"];
                
                NSString *strDate = [setAll stringForColumn:@"GenerateDate"];
                if (strDate) {
                    NSDate *date = [NSDate dateFromString:strDate];
                    productHours.GenerateDate = [NSString stringWithFormat:@"%ld",(long)[NSDate sinceDistantPastToDate:date]];
                }else{
                    productHours.GenerateDate = @"2016/3/23";
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
                
                
                /**
                 *  Oprate
                 */
                NSMutableArray *arrayOprate = [NSMutableArray array];
                FMResultSet *setOprate = [db executeQueryWithFormat:@"\
                                          SELECT StratTime,EndTime,StartLon,StartLat,EndLon,EndLat,Property,Reason \
                                          FROM t_QRCode \
                                          WHERE EmployeeID= %@ AND \
                                                GroupID = %d AND \
                                                Property = 1 AND\
                                                IsFixItem=0 ;",
                                          [OTISConfig EmployeeID],[setAll intForColumn:@"GroupID"]];
                while ([setOprate next]) {
                    productHours.QRCode = [setOprate stringForColumn:@"QRCode"];
                    
                    SZOprateItem *item = [[SZOprateItem alloc] init];
                    item.StartTime = [setOprate longForColumn:@"StratTime"];
                    item.EndTime = [setOprate longForColumn:@"EndTime"];
                    item.StartLocalX = [setOprate stringForColumn:@"StartLon"];
                    item.StartLocalY = [setOprate stringForColumn:@"StartLat"];
                    item.EndLocalX = [setOprate stringForColumn:@"EndLon"];
                    item.EndLocalY = [setOprate stringForColumn:@"EndLat"];
                    item.Type = [setOprate stringForColumn:@"Property"];
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
                if ([NSDate dateFromString:[setAll stringForColumn:@"CreateDate"]]) {
                    unproductHours.SaveHourDate = [NSDate sinceDistantPastToDate:[NSDate dateFromString:[setAll stringForColumn:@"CreateDate"]]];
                    
                }
                
                NSString *strDate = [setAll stringForColumn:@"GenerateDate"];
                if (strDate) {
                    NSDate *date = [NSDate dateFromString:strDate];
                    unproductHours.GenerateDate = [NSString stringWithFormat:@"%ld",(long)[NSDate sinceDistantPastToDate:date]];
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
                
                
            }else if (property == 4){//非本公司工时
                
                SZNotThisCompanyHours *notThisCompanyHours = [[SZNotThisCompanyHours alloc] init];
                notThisCompanyHours.GroupID = [NSString stringWithFormat:@"%d",[setAll intForColumn:@"GroupID"]];
                
                notThisCompanyHours.CustomerInfo = [setAll stringForColumn:@"Remark"];
                notThisCompanyHours.ContractNo = [setAll stringForColumn:@"Remark"];
                if ([NSDate dateFromString:[setAll stringForColumn:@"CreateDate"]]) {
                    notThisCompanyHours.SaveHourDate = [NSDate sinceDistantPastToDate:[NSDate dateFromString:[setAll stringForColumn:@"CreateDate"]]];
                    
                }
                
                NSString *strDate = [setAll stringForColumn:@"GenerateDate"];
                if (strDate) {
                    NSDate *date = [NSDate dateFromString:strDate];
                    notThisCompanyHours.GenerateDate = [NSString stringWithFormat:@"%ld",(long)[NSDate sinceDistantPastToDate:date]];
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
            }
            
        }
        
        
    }];
    
    
    request.ProductHours = arrayProductHours.mj_JSONString;
    request.UnProductHours = arrayUnProductHours.mj_JSONString;
    request.NotThisCompanyHours = arrayNotThisCompanyHours.mj_JSONString;
    
    return (arrayProductHours.count||arrayUnProductHours.count||arrayNotThisCompanyHours.count);
    
    
}


@end
