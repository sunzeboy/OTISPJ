//
//  SZDownload_UnitsRequest.m
//  OTIS_PJ
//
//  Created by sunze on 16/4/22.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "SZDownload_UnitsRequest.h"

#import "NSBundle+Extention.h"

#import "SZTable_Supervisor.h"


@implementation SZDownload_UnitsRequest

+(instancetype)unitsRequest
{
    SZDownload_UnitsRequest *request = [[SZDownload_UnitsRequest alloc] init];
    request.UserNo = [OTISConfig EmployeeID];
    request.Password = [OTISConfig userPW];
//    TabSupervisor		－1
    request.UpdateVer = [SZTable_Supervisor unitUpdateVer];
    request.Ver = APIVersion;
    return request;
}

@end
