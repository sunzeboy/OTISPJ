//
//  SZDownload_V4Request.m
//  OTIS_PJ
//
//  Created by sunze on 16/4/22.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "SZDownload_V4Request.h"
#import "NSBundle+Extention.h"
#import "SZTable_Route.h"

@implementation SZDownload_V4Request

+(instancetype)v4Request
{
    SZDownload_V4Request *request = [[SZDownload_V4Request alloc] init];
    request.UserNo = [OTISConfig EmployeeID];
    request.Password = [OTISConfig userPW];
//    TabRoute  －1
    request.TimeStamp = [SZTable_Route timeStamp];
    request.Ver = APIVersion;
//    TabRoute		0
    request.ScheduleVer = [SZTable_Route scheduleVer];
    return request;
}


@end
