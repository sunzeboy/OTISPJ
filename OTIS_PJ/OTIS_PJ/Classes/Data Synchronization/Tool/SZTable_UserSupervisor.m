//
//  SZTable_UserSupervisor.m
//  OTIS_PJ
//
//  Created by sunze on 16/4/29.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "SZTable_UserSupervisor.h"
#import "TablesAndFields.h"

@implementation SZTable_UserSupervisor



/**
 *  存储到UserSupervisorDB
 *
 *  @param params
 */
+(void)storageUserSupervisorNo:(NSInteger)SupervisorNo{
    [OTISDB inDatabase:^(FMDatabase *db) {
        [db executeUpdateWithFormat:@"delete from t_UserSupervisor WHERE EmployeeID = %@ AND SupervisorNo = %ld;",[OTISConfig EmployeeID],(long)SupervisorNo];
        
        BOOL ret = [db executeUpdateWithFormat:@"INSERT INTO t_UserSupervisor(EmployeeID, SupervisorNo) VALUES (\
                    %@,\
                    %ld);",
                    [OTISConfig EmployeeID],
                    (long)SupervisorNo];
        if (ret) {
            SZLog(@"t_UserSupervisor表插入数据成功！！！");
        }else{
            SZLog(@"t_UserSupervisor表插入数据失败！！！");
        }
    }];
    

}
/**
 *  根据请求参数去沙盒中加载缓存的UserSupervisor数据
 *
 *  @param params 请求参数
 */
+(NSArray *)supervisors{
    NSMutableArray *array = [NSMutableArray array];
    
    
    [OTISDB inDatabase:^(FMDatabase *db) {
        
        FMResultSet *set1 = [db executeQueryWithFormat:@"SELECT * FROM t_UserSupervisor WHERE EmployeeID = %@;",[OTISConfig EmployeeID]];
        while ([set1 next]) {
            
            [array addObject:@([set1 longForColumn:@"SupervisorNo"])];
        }
    }];
    //    SZLog(@"routNos--------------%@ %ld",[NSThread currentThread],array.count);
    
    
    return [NSArray arrayWithArray:array];

}

+(NSString *)supervisorsStr{
    NSMutableArray *array = [NSMutableArray array];
    
    
    [OTISDB inDatabase:^(FMDatabase *db) {
        
        FMResultSet *set1 = [db executeQueryWithFormat:@"SELECT * FROM t_UserSupervisor WHERE EmployeeID = %@;",[OTISConfig EmployeeID]];
        while ([set1 next]) {
            
            [array addObject:@([set1 longForColumn:@"SupervisorNo"])];
        }
    }];
    //    SZLog(@"routNos--------------%@ %ld",[NSThread currentThread],array.count);
    
    
    
    NSString *strSupervisors = [array componentsJoinedByString:@","];
    return strSupervisors;
    
}

/**
 *  查找当前EmployeeID关联的所有supervisor
 *
 *  @param params 请求参数
 */
+(NSInteger)supervisorNo{
    
    __block NSInteger SupervisorNo = 0;

    [OTISDB inDatabase:^(FMDatabase *db) {
        FMResultSet *set1 = [db executeQueryWithFormat:@"SELECT * FROM t_UserSupervisor WHERE EmployeeID = %@;",[OTISConfig EmployeeID]];
        while ([set1 next]) {
            SupervisorNo = [set1 longForColumn:@"SupervisorNo"];
            
        }
    }];
    
    return SupervisorNo;

}


@end
