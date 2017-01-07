//
//  SZDownload_UnitsResponse.m
//  OTIS_PJ
//
//  Created by sunze on 16/4/27.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "SZDownload_UnitsResponse.h"

@implementation SZDownload_UnitsResponse

+(NSDictionary *)mj_objectClassInArray
{
    return @{
             @"Units" : @"SZUnit",
             @"Buildings" : @"SZBuilding"
             };
    
}



@end
