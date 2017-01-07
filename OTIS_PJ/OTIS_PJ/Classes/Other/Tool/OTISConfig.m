//
//  OTISConfig.m
//  OTIS_PJ
//
//  Created by sunze on 16/4/22.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "OTISConfig.h"


NSString * const kUsername = @"Username";
NSString * const kEmployeeID = @"EmployeeID";
NSString * const kPassWord = @"passWord";


@implementation OTISConfig


+ (void)saveAccountWithEmployeeID:(NSString *)EmployeeID andPassword:(NSString *)password andUsername:(NSString *)username{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:EmployeeID ?: @"" forKey:kEmployeeID];
    [userDefaults setObject:password ?: @"" forKey:kPassWord];
    [userDefaults setObject:username ?: @"" forKey:kUsername];
    [userDefaults synchronize];
}

+ (void)clearccount{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:@"" forKey:kPassWord];
    [userDefaults setObject:@"" forKey:kEmployeeID];
    [userDefaults synchronize];
}


+(NSString *)EmployeeID{
    
    return [USER_DEFAULT objectForKey:kEmployeeID];
}

+(NSString *)userPW{
    return [USER_DEFAULT objectForKey:kPassWord];
}

+(NSString *)username{
    return [USER_DEFAULT objectForKey:kUsername];
}


@end
