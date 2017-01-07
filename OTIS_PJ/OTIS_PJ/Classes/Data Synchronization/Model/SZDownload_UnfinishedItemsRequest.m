//
//  SZDownload_UnfinishedItemsRequest.m
//  OTIS_PJ
//
//  Created by sunze on 16/4/22.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "SZDownload_UnfinishedItemsRequest.h"
#import "NSBundle+Extention.h"
#import "SZTable_Route.h"

@implementation SZDownload_UnfinishedItemsRequest

+(instancetype)unfinishedItemsRequest
{
    SZDownload_UnfinishedItemsRequest *request = [[SZDownload_UnfinishedItemsRequest alloc] init];
    request.UserNo = [OTISConfig EmployeeID];
    request.Password = [OTISConfig userPW];
//    当前年份
    request.Year = @"2016";
    request.Ver = APIVersion;
//    TabRoute
    request.ReportStamp = [SZTable_Route reportDate];
    request.FixStamp = [SZTable_Route fixDate];
    
    return request;
}


@end
