//
//  OTISConfig.h
//  OTIS_PJ
//
//  Created by sunze on 16/4/22.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OTISConfig : NSObject

+ (void)saveAccountWithEmployeeID:(NSString *)EmployeeID andPassword:(NSString *)password andUsername:(NSString *)username;

+ (void)clearccount;

+ (NSString *)EmployeeID;

+ (NSString *)userPW;

+(NSString *)username;
@end
