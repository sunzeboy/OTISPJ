//
//  SZTable_Unit.m
//  OTIS_PJ
//
//  Created by sunze on 16/4/28.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "SZTable_Unit.h"
#import "TablesAndFields.h"

@implementation SZTable_Unit


+(void)initialize
{
    

    
        
    
    
    
}

#pragma mark - 电梯表
/**
 *  存储到电梯DB
 */
+(void)storageUnits:(NSArray *)units{
    
    if (units.count == 0) return;
    
    
    [OTISDB inDatabase:^(FMDatabase *db) {
 
        NSString *sqlDelet = [NSString stringWithFormat:@"DELETE  FROM t_Units WHERE EmployeeID = %@;",[OTISConfig EmployeeID]];

        BOOL ret = [db executeUpdate:sqlDelet];
        if (ret) {

        }else{
            SZLog(@"删除t_Units失败");
        }

        
        NSInteger cal = units.count%kNumberOfEachDeposit;
        NSInteger frequency = units.count/kNumberOfEachDeposit;
        
        for (NSInteger fre = 0; fre<frequency; fre++){
            
            NSMutableString *sql = [NSMutableString stringWithFormat:@"%@", @"INSERT INTO t_Units (EmployeeID,UnitNo, RouteNo,Route,ContractNo,ModelType, CardType,Examliterval, Owner,Tel, Email,CurrentStatus, BuildingNo, YCheckDate,UnitRegcode,UnitStatus,UnitName) VALUES "];
            
            for (NSInteger i =kNumberOfEachDeposit*fre; i<kNumberOfEachDeposit*(fre +1); i++) {
                SZUnit *unit = units[i];
                NSString *strSqlSuffix = [NSString stringWithFormat:@"('%@','%@', %ld,'%@','%@','%@',%ld,%ld,'%@','%@','%@','%@',%ld,%ld,'%@','%@','%@'),",[OTISConfig EmployeeID],unit.UnitNo,
                                          (long)unit.RouteNo,
                                          unit.Route,
                                          unit.ContractNo,
                                          unit.ModelType,
                                          (long)unit.CardType,
                                          (long)unit.Examliterval,
                                          unit.Owner,
                                          unit.Tel,
                                          unit.Email,
                                          unit.CurrentStatus,
                                          (long)unit.BuildingNo,
                                          (long)unit.YCPDate,
                                          unit.UnitRegcode,
                                          unit.UnitStatus,
                                          unit.UnitName?:@""];
                [sql appendString:strSqlSuffix];
                
            }
            
            
            [sql deleteCharactersInRange:NSMakeRange([sql length]-1, 1)];
            BOOL a = [db executeUpdate:sql];
            if (!a) {
                NSLog(@"错误：t_Units 初始化1");
            }
            
            
        }
        
        NSMutableString *sql = [NSMutableString stringWithFormat:@"%@", @"INSERT INTO t_Units (EmployeeID,UnitNo, RouteNo,Route,ContractNo,ModelType, CardType,Examliterval, Owner,Tel, Email,CurrentStatus, BuildingNo, YCheckDate,UnitRegcode,UnitStatus,UnitName) VALUES "];
        
        for (NSInteger i =kNumberOfEachDeposit*frequency; i<kNumberOfEachDeposit*frequency +cal; i++) {
            SZUnit *unit = units[i];
            NSString *strSqlSuffix = [NSString stringWithFormat:@"('%@','%@', %ld,'%@','%@','%@',%ld,%ld,'%@','%@','%@','%@',%ld,%ld,'%@','%@','%@'),",[OTISConfig EmployeeID],unit.UnitNo,
                                      (long)unit.RouteNo,
                                      unit.Route,
                                      unit.ContractNo,
                                      unit.ModelType,
                                      (long)unit.CardType,
                                      (long)unit.Examliterval,
                                      unit.Owner,
                                      unit.Tel,
                                      unit.Email,
                                      unit.CurrentStatus,
                                      (long)unit.BuildingNo,
                                      (long)unit.YCPDate,
                                      unit.UnitRegcode,
                                      unit.UnitStatus,
                                      unit.UnitName?:@""];
            [sql appendString:strSqlSuffix];
            
        }
        
        [sql deleteCharactersInRange:NSMakeRange([sql length]-1, 1)];
        BOOL a = [db executeUpdate:sql];
        if (!a) {
            NSLog(@"错误：t_Units 初始化2");
        }

//        NSArray *arrayUnitNo = @[@"D7NA8290",@"D7NA8293",@"D7NA8288",@"D7NA8294",@"D7NA8292",@"D7NA8287",@"D7NA8291",@"D7NA8289"];
//        NSArray *arrayQRCode = @[@"31303101152007010255",@"31103101152006120489",@"31103101152006120490",@"34003101152007020628",@"31103101152006120488",@"31103101152006120487",@"31103101152006120486",@"31303101152007010254"];
//        NSArray *arrayDizhi = @[@"Shanghai 上海",@"Shanghai 上海",@"Shanghai 上海",@"Shanghai 上海",@"Shanghai 上海",@"Shanghai 上海",@"Shanghai 上海",@"Shanghai 上海"];
//        NSArray *arrayOwner = @[@"ZSZ张胜曾",@"ZSZ张胜曾",@"ZSZ张胜曾",@"ZSZ张胜曾",@"ZSZ张胜曾",@"ZSZ张胜曾",@"ZSZ张胜曾",@"ZSZ张胜曾"];
//        NSArray *arrayBuildingName = @[@"YSMD优胜美地酒店(BYDJ博亚大酒店)",@"YSMD优胜美地酒店(BYDJ博亚大酒店)",@"YSMD优胜美地酒店(BYDJ博亚大酒店)",@"YSMD优胜美地酒店(BYDJ博亚大酒店)",@"YSMD优胜美地酒店(BYDJ博亚大酒店)",@"YSMD优胜美地酒店(BYDJ博亚大酒店)",@"YSMD优胜美地酒店(BYDJ博亚大酒店)",@"YSMD优胜美地酒店(BYDJ博亚大酒店)"];
//        NSMutableString *sql2 = [NSMutableString stringWithFormat:@"%@", @"INSERT INTO t_Units (EmployeeID,UnitNo, Owner,UnitRegcode) VALUES "];
//        for (int i=0; i< 8; i++) {
//            NSString *strSqlSuffix = [NSString stringWithFormat:@"('%@','%@', '%@','%@'),",[OTISConfig EmployeeID],arrayUnitNo[i],arrayOwner[i],arrayQRCode[i]];
//            [sql2 appendString:strSqlSuffix];
//        }
//        BOOL b = [db executeUpdate:sql2];
//        if (!b) {
//            NSLog(@"插入失败");
//        }
//        
//        
//        NSMutableString *sql3 = [NSMutableString stringWithFormat:@"%@", @"INSERT INTO t_Building (EmployeeID,UnitNo, Owner,UnitRegcode) VALUES "];
//        for (int i=0; i< 8; i++) {
//            NSString *strSqlSuffix = [NSString stringWithFormat:@"('%@','%@', '%@','%@'),",[OTISConfig EmployeeID],arrayUnitNo[i],arrayOwner[i],arrayQRCode[i]];
//            [sql3 appendString:strSqlSuffix];
//        }
//        BOOL b = [db executeUpdate:sql3];
//        if (!b) {
//            NSLog(@"插入失败");
//        }
    }];
    

}


