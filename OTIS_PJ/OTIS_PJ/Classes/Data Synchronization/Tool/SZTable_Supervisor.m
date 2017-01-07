//
//  SZTable_Supervisor.m
//  OTIS_PJ
//
//  Created by sunze on 16/5/13.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "SZTable_Supervisor.h"
#import "TablesAndFields.h"
#import "SZTable_UserSupervisor.h"

@implementation SZTable_Supervisor
+(void)initialize
{
    
    [OTISDB inDatabase:^(FMDatabase *db) {
       
        
    }];
    
}


/**
 *  存储电梯版本号到Supervisor
 *
 *  @param dic 参数
 */
+(void)updateTabSupervisorWithUnitVer:(NSInteger)unitVer
{
    
    NSInteger supervisorNo = [SZTable_UserSupervisor supervisorNo];
    
    
    [OTISDB inDatabase:^(FMDatabase *db) {

        NSInteger SupervisorNoCount = 0;
        
        FMResultSet *set = [db executeQueryWithFormat:@"SELECT count(SupervisorNo) as SupervisorNoCount from t_Supervisor WHERE SupervisorNo = %ld;",(long)supervisorNo];
        while ([set next]) {
            SupervisorNoCount = [set intForColumn:@"SupervisorNoCount"];
        }
        if (SupervisorNoCount) {
            BOOL ret =[db executeUpdateWithFormat:@"UPDATE t_Supervisor SET  SupervisorNo = %ld,UnitVer = %ld WHERE EmployeeID = %@;",
                       (long)supervisorNo,
                       (long)unitVer,
                       [OTISConfig EmployeeID]];
            if (ret) {

            }else{
                SZLog(@"t_Supervisor表UPDATE失败！！！");
            }
            
        }else{
            
            BOOL ret =[db executeUpdateWithFormat:@"INSERT INTO t_Supervisor (SupervisorNo,UnitVer,EmployeeID) VALUES (%ld, %ld,%@);",
                       (long)supervisorNo,
                       (long)(long)unitVer,
                       [OTISConfig EmployeeID]];
            if (ret) {

            }else{
                SZLog(@"t_Supervisor表INSERT失败！！！");
            }
            
            
        }

    }];
    
}
/**
 *  获取电梯版本号
 */
+(NSString *)unitUpdateVer{
    
    __block NSString *UnitVer = @"-1";
    
    [OTISDB inDatabase:^(FMDatabase *db) {
        
        FMResultSet *set = [db executeQueryWithFormat:@"SELECT * FROM t_Supervisor WHERE SupervisorNo = %ld AND EmployeeID = %@;",(long)[SZTable_UserSupervisor supervisorNo],[OTISConfig EmployeeID]];
        while ([set next]) {
            UnitVer = [NSString stringWithFormat:@"%ld",[set longForColumn:@"UnitVer"]];
            
        }
        
        
    }];
    
    return UnitVer;
}


@end
