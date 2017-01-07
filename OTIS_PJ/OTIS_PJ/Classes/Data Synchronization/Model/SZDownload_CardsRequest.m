//
//  SZDownload_CardsRequest.m
//  OTIS_PJ
//
//  Created by sunze on 16/4/22.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "SZDownload_CardsRequest.h"
#import "NSBundle+Extention.h"
#import "SZTable_System.h"

@implementation SZDownload_CardsRequest

+(instancetype)cardsRequest
{
    SZDownload_CardsRequest *request = [[SZDownload_CardsRequest alloc] init];
    request.UserNo = [OTISConfig EmployeeID];
    request.Password = [OTISConfig userPW];
//    TabSys		0
    request.UpdateVer = [SZTable_System updateVer];
    request.Ver = APIVersion;
    return request;
}

@end
