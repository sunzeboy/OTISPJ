//
//  UIDevice+Extention.m
//  OTIS_PJ
//
//  Created by sunze on 16/4/22.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "UIDevice+Extention.h"

@implementation UIDevice (Extention)

+(NSString *)currentDeviceUUIDString
{
    return [[UIDevice currentDevice] identifierForVendor].UUIDString;
}

@end
