//
//  SZTable_ReservedSubject.m
//  OTIS_PJ
//
//  Created by sunze on 16/5/9.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "SZTable_ReservedSubject.h"
#import "TablesAndFields.h"

//预留科目记录表
@implementation SZTable_ReservedSubject

/**
 *  存储到ReservedSubjectDB
 *
 *  @param params
 */
+(void)storageReservedSubjectWithParams:(NSDictionary *)params{

    /**
     *  如果有一样的UserNo，先删除再存储
     */
//    [OTISDB executeUpdateWithFormat:@"delete from t_User WHERE UserNo = %@;",userInfo.UserNo];
//    
//    [OTISDB executeUpdateWithFormat:@"INSERT INTO t_User (UserNo,\
//     EmployeeID ,\
//     PassWord,\
//     Name,\
//     Phone,\
//     IsLocked,\
//     LastLoginDate,\
//     LastConnectDate) VALUES (%@, %@,%@, %@,%@, %d,%ld, %ld);",
//     userInfo.UserNo,
//     userInfo.EmployeeID,
//     request.Password,
//     userInfo.Name,
//     userInfo.Phone,
//     FALSE,
//     userInfo.LastLoginDate,
//     userInfo.LastConnectDate];
//    SZLog(@"-----保存UserNo成功！！！");

}
/**
 *  根据请求参数去沙盒中加载缓存的ReservedSubject数据
 *
 *  @param params 请求参数
 */
+(NSArray *)readReservedSubjectWithParams:(NSDictionary *)params{

    return nil;
}

@end
