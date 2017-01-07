//
//  SZTable_YearlyCheckDownload.m
//  OTIS_PJ
//
//  Created by sunze on 16/6/24.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "SZTable_YearlyCheckDownload.h"
#import "TablesAndFields.h"
#import "SZYearCheckItem.h"

@implementation SZTable_YearlyCheckDownload

+(void)initialize{
    
    
    
    [OTISDB inDatabase:^(FMDatabase *db) {
        
    }];
    
    
}


/**
 *  存储到YearlyCheckDB
 *
 *  @param params
 */
+(void)storageYearlyCheckWithParams:(NSArray *)YearlyCheckitems{

    if (YearlyCheckitems.count == 0) return;


    [OTISDB inDatabase:^(FMDatabase *db) {

        NSString *sqlDelet = [NSString stringWithFormat:@"DELETE  FROM TAB_YEARLY_CHECK_DOWNLOAD ;"];
        BOOL ret = [db executeUpdate:sqlDelet];
        if (ret) {
            SZLog(@"删除t_YearlyCheck成功");
        }else{
            SZLog(@"错误：初始化 删除t_YearlyCheck失败");
        }


        NSInteger cal = YearlyCheckitems.count%kNumberOfEachDeposit;
        NSInteger frequency = YearlyCheckitems.count/kNumberOfEachDeposit;


        for (NSInteger fre = 0; fre<frequency; fre++){

            NSMutableString *sql = [NSMutableString stringWithFormat:@"%@", @"INSERT INTO TAB_YEARLY_CHECK_DOWNLOAD (YCHECK_PDATE, YCHECK_ADATE,UnitNo,EmployeeID) VALUES "];
            for (NSInteger i =kNumberOfEachDeposit*fre; i<kNumberOfEachDeposit*(fre +1); i++) {
                SZYearCheckItem *item = YearlyCheckitems[i];
                NSString *strSqlSuffix = [NSString stringWithFormat:@"( %ld,%ld,'%@','%@'),",(long)item.PDate,(long)item.ADate,item.UnitNo,[OTISConfig EmployeeID]];
                [sql appendString:strSqlSuffix];

            }


            [sql deleteCharactersInRange:NSMakeRange([sql length]-1, 1)];
            BOOL a = [db executeUpdate:sql];
            if (!a) {
                NSLog(@"错误：初始化TAB_YEARLY_CHECK_DOWNLOAD 插入失败1");
            }


        }

        NSMutableString *sql = [NSMutableString stringWithFormat:@"%@", @"INSERT INTO TAB_YEARLY_CHECK_DOWNLOAD (YCHECK_PDATE, YCHECK_ADATE,UnitNo,EmployeeID) VALUES "];
        for (NSInteger i =kNumberOfEachDeposit*frequency; i<kNumberOfEachDeposit*frequency +cal; i++) {
            SZYearCheckItem *item = YearlyCheckitems[i];
            NSString *strSqlSuffix = [NSString stringWithFormat:@"( %ld,%ld,'%@','%@'),",(long)item.PDate,(long)item.ADate,item.UnitNo,[OTISConfig EmployeeID]];
            [sql appendString:strSqlSuffix];

        }
        
        [sql deleteCharactersInRange:NSMakeRange([sql length]-1, 1)];
        BOOL a = [db executeUpdate:sql];
        if (!a) {
            NSLog(@"错误：初始化TAB_YEARLY_CHECK_DOWNLOAD 插入失败1");
        }else{
            NSLog(@"插入成功");
        }


    }];


}

/**
 *  年检查询
 */
+(NSArray *)queryYearCheckItem{
    
    NSMutableArray *arrayData = [NSMutableArray array];
    
    NSString *strEmployeeID = [OTISConfig EmployeeID];
    
    [OTISDB inDatabase:^(FMDatabase *db) {
        
        FMResultSet *set = [db executeQueryWithFormat:@"SELECT  * \
                            FROM TAB_YEARLY_CHECK_DOWNLOAD \
                            WHERE   EmployeeID=%@;",strEmployeeID];
        while ([set next]) {
            
            SZYearCheckItem *unitItem = [[SZYearCheckItem alloc] init];
            unitItem.UnitNo = [set stringForColumn:@"UnitNo"];
            unitItem.PDate = [set longForColumn:@"YCHECK_PDATE"];
            unitItem.ADate = [set longForColumn:@"YCHECK_ADATE"];
//            SZLog(@"%ld",(long)unitItem.ADate);
            [arrayData  addObject:unitItem];
        }
        
    }];
    
    return [NSArray arrayWithArray:arrayData];
}
+(NSMutableDictionary *)queryYearCheckItemData{
    
    NSMutableDictionary *arrayDic = [NSMutableDictionary dictionary];
    
    NSString *strEmployeeID = [OTISConfig EmployeeID];
    
    [OTISDB inDatabase:^(FMDatabase *db) {
        
        FMResultSet *set = [db executeQueryWithFormat:@"SELECT  * \
                            FROM TAB_YEARLY_CHECK_DOWNLOAD \
                            WHERE   EmployeeID=%@;",strEmployeeID];
        while ([set next]) {
            
            SZYearCheckItem *unitItem = [[SZYearCheckItem alloc] init];
            unitItem.UnitNo = [set stringForColumn:@"UnitNo"];
            unitItem.PDate = [set longForColumn:@"YCHECK_PDATE"];
            unitItem.ADate = [set longForColumn:@"YCHECK_ADATE"];
            //            SZLog(@"%ld",(long)unitItem.ADate);
            [arrayDic  setObject:unitItem forKey:[NSString stringWithFormat:@"%@%ld",unitItem.UnitNo,unitItem.PDate]];
        }
        
    }];
    
    return arrayDic;
}

/**
 *  年检查询(我的)
 */
+(NSMutableDictionary *)queryDoneYearCheckItem{
    
    NSMutableDictionary *dicData = [NSMutableDictionary dictionary];
    
    NSString *strEmployeeID = [OTISConfig EmployeeID];
    
    [OTISDB inDatabase:^(FMDatabase *db) {
        
        FMResultSet *set = [db executeQueryWithFormat:@"SELECT UnitNo,YCHECK_PDATE, YCHECK_ADATE,IS_UPLOADING,EmployeeId,SAVE_YCHECK_PDATE FROM TAB_YEARLY_CHECK WHERE EmployeeId=%@ ;",strEmployeeID];
        while ([set next]) {
            
            SZFinalMaintenanceUnitItem *unitItem = [[SZFinalMaintenanceUnitItem alloc] init];
            unitItem.UnitNo = [set stringForColumn:@"UnitNo"];
            unitItem.CheckDate = [set longForColumn:@"YCHECK_PDATE"];
            unitItem.YCheckDate = [set longForColumn:@"YCHECK_ADATE"];
            unitItem.IS_UPLOADING = [set intForColumn:@"IS_UPLOADING"];
            unitItem.PDate_Save = [set longForColumn:@"SAVE_YCHECK_PDATE"];

            NSString *str = [NSString stringWithFormat:@"%@%ld",unitItem.UnitNo,(long)unitItem.PDate_Save];
            [dicData setObject:unitItem forKey:str];
        }
        
    }];
    
    return dicData;
}


@end
