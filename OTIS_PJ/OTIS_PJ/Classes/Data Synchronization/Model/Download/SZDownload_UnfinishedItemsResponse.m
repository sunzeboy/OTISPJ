//
//  SZDownload_UnfinishedItemsResponse.m
//  OTIS_PJ
//
//  Created by sunze on 16/5/5.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "SZDownload_UnfinishedItemsResponse.h"

@implementation SZDownload_UnfinishedItemsResponse

+(NSDictionary *)mj_objectClassInArray
{
    return @{
             @"Report" : @"SZReport",
             @"Fix" : @"SZReport"
             };
    
}

@end
