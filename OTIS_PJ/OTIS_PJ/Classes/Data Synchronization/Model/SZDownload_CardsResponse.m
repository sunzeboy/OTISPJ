//
//  SZDownload_CardsResponse.m
//  OTIS_PJ
//
//  Created by sunze on 16/4/27.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "SZDownload_CardsResponse.h"

@implementation SZDownload_CardsResponse

+(NSDictionary *)mj_objectClassInArray
{
    return @{
             @"Items" : @"SZCard",
             @"Schedule" : @"SZScheduleCheckItem"
             };
    
}


@end
