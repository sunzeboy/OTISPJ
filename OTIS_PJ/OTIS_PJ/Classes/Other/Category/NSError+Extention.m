//
//  NSError+Extention.m
//  OTIS_PJ
//
//  Created by sunze on 16/4/26.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "NSError+Extention.h"

@implementation NSError (Extention)

+(instancetype)errorWithUserInfo:(NSString *)desc
{
    NSString *domain = @"com.sunzeboy.OTIS_PJ.ErrorDomain";
    NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : desc };
    NSError *error = [NSError errorWithDomain:domain code:-101 userInfo:userInfo];
    return error;
}

@end
