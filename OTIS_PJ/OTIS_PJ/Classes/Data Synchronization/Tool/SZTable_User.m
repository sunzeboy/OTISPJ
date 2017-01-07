//
//  SZUser.m
//  OTIS_PJ
//
//  Created by sunze on 16/4/28.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "SZTable_User.h"
#import "TablesAndFields.h"
#import "NSError+Extention.h"
#import "NSDate+Extention.h"
@implementation SZTable_User

+(void)initialize
{
//    NSString *strCreateUser = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (%@ TEXT PRIMARY KEY, %@ TEXT NOT NULL,%@ TEXT NOT NULL,%@ TEXT NOT NULL,%@ TEXT NOT NULL,%@ BOOL,%@ INTEGER,%@ INTEGER);",t_User,
//                               EmployeeID,
//                               UserNo,
//                               PassWord,
//                               Name,
//                               Phone,
//                               IsLocked,
//                               LastLoginDate,
//                               LastConnectDate];
//     [OTISDB executeUpdate:strCreateUser];

    [OTISDB inDatabase:^(FMDatabase *db) {
        
    }];
    
}



#pragma mark - 用户表
/**
 *  存储到用户DB
 *
 *  @param dic 参数
 */
+(void)storageTabUserWithRequest:(SZLoginRequest *)request Params:(SZUserInfo *)userInfo
{
    
    [[NSUserDefaults standardUserDefaults] setObject:request.UserNo forKey:request.UserNo];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [OTISDB inDatabase:^(FMDatabase *db) {
        /**
         *  如果有一样的UserNo，先删除再存储
         */
        [db executeUpdateWithFormat:@"delete from t_User WHERE UserNo = %@;",userInfo.UserNo];
        
        BOOL ret =[db executeUpdateWithFormat:@"INSERT INTO t_User (UserNo,\
         EmployeeID ,\
         PassWord,\
         Name,\
         Phone,\
         IsLocked,\
         LastLoginDate,\
         LastConnectDate) VALUES (%@, %@,%@, %@,%@, %d,%ld, %ld);",
         userInfo.UserNo,
         userInfo.EmployeeID,
         request.Password,
         userInfo.Name,
         userInfo.Phone,
         FALSE,
         userInfo.LastLoginDate,
         userInfo.LastConnectDate];
        SZLog(@"-----保存UserNo成功！！！");

        if (ret) {
            SZLog(@"t_User表插入数据成功！！！");
        }else{
            SZLog(@"t_User表插入数据失败！！！");
        }

    }];

}


/**
 *  本地登录
 *
 *  @param request 登陆请求
 *  @param success 成功
 *  @param failure 失败
 */
+(void)loginWithRequest:(SZLoginRequest *)request success:(void(^)())success failure:(void(^)(NSError *error))failure{
     NSError *err = nil;
    
    NSString* UserNo=[[NSUserDefaults standardUserDefaults] objectForKey:request.UserNo];
    if (UserNo==nil||[UserNo isEqualToString:@""]) {
        err = [NSError errorWithUserInfo:SZLocal(@"error.OTISLoginStateNoOnlineLoginToday")];
        failure(err);
        return;
    }
    __block SZUserInfo *userIf = [[SZUserInfo alloc]init];
    __block NSString * lastConnectDate;
    __block NSInteger loginDateOver;
    //取得用户数据
    [OTISDB inDatabase:^(FMDatabase *db) {

        FMResultSet * set=[db executeQuery:@"SELECT * FROM t_User WHERE UserNo = ? AND Password = ?;",request.UserNo,request.Password];
        
        while ([set next]) {
            userIf.UserNo = [set stringForColumn:@"UserNo"];
            userIf.Password = [set stringForColumn:@"Password"];
            userIf.LastLoginDate = [[set stringForColumn:@"LastLoginDate"] integerValue];
            userIf.LastConnectDate = [[set stringForColumn:@"LastConnectDate"] integerValue];
            loginDateOver = [set longForColumn:@"LastLoginDate"];
            lastConnectDate = [set stringForColumn:@"LastConnectDate"];
        }
    }];

    NSInteger todayTeger=[[NSDate currentDate2] integerValue];
    
    if (userIf.UserNo == nil && userIf.UserNo.length == 0){
        err = [NSError errorWithUserInfo:SZLocal(@"error.OTISLoginStateWrongPassword")];
        failure(err);
        return;
    }
    
    if(todayTeger-loginDateOver != 0){
        err = [NSError errorWithUserInfo:SZLocal(@"error.OTISLoginStateNoOnlineLoginToday")];
        failure(err);
        return;
    }
    
    if (err) {
        failure(err);
    }else{
        success();
    }
}

//计算日期间隔天数
- (NSInteger)computeDaysWithDataFromString:(NSString *)string
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [gregorian setFirstWeekday:2];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *fromDate;
    NSDate *toDate;
    [gregorian rangeOfUnit:NSCalendarUnitDay startDate:&fromDate interval:NULL forDate:[dateFormatter dateFromString:string]];
    [gregorian rangeOfUnit:NSCalendarUnitDay startDate:&toDate interval:NULL forDate:[NSDate date]];
    NSDateComponents *dayComponents = [gregorian components:NSCalendarUnitDay fromDate:fromDate toDate:toDate options:0];
    
    return dayComponents.day;
}


/**
 *  根据参数更新User数据库
 *
 *  @param dic 参数
 */
+(void)updateTabUserWithParams:(NSDictionary *)dic{
    
    
    
}


/**
 *  根据UserNo获取EmployeeID
 *
 *  @param UserNo 用户名
 */
+(NSString *)EmployeeIDWithUserNo:(NSString *)UserNo{

   __block NSString *EmployeeID = nil;
    [OTISDB inDatabase:^(FMDatabase *db) {
        
        FMResultSet *set = [db executeQueryWithFormat:@"SELECT * FROM t_User WHERE UserNo = %@;",UserNo];
        
        while ([set next]) {
             EmployeeID = [set stringForColumn:@"EmployeeID"];
        }
        
    }];
       return EmployeeID;
}


@end
