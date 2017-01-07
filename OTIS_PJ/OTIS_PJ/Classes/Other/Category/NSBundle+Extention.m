//
//  NSBundle+Extention.m
//  OTIS_PJ
//
//  Created by sunze on 16/4/22.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "NSBundle+Extention.h"

@implementation NSBundle (Extention)

+(NSString *)bundleVersionString
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
}

@end