+(void)updateUnScanReasons:(NSArray *)reasons{
    if (reasons.count == 0) return;
    [OTISDB inDatabase:^(FMDatabase *db) {
//        NSMutableString *sql = [NSMutableString stringWithFormat:@"%@", @"UPDATE  t_Units SET IsScaned = %d, IsNeedDialog = %d WHERE UnitNo = '%@' ;"];

        NSString *sqlDelet = [NSString stringWithFormat:@"DELETE  FROM TAB_UNIT_UN_SCANED_REASON ;"];
        BOOL ret = [db executeUpdate:sqlDelet];
        if (ret) {
            SZLog(@"删除TAB_UNIT_UN_SCANED_REASON成功");
        }else{
            SZLog(@"删除TAB_UNIT_UN_SCANED_REASON失败");
        }

        
        
        NSInteger cal = reasons.count%kNumberOfEachDeposit;
        NSInteger frequency = reasons.count/kNumberOfEachDeposit;
        
        for (NSInteger fre = 0; fre<frequency; fre++){
            
            NSMutableString *sql = [NSMutableString stringWithFormat:@"%@", @"INSERT INTO TAB_UNIT_UN_SCANED_REASON (UnitNo, IsScaned,IsNeedDialog) VALUES "];
            
            for (NSInteger i =kNumberOfEachDeposit*fre; i<kNumberOfEachDeposit*(fre +1); i++) {
                SZUnitScanedItem *unit = reasons[i];
                NSString *strSqlSuffix = [NSString stringWithFormat:@"('%@', %d,%d),",unit.UnitNo,
                                          unit.IsScaned,
                                          unit.IsNeedDialog];
                [sql appendString:strSqlSuffix];
                
            }
            
            
            [sql deleteCharactersInRange:NSMakeRange([sql length]-1, 1)];
            BOOL a = [db executeUpdate:sql];
            if (!a) {
                NSLog(@"错误：初始化TAB_UNIT_UN_SCANED_REASON插入失败1");
            }
            
            
        }
        
        NSMutableString *sql = [NSMutableString stringWithFormat:@"%@", @"INSERT INTO TAB_UNIT_UN_SCANED_REASON (UnitNo, IsScaned,IsNeedDialog) VALUES "];
        
        for (NSInteger i =kNumberOfEachDeposit*frequency; i<kNumberOfEachDeposit*frequency +cal; i++) {
            SZUnitScanedItem *unit = reasons[i];
            NSString *strSqlSuffix = [NSString stringWithFormat:@"('%@', %d,%d),",unit.UnitNo,
                                      unit.IsScaned,
                                      unit.IsNeedDialog];
            [sql appendString:strSqlSuffix];
        }
        
        [sql deleteCharactersInRange:NSMakeRange([sql length]-1, 1)];
        BOOL a = [db executeUpdate:sql];
        if (!a) {
            NSLog(@"错误：初始化TAB_UNIT_UN_SCANED_REASON插入失败2");
        }
        
        
    }];


}


/**
 *  根据请求参数去沙盒中加载缓存的电梯数据
 *
 *  @param params 请求参数
 */
+(NSArray *)readTabUnitWithParams:(NSDictionary *)params{
    
    return nil;
}





@end
