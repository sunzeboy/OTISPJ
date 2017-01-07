//
//  SZTable_Building.m
//  OTIS_PJ
//
//  Created by sunze on 16/4/29.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "SZTable_Building.h"
#import "TablesAndFields.h"
#import "SZBuilding.h"
#import "SZTable_UserSupervisor.h"
#import "SZTable_Unit.h"
#import "SZFinalOutsidePlanMaintenanceItem.h"
#import "SZTable_UserRoute.h"
#import "SZTable_Schedules.h"

@implementation SZTable_Building
+(void)initialize{
    
    
    
    [OTISDB inDatabase:^(FMDatabase *db) {
       
    }];

}
/**
 *  存储到BuildingDB
 *
 *  @param params
 */
+(void)storageBuildings:(NSArray *)buildings{
    
    SZLog(@"工地表存储中...%@",[NSThread currentThread]);
    if (buildings.count == 0)return;
    
    
    
    [OTISDB inDatabase:^(FMDatabase *db) {
        NSString *sqlDelet = [NSString stringWithFormat:@"DELETE  FROM t_Building WHERE EmployeeID = %@;",[OTISConfig EmployeeID]];
        BOOL ret = [db executeUpdate:sqlDelet];
        if (ret) {

        }else{
            SZLog(@"错误：删除t_Building失败");
        }
        

        
        NSInteger cal = buildings.count%kNumberOfEachDeposit;
        NSInteger frequency = buildings.count/kNumberOfEachDeposit;
        
        for (NSInteger fre = 0; fre<frequency; fre++){
            
            NSMutableString *sql = [NSMutableString stringWithFormat:@"%@", @"INSERT INTO t_Building (EmployeeID,BuildingNo, SupervisorNo,Route,BuildingName,BuildingAddr) VALUES"];
            
            for (NSInteger i =kNumberOfEachDeposit*fre; i<kNumberOfEachDeposit*(fre +1); i++) {
                SZBuilding *building= buildings[i];
                if ([building.Name containsString:@"'"]) {
                    building.Name  = [building.Name stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
                }
                if ([building.Addr containsString:@"'"]) {
                    building.Addr  = [building.Name stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
                }
                NSString *strSqlSuffix = [NSString stringWithFormat:@"('%@',%ld,\
                                          %ld,\
                                          '%@',\
                                          '%@',\
                                          '%@'),",
                                          [OTISConfig EmployeeID],
                                          (long)building.BuildingNo,
                                          (long)building.SupervisorNo,
                                          building.Route,
                                          building.Name,
                                          building.Addr];
                [sql appendString:strSqlSuffix];
                
            }
            
            
            [sql deleteCharactersInRange:NSMakeRange([sql length]-1, 1)];
            BOOL a = [db executeUpdate:sql];
            if (!a) {
                NSLog(@"错误：初始化t_Building插入失败1");
            }
            
            
        }
        
        NSMutableString *sql = [NSMutableString stringWithFormat:@"%@", @"INSERT INTO t_Building (EmployeeID,BuildingNo, SupervisorNo,Route,BuildingName,BuildingAddr) VALUES"];
        
        for (NSInteger i =kNumberOfEachDeposit*frequency; i<kNumberOfEachDeposit*frequency +cal; i++) {
            SZBuilding *building= buildings[i];
            if ([building.Name containsString:@"'"]) {
                building.Name  = [building.Name stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
            }
            if ([building.Addr containsString:@"'"]) {
                building.Addr  = [building.Name stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
            }
            NSString *strSqlSuffix = [NSString stringWithFormat:@"('%@',%ld,\
                                      %ld,\
                                      '%@',\
                                      '%@',\
                                      '%@'),",
                                      [OTISConfig EmployeeID],
                                      (long)building.BuildingNo,
                                      (long)building.SupervisorNo,
                                      building.Route,
                                      building.Name,
                                      building.Addr];
            [sql appendString:strSqlSuffix];
        }
        
        [sql deleteCharactersInRange:NSMakeRange([sql length]-1, 1)];
        BOOL a = [db executeUpdate:sql];
        if (!a) {
            NSLog(@"错误：初始化t_Building插入失败2");
        }
        

        
        
        SZLog(@"工地表储完成！%@",[NSThread currentThread]);
    }];

}


@end
