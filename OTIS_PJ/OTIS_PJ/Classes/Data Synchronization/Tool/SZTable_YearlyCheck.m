//
//  SZTable_YearlyCheck.m
//  OTIS_PJ
//
//  Created by sunze on 16/4/29.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "SZTable_YearlyCheck.h"
#import "TablesAndFields.h"
#import "NSDate+Extention.h"
#import "SZModuleQueryTool.h"

@implementation SZTable_YearlyCheck



/**
 *  根据请求参数去沙盒中加载缓存的YearlyCheck数据
 *
 *  @param params 请求参数
 */
+(NSArray *)readYearlyCheckWithParams:(NSDictionary *)params{

    return nil;
}

+(void)storageYearlyCheck:(SZYearCheckItem *)checkItem{
    
    
    [OTISDB inDatabase:^(FMDatabase *db) {
        int count = 0;
        FMResultSet *set = [db executeQueryWithFormat:@"SELECT count() AS COUNT \
                            FROM TAB_YEARLY_CHECK WHERE  EmployeeId = %@ AND UnitNo = %@ ;",[OTISConfig EmployeeID],checkItem.UnitNo];
        while ([set next]) {
            
            count = [set intForColumn:@"COUNT"];
        }
        
        if (count) {
            NSString *sql = [NSString stringWithFormat:@"UPDATE TAB_YEARLY_CHECK  \
                                SET  YCHECK_PDATE = %ld, \
                                     YCHECK_ADATE = %ld ,\
                                      SAVE_YCHECK_PDATE = %ld, \
                                     IS_UPLOADING = 0 \
                             WHERE  EmployeeId = %@ AND UnitNo = '%@'  ;",
                             (long)checkItem.PDate,(long)checkItem.ADate,checkItem.PDate_Save,[OTISConfig EmployeeID],checkItem.UnitNo];
            BOOL ret =[db executeUpdate:sql];
            if (ret) {
                
            }else{
                SZLog(@"TAB_YEARLY_CHECK表INSERT失败！！！");
            }
        }else{
            NSString *sql = [NSString stringWithFormat:@"INSERT INTO TAB_YEARLY_CHECK (YCHECK_PDATE,YCHECK_ADATE,IS_UPLOADING,UnitNo,EmployeeId,SAVE_YCHECK_PDATE) VALUES (%ld,%ld,%d,'%@','%@',%ld);",
                             (long)checkItem.PDate,(long)checkItem.ADate,0,checkItem.UnitNo,[OTISConfig EmployeeID],checkItem.PDate_Save];
            BOOL ret =[db executeUpdate:sql];
            if (ret) {
                
            }else{
                SZLog(@"TAB_YEARLY_CHECK表INSERT失败！！！");
            }
        }
        

        
    }];


}

+(void)storageYearlyChecks:(NSMutableArray *)arrayItems WithTime:(NSString *)time{

    NSInteger dateTime = [NSDate sinceDistantPastToDate:[NSDate dateFromString:time]];
    
    [OTISDB inDatabase:^(FMDatabase *db) {
        
        
        for (SZFinalMaintenanceUnitItem *checkItem in arrayItems) {
            
            if (checkItem.selected) {
                NSString *datep ;
                if (checkItem.inNextTwoMonths && checkItem.isChaoqi == NO ) {
                    
                    datep = checkItem.inNextTwoMonths;
                    
                    
                }else{
                    
                    datep = checkItem.showDateStr;
                    
                }

                

                int count = 0;
                FMResultSet *set = [db executeQueryWithFormat:@"SELECT count() AS COUNT1 \
                                    FROM TAB_YEARLY_CHECK WHERE  EmployeeId = %@ AND UnitNo = %@ ;",[OTISConfig EmployeeID],checkItem.UnitNo];
                while ([set next]) {
                    
                    count = [set intForColumn:@"COUNT1"];
                }
                
                if (count) {
                    BOOL ret =[db executeUpdateWithFormat:@"UPDATE TAB_YEARLY_CHECK  SET  YCHECK_ADATE = %ld ,IS_UPLOADING = 0, SAVE_YCHECK_PDATE = %ld WHERE  EmployeeId = %@ AND UnitNo = %@  ;",
                               (long)dateTime,[NSDate sinceDistantPastToDate:[NSDate dateFromString:datep]],checkItem.UnitNo,[OTISConfig EmployeeID]];
                    if (ret) {
                        
                    }else{
                        SZLog(@"TAB_YEARLY_CHECK表INSERT失败！！！");
                    }
                }else{
                    BOOL ret =[db executeUpdateWithFormat:@"INSERT INTO TAB_YEARLY_CHECK (YCHECK_ADATE,YCHECK_PDATE,IS_UPLOADING,UnitNo,EmployeeId,SAVE_YCHECK_PDATE) VALUES (%ld,%ld,%d,%@,%@,%ld);",
                               (long)dateTime,(long)checkItem.YCheckDate,0,checkItem.UnitNo,[OTISConfig EmployeeID],[NSDate sinceDistantPastToDate:[NSDate dateFromString:datep]]];
                    if (ret) {
                        
                    }else{
                        SZLog(@"TAB_YEARLY_CHECK表INSERT失败！！！");
                    }
                }

            }
            
        }
       
        
        
    }];

}





+(void)updateYearlyCheckDone{
    
    
    [OTISDB inDatabase:^(FMDatabase *db) {
        
        BOOL ret =[db executeUpdateWithFormat:@"UPDATE TAB_YEARLY_CHECK SET IS_UPLOADING=1 WHERE EmployeeId= %@ ;",[OTISConfig EmployeeID]];
       // BOOL ret =[db executeUpdateWithFormat:@"DELETE FROM TAB_YEARLY_CHECK WHERE EmployeeId= %@ ;",[OTISConfig EmployeeID]];
        if (ret) {
            
        }else{
            SZLog(@"TAB_YEARLY_CHECK表INSERT失败！！！");
        }
        
    }];
    
    
}


+(NSInteger)qyaryYearlyCheckDateWithUnitNo:(NSString *)unitNo{
    
   __block NSInteger ADATE = 0;
    [OTISDB inDatabase:^(FMDatabase *db) {
        
        FMResultSet *set = [db executeQueryWithFormat:@"SELECT YCHECK_ADATE \
                            FROM TAB_YEARLY_CHECK \
                            WHERE UnitNo=%@ AND YCHECK_PDATE AND EmployeeId=%@ ;",unitNo,[OTISConfig EmployeeID]];
        while ([set next]) {
            
            ADATE = [set longForColumn:@"YCHECK_ADATE"];
        }
        
        
        
        
    }];
    return ADATE;
    
}


@end
